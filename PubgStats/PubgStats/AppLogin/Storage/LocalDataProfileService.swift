//
//  LocalDataProfileService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//



import CoreData
import UIKit

protocol LocalDataProfileService {
    func save(profile: Profile)
    func checkIfNameExists(name: String) -> Bool
    func checkUser(name: String, password: String) -> Bool
    //TODO: EN UN FUTURO METER BORRAR O ACTUALIZAR
}

struct LocalDataProfileServiceImp: LocalDataProfileService {
    
    private let context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    
    func checkIfNameExists(name: String) -> Bool {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.count > 0
            return count
        } catch {
            return false
        }
    }
    func checkUser(name: String, password: String) -> Bool {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND password == %@", name, password)
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.count > 0
            return count
        } catch {
            return false
        }
    }
    
    func save(profile: Profile){
        try? context.save()
    }
}




