//
//  LocalDataProfileService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//



import CoreData
import UIKit

protocol LocalDataProfileService {
    func save(name: String, password: String)
    func checkIfNameExists(name: String) -> Bool
    func checkUser(sessionUser: ProfileEntity, name: String, password: String) -> Bool
    func savePlayerPubg(sessionUser: ProfileEntity, player: String, account: String)
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
    func checkUser(sessionUser: ProfileEntity, name: String, password: String) -> Bool {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND password == %@", name, password)
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.count > 0
            if count == true {
                let namePlayer = result.map {$0}
                if sessionUser.name == namePlayer.first?.name {
                    sessionUser.player = namePlayer.first?.player
                    sessionUser.account = namePlayer.first?.account
                }
            }
            return count
        } catch {
            return false
        }
    }
    
    func save(name: String, password: String){
        let newUser = Profile(context: context)
        newUser.name = name
        newUser.password = password
        try? context.save()
    }
    func savePlayerPubg(sessionUser: ProfileEntity, player: String, account: String){
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            let namePlayer = result.map {$0.name}.description
            let name2 = namePlayer.replacingOccurrences(of: "[Optional(\"", with: "").replacingOccurrences(of: "\")]", with: "")
            if sessionUser.name == name2 {
                let user = result.first
                user?.player = player
                user?.account = account
                try context.save()
                sessionUser.player = player
                sessionUser.account = account
            }
        } catch {
            print("Error en core data")
        }
    }
}




