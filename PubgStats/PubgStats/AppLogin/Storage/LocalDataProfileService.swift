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
    func save(profile: ProfileModel) async -> Result<Bool, ProfileError>
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
    func save(profile: ProfileModel) async -> Result<Bool, ProfileError> {
        let saveProfile: NSFetchRequest<Profile> = Profile.fetchRequest()
        saveProfile.predicate = NSPredicate(format: "nombre == %@", profile.name )
        do {
            let result = try context.fetch(saveProfile)
            if result.count > 0 {
                print("ya estas registrado")
            } else {
                let newProfile = Profile(context: context)
                newProfile.name = profile.name
                newProfile.password = profile.password
                print("guardado")
                try context.save()
            }
        } catch {
            print("error")
        }
        return .success(true)
        
    }
    private func getEntity(name: String, password: String) throws -> Profile? {
        let request = Profile.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "nombre == %@", name),
            NSPredicate(format: "contraseña == %@", password)
        ])
        let profileCoreDataEntity = try context.fetch(request).first
        return profileCoreDataEntity
    }
}




