//
//  FilesViewModel.swift
//  Diplom
//
//  Created by Nor1 on 05.07.2022.
//

import UIKit



class FilesViewModel {
    static var isDeleted: Bool?
    static var isChanged: Bool?
    static var changedName: String?
    static var docVC: Bool?
    
    var folderObs : Obs<[DiskFileModel]> = Obs([])
    var recentlyObs : Obs<[DiskFileModel]> = Obs([])
    var postedObs : Obs<[DiskFileModel]> = Obs([])
    var typeVC : String?
    

    typealias Routes = DocRoute & ImageRoute & FolderRoute & EditRoute & WebRoute
    private let route : Routes

    init(route: Routes) {
        self.route = route
        }
    let postedCD = PostedCD()
    let recentlyCD = RecentlyCD()
    var networkService = NetworkService()
    var path : String = "disk:/"
        
//MARK: - переходы для роутера
    
    func openWeb(title: String, path: String){
        route.openWeb(title: title, path: path)
    }
    
    func openEdit(title: String, path: String, file: String, image: UIImage){
        route.openEdit(title: title, path: path, file: file, image: image)
    }
    
    func openFolder(title: String, path: String){
        route.openFolder(title: title, path: path)
        
    }
    func openImage(title: String, path: String, date: String, onDisk: String, tableView: UITableView){
        route.openImage(title: title, path: path, date: date, onDisk: onDisk)
    }
    func openDoc(title: String, path: String, file: String){
        route.openDoc(title: title, path: path, file: file)
    }
//    MARK: - последние файлы
    func getRecentlyFiles(isRefresh: Bool) {
        if !isRefresh{
        networkService.getRecentlyFiles(limit: 15) { array in
            guard let array = array else {
                self.recentlyObs.value = self.convertArray(array: self.recentlyCD.showCoreDataRecently())
                return
            }
            self.recentlyObs.value = self.convertArray(array: array)
            self.recentlyCD.saveToCoreData(array: array)
            }
        } else {
            networkService.getRecentlyFiles(limit: -(15*paddingDoneRecently)) { array in
                guard let array = array else {
                    self.recentlyObs.value = self.convertArray(array: self.recentlyCD.showCoreDataRecently())
                    return
                }
                self.recentlyObs.value = self.convertArray(array: array)
                self.recentlyCD.saveToCoreData(array: array)
                self.recentlyCD.checkForChanges()
                self.paddingDoneRecently = 0
                }
        }
    }
    private var paddingDoneRecently = 0
    func getRecentlyFilesPadding() -> Bool{
        var isEnd : Bool?
        networkService.getRecentlyFiles(limit: 15) { array in
            guard let array = array else {
                return
            }
            if !array.isEmpty {
                self.paddingDoneRecently += 1
                self.recentlyObs.value.append(contentsOf: self.convertArray(array: array.suffix(15)))
                isEnd = false
            } else {
                isEnd = true
            }
        }
        return isEnd ?? true
    }
//    MARK: - опубликованные файлы
    private var paddingDonePosted = 0
    func getPostedFiles(isRefresh: Bool) {
        if isRefresh {
        networkService.getPostedFiles(offSet: -(15*paddingDonePosted)) { array in
            guard let array = array else {
                self.postedObs.value = self.convertArray(array: self.postedCD.showCoreDataRecently())
                return
            }
            self.postedObs.value = self.convertArray(array: array)
            self.paddingDonePosted = 0
            }
        } else {
            networkService.getPostedFiles(offSet: 0){ array in
                guard let array = array else {
                    self.postedObs.value = self.convertArray(array: self.postedCD.showCoreDataRecently())
                    return
                }
                self.postedObs.value = self.convertArray(array: array)
                self.postedCD.saveToCoreData(array: array)
                self.postedCD.checkForChanges()
            }
        }
    }
    func getPostedFilesPadding() -> Bool{
        var isEnd: Bool?
        networkService.getPostedFiles(offSet: 15){ array in
            guard let array = array else {
                return
            }

            self.paddingDonePosted += 1
            if !array.isEmpty {
                self.postedObs.value.append(contentsOf: self.convertArray(array: array))
                isEnd = false
            } else {
                isEnd = true
            }
        }
        return isEnd ?? true
    }
//    MARK: - функция для удаления публикации
    func removePublished(path: String, complition: @escaping(_ bool: Bool)->Void){
        networkService.deletePublished(path: path){bool in
           complition(bool)
        }
    }
//    MARK: - функция для удаления файла
    func deleteFile(path: String, complition: @escaping(_ bool: Bool)->Void){
        networkService.deleteFile(path: path){ bool in
            complition(bool)
        }
    }
//    MARK: - внутренние функции преобразования текста
    private func convertArray(array : [DiskFileModel]) -> [DiskFileModel] {
        var returnArray : [DiskFileModel] = []
        for item in array {
            if (item.name != nil) && (item.created != nil) {
                returnArray.append(DiskFileModel(name: divByDot(name: item.name ?? ""), created: convertDate(date: item.created ?? ""), path: item.path, type: item.type, file: item.file, preview: item.preview, media_type: item.media_type, total: item.total, size: convertSize(size: item.size ?? 000.0), preview_loaded: nil, file_loaded: nil))
            }
        }
        return returnArray
    }
    
    private func divByDot(name:String) -> String {
        let splitedName = name.split(separator: ".")
        var returnName = ""
        if splitedName.count > 1 {
            for i in 0...splitedName.count - 2 {
                returnName += splitedName[i]
            }
        } else {
            returnName = name
        }
        return returnName
    }
    
    private func convertDate(date:String) -> String {
        let formatter = DateFormatter()
        let formatterCompl = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatterCompl.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let oldDate = formatterCompl.date(from: date)
        let newDate = formatter.string(from: oldDate ?? Date())
        return newDate
    }
    
    private func convertSize(size: Double) -> Double {
        let a = size / pow(2, 20)
        let b = Double(round(10*a)/10)
        if b == 0.0 {
            return 0.1
        } else {
        return b
        }
    }
}


