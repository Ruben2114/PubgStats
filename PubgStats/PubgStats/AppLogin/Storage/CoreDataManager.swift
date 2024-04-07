//
//  CoreDataManager.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Profile")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        try? context.save()
    }
}
