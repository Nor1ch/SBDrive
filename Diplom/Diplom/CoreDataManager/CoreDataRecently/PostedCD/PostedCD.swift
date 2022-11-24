//
//  PostedCD.swift
//  Diplom
//
//  Created by Nor1 on 08.11.2022.
//

import Foundation
import CoreData
class PostedCD {
    
    private lazy var fetchedResultController : NSFetchedResultsController<Posted> = {
        let fetchRequest = Posted.fetchRequest()
        let sort = NSSortDescriptor(key:"name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    
    func saveToCoreData(array: [DiskFileModel]){
        let postedFetch = Posted.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        postedFetch.sortDescriptors = [sort]
        do {
            let arrayFetched = try fetchedResultController.managedObjectContext.fetch(postedFetch)
            print("элементов в дата = "+"\(arrayFetched.count)")
            if arrayFetched.isEmpty && !array.isEmpty {
                array.forEach { file in
                  let newFile = Posted.init(entity: NSEntityDescription.entity(forEntityName: "Posted", in: CoreDataManager.shared.context)!, insertInto: CoreDataManager.shared.context)
                    newFile.name = file.name
                    newFile.created = file.created
                    newFile.path = file.path
                    newFile.type = file.type
                    newFile.file = file.file
                    newFile.preview = file.preview
                    newFile.media_type = file.media_type
                    newFile.total = file.total
                    newFile.size = file.size ?? 0
                    try? newFile.managedObjectContext?.save()
                }
            } else {
                let convertedArray = arrayFetched.map{DiskFileModel(name: $0.name, created: $0.created, path: $0.path, type: $0.type, file: $0.file, preview: $0.preview, media_type: $0.media_type, total: $0.total, size: $0.size, preview_loaded: nil, file_loaded: nil)}
                let arraySaveToData = array.filter{ item in !convertedArray.contains(where: { file in
                    item.path == file.path
                }) }
                print("сохранить в дату = " + "\(arraySaveToData.count)")
                arraySaveToData.forEach { file in
                    let newFile = Posted.init(entity: NSEntityDescription.entity(forEntityName: "Posted", in: CoreDataManager.shared.context)!, insertInto: CoreDataManager.shared.context)
                      newFile.name = file.name
                      newFile.created = file.created
                      newFile.path = file.path
                      newFile.type = file.type
                      newFile.file = file.file
                      newFile.preview = file.preview
                      newFile.media_type = file.media_type
                      newFile.total = file.total
                      newFile.size = file.size ?? 0
                      try? newFile.managedObjectContext?.save()
                }
                
                let arrayDeleteFromData = convertedArray.filter{ item in !array.contains(where: { file in
                    item.path == file.path
                }) }
                print("удалить из даты = " + "\(arrayDeleteFromData.count)")
                let postedFetchDelete = Posted.fetchRequest()
                arrayDeleteFromData.forEach { file in
                    if let fileName = file.path {
                        let predicate = NSPredicate(format: "path == %@", fileName)
                        postedFetchDelete.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
                    }
                    do {
                        let objct = try fetchedResultController.managedObjectContext.fetch(postedFetchDelete)
                        print("объектов для удаления = " + "\(objct.count)")
                        if !objct.isEmpty {
                        objct.forEach { file in
                            fetchedResultController.managedObjectContext.delete(file)
                        }
                        try fetchedResultController.managedObjectContext.save()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func showCoreDataRecently() -> [DiskFileModel]{
        var returnArray : [DiskFileModel] = []
        let fetch = Posted.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: false)
        fetch.sortDescriptors = [sort]
        do {
        let result = try self.fetchedResultController.managedObjectContext.fetch(fetch)
            for item in result{
                returnArray.append(DiskFileModel(name: item.name, created: item.created, path: item.path, type: item.type, file: item.file, preview: item.preview, media_type: item.media_type, total: item.total, size: item.size, preview_loaded: nil, file_loaded: nil))
            }
        } catch {
            print(error)
        }
        return returnArray
    }
    func checkForChanges(){
    if fetchedResultController.managedObjectContext.hasChanges {
        do {
            try CoreDataManager.shared.context.save()
            print("saved")
        } catch {
            print(error)
            print("didnt save")
            }
        }
    }
    
    static func deleteAllPosted(){
        var a = 0
        let allFetched = Posted.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        allFetched.sortDescriptors = [sort]
        do {
            let result = try CoreDataManager.shared.context.fetch(allFetched)
            if !result.isEmpty {
            result.forEach { item in
                CoreDataManager.shared.context.delete(item)
                print("Удален posted" + "\(a)")
                a += 1
                }
            }
        } catch {
            print(error)
        }
    }
}
