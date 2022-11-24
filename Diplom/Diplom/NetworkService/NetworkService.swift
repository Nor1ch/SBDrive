//
//  NetworkService.swift
//  Diplom
//
//  Created by Nor1 on 14.07.2022.
//

import Foundation
import Alamofire
import UIKit
import Network
import WebKit

class NetworkService {
//MARK: - OBS
    var filesObs : Obs<[DiskFileModel]> = Obs([])
    var folderWithData : [DiskFileModel] = []
    var offset : Int = 0
    private let token = UserDefaultsToken.loadToken()
    private var limitRecently = 0
    private var offsetPosted = 0
    private var base : [DiskFileModel] = []
    var baseWithData : [DiskFileModel] = []
    
    
//    private let networkReachability = NetworkReachabilityManager(host: "www.google.com")
//    let token = "AQAAAABiugXTAADLWym7IIjlWU6Si_t1pJSEt48"
    
//MARK: - функция для получения информации о диске
    
    func getInformationAboutDisk(complition: @escaping(_ model: ProfileViewModelBase?)-> Void) {
        guard let token = token else {
            print("fix token")
            return
        }
        DispatchQueue.global().async {
        AF.request("https://cloud-api.yandex.net/v1/disk",
               method: .get,
               parameters: nil,
               encoding: JSONEncoding.default,
               headers: HTTPHeaders([.authorization(token)])
        ).response { response in
            if NetworkManager.reachability == false {
                complition(nil)
            } else {
            guard let data = response.data else {return}
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
            let model = ProfileViewModelBase(maxSize: json["total_space"] as? Double, usedSize: json["used_space"] as? Double, freeSize: nil, percent: nil)
            complition(model)
                }
            }
        }
    }
    
//MARK: - функия для получения всех файлов в папке с шагом в 15 строк
    
    func getFolderFiles(path: String?, offset: Int, complition: @escaping(_ model: [DiskFileModel]?) -> Void){
        var model : [DiskFileModel] = []
        self.offset += offset
        guard let token = token else {
            print("fix token")
            return
        }
        DispatchQueue.global().async {
        guard let path = path else {return}
            AF.request("https://cloud-api.yandex.net/v1/disk/resources?path=" + "\(path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" + "&limit=15&offset=" + "\(self.offset)" + "&preview_crop=false&preview_size=S&sort=dir%2C%20-",
               method: .get,
               parameters: nil,
               encoding: JSONEncoding.default,
               headers: HTTPHeaders([.authorization(token)])
        ).response { response in
                if response.response == nil {
                    complition(nil)
                    return
                }
                guard let data = response.data else {return}
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {return}
                guard let jsonItem = json["_embedded"] as? [String:Any] else {return}
                guard let jsonSingleItem = jsonItem["items"] as? [[String:Any]] else {return}
                for item in jsonSingleItem {
                    model.append(DiskFileModel(name: item["name"] as? String,
                                                   created: item["created"] as? String,
                                                   path: item["path"] as? String,
                                                   type: item["type"] as? String,
                                                   file: item["file"] as? String,
                                                   preview: item["preview"] as? String,
                                                   media_type: item["media_type"] as? String,
                                                   total: jsonItem["total"] as? String,
                                                   size: item["size"] as? Double,
                                                   preview_loaded: nil,
                                                   file_loaded: nil))
                    }
                var arrayConvertedName : [DiskFileModel] = []
                let formatter = DateFormatter()
                let formatterCompl = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm"
                formatterCompl.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                for item in model {
                    guard let name = item.name else {return}
                    guard let date = item.created else {return}
                    let oldDate = formatterCompl.date(from: date)
                    let newDate = formatter.string(from: oldDate ?? Date())
                    let finalName = name.split(separator: ".")
                    var compl = ""
                    if finalName.count > 1 {
                    for i in 0...(finalName.count - 2) {
                        compl += finalName[i]
                    }
                        arrayConvertedName.append(DiskFileModel(name: compl, created: newDate, path: item.path, type: item.type, file: item.file, preview: item.preview, media_type: item.media_type, total: item.total, size: self.sizeInFolder(size: item.size), preview_loaded: nil, file_loaded: nil))
                    } else {
                        arrayConvertedName.append(DiskFileModel(name: name, created: newDate, path: item.path, type: item.type, file: item.file, preview: item.preview, media_type: item.media_type, total: item.total, size: self.sizeInFolder(size: item.size), preview_loaded: nil, file_loaded: nil))
                    }
                }
                complition(arrayConvertedName)
            }
        }
    }
    
//MARK: - функция скачивания превью
    func getPreview(path: String, complition: @escaping(_ image: UIImage) -> Void) {
        guard let url = URL(string: path) else {return}
        guard let token = token else {
            print("fix token")
            return
        }
        let cache = URLCache.shared
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("OAuth " + token, forHTTPHeaderField: "Authorization")
        if let data = cache.cachedResponse(for: request)?.data {
            complition(UIImage(data: data) ?? UIImage())
        } else {
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: request){data, response, error in
                guard let data = data,
                      let response = response  else {return}
                let cacheData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheData, for: request)
                DispatchQueue.main.async {
                    complition((UIImage(data: data) ?? UIImage()))
                    }
                }.resume()
            }
        }
    }
    
//MARK: -  функция для подгрузки изображения
    func getImageForCell(path: String, complition: @escaping(_ image: UIImage) -> Void){
        guard let token = token else {
            print("fix token")
            return
        }
        DispatchQueue.global().async {
            AF.request(path,
           method: .get,
           parameters: nil,
           encoding: JSONEncoding.default,
                      headers: HTTPHeaders([.authorization(token)])
        ).response { response in
            guard let data = response.data else {return}
            complition(UIImage(data: data) ?? UIImage())
            }
        }
    }
//MARK: - функция для получения опубликованных файлов на диске
    
    func getPostedFiles(offSet: Int, complition: @escaping(_ model: [DiskFileModel]?) -> Void){
        var model : [DiskFileModel] = []
        self.offsetPosted += offSet
        guard let token = token else {
            print("fix token")
            return
        }
        DispatchQueue.global().async {
            AF.request("https://cloud-api.yandex.net/v1/disk/resources/public?limit=15&offset=" + "\(self.offsetPosted)" + "&preview_size=L",
               method: .get,
               parameters: nil,
               encoding: JSONEncoding.default,
               headers: HTTPHeaders([.authorization(token)])
        ).response { response in
                if response.response == nil {
                    complition(nil)
                }
                if response.response?.statusCode == 200 {
                guard let data = response.data else {return}
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {return}
                guard let jsonSingleItem = json["items"] as? [[String:Any]] else {return}
                for item in jsonSingleItem {
                    model.append(DiskFileModel(name: item["name"] as? String,
                                                   created: item["created"] as? String,
                                                   path: item["path"] as? String,
                                                   type: item["type"] as? String,
                                                   file: item["file"] as? String,
                                                   preview: item["preview"] as? String,
                                                   media_type: item["media_type"] as? String,
                                                   total: nil,
                                                   size: item["size"] as? Double,
                                                   preview_loaded: nil,
                                                   file_loaded: nil))
                    }
                complition(model)
                } else {
                    complition(nil)
                    }
                }
            }
    }
//MARK: - функция для получения недавних файлов с шагом в 15
    func getRecentlyFiles(limit: Int, complition: @escaping(_ model: [DiskFileModel]?) -> Void){
        var model : [DiskFileModel] = []
        self.limitRecently += limit
        guard let token = token else {
            print("fix token")
            return
        }
        DispatchQueue.global().async {
            AF.request("https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=" + "\(self.limitRecently)" + "&preview_size=L",
               method: .get,
               parameters: nil,
               encoding: JSONEncoding.default,
               headers: HTTPHeaders([.authorization(token)])
        ).response { response in
                if response.response == nil {
                    complition(nil)
                }
                if response.response?.statusCode == 200 {
                guard let data = response.data else {return}
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {return}
                guard let jsonSingleItem = json["items"] as? [[String:Any]] else {return}
                for item in jsonSingleItem {
                    model.append(DiskFileModel(name: item["name"] as? String,
                                                   created: item["created"] as? String,
                                                   path: item["path"] as? String,
                                                   type: item["type"] as? String,
                                                   file: item["file"] as? String,
                                                   preview: item["preview"] as? String,
                                                   media_type: item["media_type"] as? String,
                                                   total: nil,
                                                   size: item["size"] as? Double,
                                                   preview_loaded: nil,
                                                   file_loaded: nil))
                    }
                complition(model)
                } else {
                    complition(nil)
                }
            }
        }
    }
//MARK: - функция для удаления публикации
    func deletePublished(path: String, complition: @escaping(_ deleted: Bool) -> Void){
        guard let urlHost = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let token = token else {
            print("fix token")
            return
        }
        let pathURL = "https://cloud-api.yandex.net/v1/disk/resources/unpublish?path=" + urlHost
        AF.request(pathURL, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: HTTPHeaders([.authorization(token)])).response { response in
            switch response.response?.statusCode {
            case 200:
                complition(true)
            default:
                complition(false)
                print("doesn't delete")
            }
        }
    }
//MARK: - функция для удаления файла
    func deleteFile(path: String, complition: @escaping(_ deleted: Bool) -> Void){
        guard let urlHost = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let token = token else {
            print("fix token")
            return
        }
        let pathURL = "https://cloud-api.yandex.net/v1/disk/resources?path=" + urlHost
        AF.request(pathURL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: HTTPHeaders([.authorization(token)])).response { response in
            
            switch response.response?.statusCode {
            case 204:
                complition(true)
                print("image deleted")
            default:
                complition(false)
                print("doesn't delete")
            }
        }
    }
    
 //MARK: - функция изменения имени файла
    func changeName(path: String, newName: String, complition: @escaping(_ deleted: Bool) -> Void){
        guard let pathURL = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let nameURL = newName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let token = token else {
            print("fix token")
            return
        }
        var changedURL : String = ""
        changedURL.append(makePathForChangeName(path: path).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        changedURL.append(nameURL)
        changedURL.append(makeFormatForChangeName(name: path))
        let url = "https://cloud-api.yandex.net/v1/disk/resources/move?from=" + pathURL + "&path=" + changedURL
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: HTTPHeaders([.authorization(token)])).response { response in
            if response.error != nil {
                print(url)
                complition(false)
            }
            guard let code = response.response?.statusCode else {return}
            switch code {
            case 200...202:
                print("name changed")
                complition(true)
            default:
                print("didnot change")
                print(response.debugDescription)
                complition(false)
            }
            
        }
    }
//MARK: - функция для логина
    func doLogout(userToken: UserToken){
        AF.request("https://oauth.yandex.ru/", method: .post, parameters: userToken, encoder: JSONParameterEncoder.default).response { response in
            UserDefaultsProfile.deleteUDProfile()
            UserDefaultsToken.deleteUDToken()
            PostedCD.deleteAllPosted()
            RecentlyCD.deleteAllRecently()
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()){ records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
        }
    }
//MARK: - вспомогательные функции
    private func makePathForChangeName(path: String) -> String {
        let strSlahs = path.split(separator: "/")
        var startPath = ""
        if strSlahs.count > 2 {
        for i in 0...(strSlahs.count - 2){
            startPath.append(contentsOf: strSlahs[i] + "/")
            }
        } else {
            startPath.append(contentsOf: "disk:/")
        }
        return startPath
    }
    private func makeFormatForChangeName(name: String) -> String {
        var stringToReturn = ""
        let arr = name.split(separator: ".")
        stringToReturn.append(contentsOf: ".")
        stringToReturn.append(contentsOf: arr[arr.count - 1])
        return stringToReturn
    }
    
    private func sizeInFolder(size: Double?) -> Double? {
        if size == nil {
            return nil
        } else {
            let a = size! / pow(2, 20)
            let b = Double(round(10*a)/10)
            return b
        }
    }
}

