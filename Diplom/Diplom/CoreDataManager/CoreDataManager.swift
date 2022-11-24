//
//  CoreDataManager.swift
//  Diplom
//
//  Created by Nor1 on 08.11.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private let persistentContainer : NSPersistentContainer
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    private init(){
        persistentContainer = NSPersistentContainer(name: "RecentlyModel")
        print("COREDATA CREATED")
    }
    
    func loadCoreDataRecently(){
        persistentContainer.loadPersistentStores { nspersistentstoredescription, error in
            if let error = error {
                print(error)
            } else {
                print("Loaded")
            }
        }
    }
}
