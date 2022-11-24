//
//  FilesCD.swift
//  Diplom
//
//  Created by Nor1 on 08.11.2022.
//

import Foundation
import CoreData
class FilesCD {
    
    private lazy var fetchedResultController : NSFetchedResultsController<Files> = {
        let fetchRequest = Files.fetchRequest()
        let sort = NSSortDescriptor(key:"name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    func saveToCoreDataRecently(file: DiskFileModel){
        let fileName = file.name
        var newFile : Files?
        let fileFetch : NSFetchRequest<Files> = Files.fetchRequest()
        if let fileName = fileName {
            let predicate = NSPredicate(format: "name == %@", fileName)
            fileFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        }
        do {
            let result = try fetchedResultController.managedObjectContext.fetch(fileFetch)
            if result.isEmpty {
                newFile = Files.init(entity: NSEntityDescription.entity(forEntityName: "Files", in: CoreDataManager.shared.context)!, insertInto: CoreDataManager.shared.context)
                newFile?.name = file.name
                newFile?.created = file.created
                newFile?.path = file.path
                newFile?.type = file.type
                newFile?.file = file.file
                newFile?.preview = file.preview
                newFile?.media_type = file.media_type
                newFile?.total = file.total
                newFile?.size = file.size ?? 0
                try? newFile?.managedObjectContext?.save()
            } else {
                print("уже есть")
            }
        } catch {
            print(error)
        }
    }
    
    
    func showCoreDataRecently() -> [DiskFileModel]{
        var returnArray : [DiskFileModel] = []
        let fetch = Files.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
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
}
