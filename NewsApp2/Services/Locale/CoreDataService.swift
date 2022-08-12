//
//  CoreDataService.swift
//  NewsApp2
//
//  Created by Света Шибаева on 11.08.2022.
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsApp2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext(completion: (() -> ())? = nil) {
        if context.hasChanges {
            do {
                try context.save()
                completion?()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
