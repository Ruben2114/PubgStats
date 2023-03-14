//
//  LocalDataProfileService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//



import CoreData
import UIKit

protocol LocalDataProfileService {
    func get(name: String, password: String) async throws -> ProfileModel?
    func save(profile: Profile)
    //TODO: EN UN FUTURO METER BORRAR O ACTUALIZAR
}

struct LocalDataProfileServiceImp: LocalDataProfileService {
    
    private let context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    
    
    func get(name: String, password: String) async throws -> ProfileModel? {
        let profileCoreDataEntity =  try getEntity(name: name, password: password)!
        return ProfileModel(
            name:profileCoreDataEntity.name!,
            password: profileCoreDataEntity.password!)
    }
    func save(profile: Profile){
        try? context.save()
    }
    
    private func getEntity(name: String, password: String) throws -> Profile? {
        let request = Profile.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "name == %@", name),
            NSPredicate(format: "password == %@", password)
        ])
        let profileCoreDataEntity = try context.fetch(request).first
        return profileCoreDataEntity
    }
}




