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
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats)
    func saveGamesMode(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO], type: NavigationStats)
    func saveWeaponData(sessionUser: ProfileEntity, weaponData: WeaponDTO, type: NavigationStats)
    func saveNewValue(sessionUser: ProfileEntity,_ value: Any, type: String)
    func getFavourites(for sessionUser: ProfileEntity) -> [Favourite]?
    func deleteFavouriteTableView(_ profile: Favourite)
    func getSurvival(for sessionUser: ProfileEntity, type: NavigationStats) -> Survival?
    func getGameMode(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?
    func getDataWeaponDetail(for sessionUser: ProfileEntity, type: NavigationStats) -> [Weapon]?
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
    
    func saveSurvival(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], type: NavigationStats){
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            setSurvival(sessionUser: sessionUser, survivalData: survivalData, key: "name", value: sessionUser.name, fetchRequest: fetchRequest)
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return}
            setSurvival(sessionUser: sessionUser, survivalData: survivalData, key: "name", value: player, fetchRequest: fetchRequest)
        }
    }
    
    private func setSurvival<T: NSManagedObject & HasEntities>(sessionUser: ProfileEntity, survivalData: [SurvivalDTO], key: String, value: String, fetchRequest: NSFetchRequest<T>) {
        
        fetchRequest.predicate = NSPredicate(format: "\(key) == %@", value)
        do {
            let result = try context.fetch(fetchRequest)
            if var perfil = result.first{
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
    
    func saveGamesMode(sessionUser: ProfileEntity, gamesModeData: [GamesModesDTO], type: NavigationStats){
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
            do {
                let result = try context.fetch(fetchRequest)
                if let profile = result.first{
                    guard let data = gamesModeData.first else {return}
                    let gameModes = [
                        "solo": data.solo,
                        "soloFpp": data.soloFpp,
                        "duo": data.duo,
                        "duoFpp": data.duoFpp,
                        "squad": data.squad,
                        "squadFpp": data.squadFpp
                    ]
                    gameModes.forEach { mode in
                        let dataGamesMode = profile.gamesMode?.first(where: {($0 as? GamesModes)?.mode == mode.key }) as? GamesModes ?? GamesModes(context: context)
                        saveGameData(dataGamesMode: dataGamesMode, mode: mode.key, result: mode.value, data: data)
                        profile.addToGamesMode(dataGamesMode)
                    }
                }
            } catch {
                print("Error en core data")
            }
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return}
            fetchRequest.predicate = NSPredicate(format: "name == %@", player)
            do {
                let result = try context.fetch(fetchRequest)
                if let profile = result.first{
                    guard let data = gamesModeData.first else {return}
                    let gameModes = [
                        "solo": data.solo,
                        "soloFpp": data.soloFpp,
                        "duo": data.duo,
                        "duoFpp": data.duoFpp,
                        "squad": data.squad,
                        "squadFpp": data.squadFpp
                    ]
                    gameModes.forEach { mode in
                        let dataGamesMode = profile.gamesMode?.first(where: {($0 as? GamesModes)?.mode == mode.key }) as? GamesModes ?? GamesModes(context: context)
                        saveGameData(dataGamesMode: dataGamesMode, mode: mode.key, result: mode.value, data: data)
                        profile.addToGamesMode(dataGamesMode)
                    }
                }
            } catch {
                print("Error en core data")
            }
        }
    }
    private func saveGameData(dataGamesMode: GamesModes, mode: String, result: DuoDTO, data: GamesModesDTO) {
        dataGamesMode.mode = mode
        dataGamesMode.assists = Int32(result.assists)
        dataGamesMode.boosts = Int32(result.boosts)
        dataGamesMode.dBNOS = Int32(result.dBNOS)
        dataGamesMode.dailyKills = Int32(result.dailyKills)
        dataGamesMode.dailyWINS = Int32(result.dailyWINS)
        dataGamesMode.damageDealt = result.damageDealt
        dataGamesMode.days = Int32(result.days)
        dataGamesMode.headshotKills = Int32(result.headshotKills)
        dataGamesMode.heals = Int32(result.heals)
        dataGamesMode.killPoints = Int32(result.killPoints)
        dataGamesMode.kills = Int32(result.kills)
        dataGamesMode.longestKill = result.longestKill
        dataGamesMode.longestTimeSurvived = Int32(result.longestTimeSurvived)
        dataGamesMode.losses = Int32(result.losses)
        dataGamesMode.maxKillStreaks = Int32(result.maxKillStreaks)
        dataGamesMode.mostSurvivalTime = Int32(result.mostSurvivalTime)
        dataGamesMode.rankPoints = Int32(result.rankPoints)
        dataGamesMode.rankPointsTitle = result.rankPointsTitle
        dataGamesMode.revives = Int32(data.solo.revives)
        dataGamesMode.rideDistance = result.rideDistance
        dataGamesMode.roadKills = Int32(result.roadKills)
        dataGamesMode.roundMostKills = Int32(result.roundMostKills)
        dataGamesMode.roundsPlayed = Int32(result.roundsPlayed)
        dataGamesMode.swimDistance = result.swimDistance
        dataGamesMode.suicides = Int32(result.suicides)
        dataGamesMode.teamKills = Int32(result.teamKills)
        dataGamesMode.timeSurvived = Int32(result.timeSurvived)
        dataGamesMode.top10S = Int32(result.top10S)
        dataGamesMode.vehicleDestroys = Int32(result.vehicleDestroys)
        dataGamesMode.walkDistance = result.walkDistance
        dataGamesMode.weaponsAcquired = Int32(result.weaponsAcquired)
        dataGamesMode.weeklyKills = Int32(result.weeklyKills)
        dataGamesMode.weeklyWINS = Int32(result.weeklyWINS)
        dataGamesMode.winPoints = Int32(result.winPoints)
        dataGamesMode.wins = Int32(result.wins)
        dataGamesMode.bestRankPoint = Int32(data.bestRank)
        dataGamesMode.killsTotal = Int32(data.killsTotal)
        dataGamesMode.gamesPlayed = Int32(data.gamesPlayed)
        dataGamesMode.timePlayed = data.timePlayed
        dataGamesMode.top10STotal = Int32(data.top10STotal)
        dataGamesMode.wonTotal = Int32(data.wonTotal)
        try? context.save()
    }
    
    func saveWeaponData(sessionUser: ProfileEntity, weaponData: WeaponDTO, type: NavigationStats){
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
            do {
                let result = try context.fetch(fetchRequest)
                if let profile = result.first{
                    var weaponType: [String] = []
                    for data in weaponData.data.attributes.weaponSummaries.keys {
                        weaponType.append(data)
                    }
                    weaponType.forEach { weaponName in
                        weaponData.data.attributes.weaponSummaries.forEach { result in
                            if weaponName == result.key {
                                var weapon: [(String,Any)] = []
                                let xp = String(result.value.xpTotal)
                                let level = String(result.value.levelCurrent)
                                let tier = String(result.value.tierCurrent)
                                weapon.append(("XP Total", xp))
                                weapon.append(("Level Current", level))
                                weapon.append(("Tier Current", tier))
                                for (key, value) in result.value.statsTotal {
                                    weapon.append((key, String(format: "%.0f", value)))
                                }
                                let dict = NSDictionary(dictionary: Dictionary(uniqueKeysWithValues: weapon))
                                guard let data = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0) else {return}
                                let dataWeapon = profile.weapon?.first(where: {($0 as? Weapon)?.name == weaponName }) as? Weapon ?? Weapon(context: context)
                                dataWeapon.name = weaponName
                                dataWeapon.data = data
                                profile.addToWeapon(dataWeapon)
                                try? context.save()
                            }
                        }
                    }
                }
            } catch {
                print("Error en core data")
            }
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return}
            fetchRequest.predicate = NSPredicate(format: "name == %@", player)
            do {
                let result = try context.fetch(fetchRequest)
                if let profile = result.first{
                    var weaponType: [String] = []
                    for data in weaponData.data.attributes.weaponSummaries.keys {
                        weaponType.append(data)
                    }
                    weaponType.forEach { weaponName in
                        weaponData.data.attributes.weaponSummaries.forEach { result in
                            if weaponName == result.key {
                                var weapon: [(String,Any)] = []
                                let xp = String(result.value.xpTotal)
                                let level = String(result.value.levelCurrent)
                                let tier = String(result.value.tierCurrent)
                                weapon.append(("XP Total", xp))
                                weapon.append(("Level Current", level))
                                weapon.append(("Tier Current", tier))
                                for (key, value) in result.value.statsTotal {
                                    weapon.append((key, String(format: "%.0f", value)))
                                }
                                let dict = NSDictionary(dictionary: Dictionary(uniqueKeysWithValues: weapon))
                                guard let data = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0) else {return}
                                let dataWeapon = profile.weapon?.first(where: {($0 as? Weapon)?.name == weaponName }) as? Weapon ?? Weapon(context: context)
                                dataWeapon.name = weaponName
                                dataWeapon.data = data
                                profile.addToWeapon(dataWeapon)
                                try? context.save()
                            }
                        }
                    }
                }
            } catch {
                print("Error en core data")
            }
        }
        
    }
    func saveWeaponDatae<T: HasEntities>(sessionUser: ProfileEntity, weaponData: WeaponDTO, type: NavigationStats, request: NSFetchRequest<T>){
        switch type {
        case .profile:
            request.predicate = NSPredicate(format: "name == %@", sessionUser.name)
            do {
                let result = try context.fetch(request)
                if let profile = result.first{
                    var weaponType: [String] = []
                    for data in weaponData.data.attributes.weaponSummaries.keys {
                        weaponType.append(data)
                    }
                    weaponType.forEach { weaponName in
                        weaponData.data.attributes.weaponSummaries.forEach { result in
                            if weaponName == result.key {
                                var weapon: [(String,Any)] = []
                                let xp = String(result.value.xpTotal)
                                let level = String(result.value.levelCurrent)
                                let tier = String(result.value.tierCurrent)
                                weapon.append(("XP Total", xp))
                                weapon.append(("Level Current", level))
                                weapon.append(("Tier Current", tier))
                                for (key, value) in result.value.statsTotal {
                                    weapon.append((key, String(format: "%.0f", value)))
                                }
                                let dict = NSDictionary(dictionary: Dictionary(uniqueKeysWithValues: weapon))
                                guard let data = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0) else {return}
                                let dataWeapon = profile.weapon?.first(where: {($0 as? Weapon)?.name == weaponName }) as? Weapon ?? Weapon(context: context)
                                dataWeapon.name = weaponName
                                dataWeapon.data = data
                                profile.addToWeapon(dataWeapon)
                                try? context.save()
                            }
                        }
                    }
                }
            } catch {
                print("Error en core data")
            }
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return}
            fetchRequest.predicate = NSPredicate(format: "name == %@", player)
            do {
                let result = try context.fetch(fetchRequest)
                if let profile = result.first{
                    var weaponType: [String] = []
                    for data in weaponData.data.attributes.weaponSummaries.keys {
                        weaponType.append(data)
                    }
                    weaponType.forEach { weaponName in
                        weaponData.data.attributes.weaponSummaries.forEach { result in
                            if weaponName == result.key {
                                var weapon: [(String,Any)] = []
                                let xp = String(result.value.xpTotal)
                                let level = String(result.value.levelCurrent)
                                let tier = String(result.value.tierCurrent)
                                weapon.append(("XP Total", xp))
                                weapon.append(("Level Current", level))
                                weapon.append(("Tier Current", tier))
                                for (key, value) in result.value.statsTotal {
                                    weapon.append((key, String(format: "%.0f", value)))
                                }
                                let dict = NSDictionary(dictionary: Dictionary(uniqueKeysWithValues: weapon))
                                guard let data = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0) else {return}
                                let dataWeapon = profile.weapon?.first(where: {($0 as? Weapon)?.name == weaponName }) as? Weapon ?? Weapon(context: context)
                                dataWeapon.name = weaponName
                                dataWeapon.data = data
                                profile.addToWeapon(dataWeapon)
                                try? context.save()
                            }
                        }
                    }
                }
            } catch {
                print("Error en core data")
            }
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
    func getSurvival(for sessionUser: ProfileEntity,type: NavigationStats) -> Survival? {
        switch type {
        case .profile:
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
        case .favourite:
            let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return nil}
            fetchRequest.predicate = NSPredicate(format: "name == %@", player)
            do {
                let profile = try context.fetch(fetchRequest)
                guard let survival = profile.first?.survival else { return nil }
                return survival
                
            } catch {
                print("Error en core data: \(error.localizedDescription)")
                return nil
            }
        }
       
    }
    func getGameMode(for sessionUser: ProfileEntity,type: NavigationStats) -> [GamesModes]? {
        switch type {
        case .profile:
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
        case .favourite:
            let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return nil}
            fetchRequest.predicate = NSPredicate(format: "name == %@", player)
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
    }
    func getDataWeaponDetail(for sessionUser: ProfileEntity,type: NavigationStats) -> [Weapon]?{
        switch type {
        case .profile:
            let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", sessionUser.name)
            do {
                let profile = try context.fetch(fetchRequest)
                guard let weaponSet = profile.first?.weapon as? Set<Weapon> else {
                    return nil
                }
                let weapon = Array(weaponSet)
                return weapon
            } catch {
                print("Error en core data: \(error.localizedDescription)")
                return nil
            }
        case .favourite:
            let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
            guard let player = sessionUser.nameFavourite else {return nil}
            fetchRequest.predicate = NSPredicate(format: "name == %@", player)
            do {
                let profile = try context.fetch(fetchRequest)
                guard let weaponSet = profile.first?.weapon as? Set<Weapon> else {
                    return nil
                }
                let weapon = Array(weaponSet)
                return weapon
            } catch {
                print("Error en core data: \(error.localizedDescription)")
                return nil
            }
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
protocol HasEntities {
    var survival: Survival? { get set }
    var weapon: NSSet? {get set}
    func addToWeapon(_ value: Weapon)
}

extension Profile: HasEntities {}
extension Favourite: HasEntities {}


