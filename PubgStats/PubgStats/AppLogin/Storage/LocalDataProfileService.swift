//
//  LocalDataProfileService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import CoreData
import UIKit

protocol LocalDataProfileService {
    func save(name: String, password: String, email: String)
    func saveFav(sessionUser: ProfileEntity, name: String, account: String)
    func checkIfNameExists(name: String) -> Bool
    func checkIfEmailExists(email: String) -> Bool
    func checkUser(sessionUser: ProfileEntity, name: String, password: String) -> Bool
    func checkUserAndChangePassword(name: String, email: String) -> Bool
    func savePlayerPubg(sessionUser: ProfileEntity, player: String, account: String)
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO])
    func saveGamesMode(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO])
    func saveNewValue(sessionUser: ProfileEntity,_ value: Any, type: String)
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]?
    func deleteFavouriteTableView(_ profile: Favourite)
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?
    func getGameMode(for sessionUser: ProfileEntity) -> [GamesModes]?
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
    func checkIfEmailExists(email: String) -> Bool {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
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
        let result = try? context.fetch(fetchRequest)
        guard let first = result?.first, sessionUser.name == first.name, !result!.isEmpty else{return false}
        guard let email = first.email else {return false}
        sessionUser.email = email
        sessionUser.player = first.player
        sessionUser.account = first.account
        sessionUser.image = first.image
        return true
    }
    func checkUserAndChangePassword(name: String, email: String) -> Bool {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND email == %@", name, email)
        let result = try? context.fetch(fetchRequest)
        guard let first = result?.first else{return false}
        first.password = "0000".hashString()
        try? context.save()
        return true
    }
    
    func save(name: String, password: String , email:String){
        let newUser = Profile(context: context)
        newUser.name = name
        newUser.password = password
        newUser.email = email.lowercased()
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
    func saveFav(sessionUser: ProfileEntity, name: String, account: String){
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            if let perfil = result.first{
                let newFav = Favourite(context: context)
                newFav.name = name
                newFav.account = account
                perfil.addToFavourites(newFav)
                try? context.save()
            }
        } catch {
            print("Error en core data")
        }
    }
    
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO]){
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            if let perfil = result.first{
                let newSurvival = perfil.survival ?? Survival(context: context)
                guard let data = survivalData.first?.data.attributes else {return}
                guard let dataStats = survivalData.first?.data.attributes.stats else {return}
                
                newSurvival.airDropsCalled = String(format: "%.0f", dataStats.airDropsCalled.total ?? 0)
                newSurvival.damageDealt = String(format: "%.0f", dataStats.damageDealt.total ?? 0)
                newSurvival.damageTaken =  String(format: "%.0f", dataStats.damageTaken.total ?? 0)
                newSurvival.distanceBySwimming =  String(format: "%.0f", dataStats.distanceBySwimming.total ?? 0)
                newSurvival.distanceByVehicle =  String(format: "%.0f", dataStats.distanceByVehicle.total ?? 0)
                newSurvival.distanceOnFoot =  String(format: "%.0f", dataStats.distanceOnFoot.total ?? 0)
                newSurvival.distanceTotal =  String(format: "%.0f", dataStats.distanceTotal.total ?? 0)
                newSurvival.healed = String(format: "%.0f", dataStats.healed.total ?? 0)
                newSurvival.hotDropLandings = String(format: "%.0f", dataStats.hotDropLandings.total)
                newSurvival.enemyCratesLooted = String(format: "%.0f", dataStats.enemyCratesLooted.total ?? 0)
                newSurvival.uniqueItemsLooted = String(format: "%.0f", dataStats.uniqueItemsLooted.total ?? 0)
                newSurvival.position = String(format: "%.0f", dataStats.position.total ?? 0)
                newSurvival.revived = String(format: "%.0f", dataStats.revived.total ?? 0)
                newSurvival.teammatesRevived = String(format: "%.0f", dataStats.teammatesRevived.total ?? 0)
                newSurvival.timeSurvived = String(format: "%.0f", dataStats.timeSurvived.total ?? 0)
                newSurvival.throwablesThrown = String(format: "%.0f", dataStats.throwablesThrown.total ?? 0)
                newSurvival.top10 = String(format: "%.0f", dataStats.top10.total)
                newSurvival.totalMatchesPlayed = String(data.totalMatchesPlayed)
                newSurvival.xp = String(data.xp)
                newSurvival.level = String(data.level)
                perfil.survival = newSurvival
                try context.save()
            }
        } catch {
            print("Error en core data")
        }
    }
    func saveGameData(mode: String, data: DuoDTO, profile: Profile, total: GamesModesDTO) {
        let dataGamesMode = profile.gamesMode?.first(where: { ($0 as? GamesModes)?.mode == mode }) as? GamesModes ?? GamesModes(context: context)
        dataGamesMode.mode = mode
        dataGamesMode.assists = Int32(data.assists)
        dataGamesMode.boosts = Int32(data.boosts)
        dataGamesMode.dBNOS = Int32(data.dBNOS)
        dataGamesMode.dailyKills = Int32(data.dailyKills)
        dataGamesMode.dailyWINS = Int32(data.dailyWINS)
        dataGamesMode.damageDealt = data.damageDealt
        dataGamesMode.days = Int32(data.days)
        dataGamesMode.headshotKills = Int32(data.headshotKills)
        dataGamesMode.heals = Int32(data.heals)
        dataGamesMode.killPoints = Int32(data.killPoints)
        dataGamesMode.kills = Int32(data.kills)
        dataGamesMode.longestKill = data.longestKill
        dataGamesMode.longestTimeSurvived = Int32(data.longestTimeSurvived)
        dataGamesMode.losses = Int32(data.losses)
        dataGamesMode.maxKillStreaks = Int32(data.maxKillStreaks)
        dataGamesMode.mostSurvivalTime = Int32(data.mostSurvivalTime)
        dataGamesMode.rankPoints = Int32(data.rankPoints)
        dataGamesMode.rankPointsTitle = data.rankPointsTitle
        dataGamesMode.revives = Int32(data.revives)
        dataGamesMode.rideDistance = data.rideDistance
        dataGamesMode.roadKills = Int32(data.roadKills)
        dataGamesMode.roundMostKills = Int32(data.roundMostKills)
        dataGamesMode.roundsPlayed = Int32(data.roundsPlayed)
        dataGamesMode.swimDistance = data.swimDistance
        dataGamesMode.suicides = Int32(data.suicides)
        dataGamesMode.teamKills = Int32(data.teamKills)
        dataGamesMode.timeSurvived = Int32(data.timeSurvived)
        dataGamesMode.top10S = Int32(data.top10S)
        dataGamesMode.vehicleDestroys = Int32(data.vehicleDestroys)
        dataGamesMode.walkDistance = data.walkDistance
        dataGamesMode.weaponsAcquired = Int32(data.weaponsAcquired)
        dataGamesMode.weeklyKills = Int32(data.weeklyKills)
        dataGamesMode.weeklyWINS = Int32(data.weeklyWINS)
        dataGamesMode.winPoints = Int32(data.winPoints)
        dataGamesMode.wins = Int32(data.wins)
        dataGamesMode.bestRankPoint = Int32(total.bestRank)
        dataGamesMode.killsTotal = Int32(total.killsTotal)
        dataGamesMode.gamesPlayed = Int32(total.gamesPlayed)
        dataGamesMode.timePlayed = total.timePlayed
        dataGamesMode.top10STotal = Int32(total.top10STotal)
        dataGamesMode.wonTotal = Int32(total.wonTotal)
        profile.addToGamesMode(dataGamesMode)
        try? context.save()
    }
    func saveGamesMode(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO]){
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            if let profile = result.first{
                guard let data = gamesModeData.first else {return}
                saveGameData(mode: "solo", data: data.solo, profile: profile, total: data)
                saveGameData(mode: "soloFpp", data: data.soloFpp, profile: profile, total: data)
                saveGameData(mode: "duo", data: data.duo, profile: profile, total: data)
                saveGameData(mode: "duoFpp", data: data.duoFpp, profile: profile, total: data)
                saveGameData(mode: "squad", data: data.squad, profile: profile, total: data)
                saveGameData(mode: "squadFpp", data: data.squadFpp, profile: profile, total: data)
            }
        } catch {
            print("Error en core data")
        }
    }
    func saveNewValue(sessionUser: ProfileEntity,_ value: Any, type: String){
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let result = try context.fetch(fetchRequest)
            let namePlayer = result.map {$0.name}.description
            let name2 = namePlayer.replacingOccurrences(of: "[Optional(\"", with: "").replacingOccurrences(of: "\")]", with: "")
            if sessionUser.name == name2 {
                let user = result.first
                if let stringValue = value as? String {
                    if type == "name" {
                        user?.name = stringValue
                        try context.save()
                        sessionUser.name = stringValue
                    } else if type == "email" {
                        user?.email = stringValue
                        try context.save()
                        sessionUser.email = stringValue
                    } else if type == "password"{
                        user?.password = stringValue
                        try context.save()
                        sessionUser.password = stringValue
                    }
                } else if let dataValue = value as? Data {
                    if type == "image"{
                        user?.image = dataValue
                        try context.save()
                        sessionUser.image = dataValue
                    }
                }
                
            }
        } catch {
            print("Error en core data")
        }
    }
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let profile = try context.fetch(fetchRequest)
            guard let favouritesSet = profile.first?.favourites as? Set<Favourite> else {
                return nil
            }
            let favourites = Array(favouritesSet)
            return favourites
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return nil
        }
    }
    func getSurvival(for sessionUser: ProfileEntity) -> Survival? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let profile = try context.fetch(fetchRequest)
            guard let survival = profile.first?.survival else { return nil }
            return survival
            
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return nil
        }
    }
    func getGameMode(for sessionUser: ProfileEntity) -> [GamesModes]? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
        do {
            let profile = try context.fetch(fetchRequest)
            guard let gameModesSet = profile.first?.gamesMode as? Set<GamesModes> else {
                return nil
            }
            let gameModes = Array(gameModesSet)
            return gameModes
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteFavouriteTableView(_ profile: Favourite) {
        let deleteFavouriteTableView: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Favourite")
        let profileFav = profile
        deleteFavouriteTableView.predicate = NSPredicate(format: "name == %@", profileFav.name ?? "")
        do {
            let result = try context.fetch(deleteFavouriteTableView).first as? Favourite
            if let profileDelete = result {
                context.delete(profileDelete)
                try context.save()
            } else {
                print("error al borrar objeto")
                return
            }
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return
        }
    }
}




