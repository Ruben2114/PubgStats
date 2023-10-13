//
//  LocalDataProfileService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import CoreData
import UIKit

// <>

//TODO: todo esto ponerlo con combine y que devuelva un bool minimo y la cache que se gestione cuando se hace la llamda no como otro metodo

protocol LocalDataProfileService {
    func save(player: String, account: String, platform: String)
    func saveFav(player: String, playerFav: String, account: String, platform: String)
    func saveSurvival(player: String?, survivalData: [SurvivalDTO], type: NavigationStats)
    func saveGamesMode(player: String?, gamesModeData: GamesModesDTO, type: NavigationStats)
    func saveWeaponData(player: String?, playerFav: String?, weaponData: WeaponDTO, type: NavigationStats)
    func getFavourites(player: String) -> [Favourite]?
    func getSurvival(player: String, type: NavigationStats) -> SurvivalDataProfileRepresentable?
    func getGameMode(player: String, type: NavigationStats) -> [GamesModes]?
    func getDataWeaponDetail(player: String, type: NavigationStats) -> [Weapon]?
    func getAccountProfile(player: String) -> IdAccountDataProfileRepresentable?
    func deleteFavouriteTableView(_ profile: Favourite)
    func deleteProfile(player: String)
}

struct LocalDataProfileServiceImp: LocalDataProfileService {
    private let context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    
    func save(player: String, account: String, platform: String) {
        let newUser = Profile(context: context)
        newUser.player = player
        newUser.account = account
        newUser.platform = platform
        do{
            try context.save()
        } catch {
            print("Error en core data \(error)")
        }
    }
    
    func saveFav(player: String, playerFav: String, account: String, platform: String) {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", player)
        do {
            let result = try context.fetch(fetchRequest)
            if let perfil = result.first{
                let newFav = Favourite(context: context)
                newFav.name = playerFav
                newFav.account = account
                newFav.platform = platform
                perfil.addToFavourites(newFav)
                try? context.save()
            }
        } catch {
            print("Error en core data")
        }
    }
    
    func saveSurvival(player: String?, survivalData: [SurvivalDTO], type: NavigationStats) {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            setSurvival(survivalData: survivalData, key: "player", value: player ?? "", fetchRequest: fetchRequest)
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            setSurvival(survivalData: survivalData, key: "player", value: player ?? "", fetchRequest: fetchRequest)
        }
    }
    
    func saveGamesMode(player: String?, gamesModeData: GamesModesDTO, type: NavigationStats) {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            saveGames(gamesModeData: gamesModeData, type: .profile, request: fetchRequest, name: player ?? "")
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            saveGames(gamesModeData: gamesModeData, type: .favourite, request: fetchRequest, name: player ?? "")
        }
    }
    
    func saveWeaponData(player: String?, playerFav: String?, weaponData: WeaponDTO, type: NavigationStats) {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            saveWeapon(weaponData: weaponData, type: .profile, request: fetchRequest, name: player ?? "")
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            saveWeapon(weaponData: weaponData, type: .favourite, request: fetchRequest, name: playerFav ?? "")
        }
    }
    
    func getFavourites(player: String) -> [Favourite]? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", player)
        do {
            let profile = try context.fetch(fetchRequest)
            guard let favouritesSet = profile.first?.favourites as? Set<Favourite> else {
                return nil
            }
            return Array(favouritesSet)
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getSurvival(player: String, type: NavigationStats) -> SurvivalDataProfileRepresentable? {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            let survival = getDataSulvival(fetchRequest: fetchRequest, name: player)
            return survival
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            let survival = getDataSulvival(fetchRequest: fetchRequest, name: player)
            return survival
        }
    }
    
    
    func getGameMode(player: String, type: NavigationStats) -> [GamesModes]? {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            let gameModes = getDataGameModes(fetchRequest: fetchRequest, name: player)
            return gameModes
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            let gameModes = getDataGameModes(fetchRequest: fetchRequest, name: player)
            return gameModes
        }
    }
  
    func getDataWeaponDetail(player: String, type: NavigationStats) -> [Weapon]? {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            let weapon = getDataWeapon(fetchRequest: fetchRequest, name: player)
            return weapon
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            let weapon = getDataWeapon(fetchRequest: fetchRequest, name: player)
            return weapon
        }
    }
    
    func getAccountProfile(player: String) -> IdAccountDataProfileRepresentable? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", player)
        do {
            let profile = try context.fetch(fetchRequest)
            return DefaultIdAccountDataProfileRepresentable(id: profile.first?.account, name: profile.first?.player)
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return nil
        }
    }
  
    func deleteFavouriteTableView(_ profile: Favourite) {
        let deleteFavouriteTableView = Favourite.fetchRequest()
        guard let profileFav = profile.name else {return}
        deleteFavouriteTableView.predicate = NSPredicate(format: "name == %@", profileFav)
        do {
            let result = try context.fetch(deleteFavouriteTableView).first
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
    
    func deleteProfile(player: String) {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", player)
        do {
            let result = try context.fetch(fetchRequest).first
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

private extension LocalDataProfileServiceImp {
    func saveGameData<T: HasEntities>(profile: T, mode: String, result: DuoDTO, data: GamesModesDTO) {
        let dataGamesMode = profile.gamesMode?.first(where: {($0 as? GamesModes)?.mode == mode }) as? GamesModes ?? GamesModes(context: context)
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
        dataGamesMode.kills = Int32(result.kills)
        dataGamesMode.longestKill = result.longestKill
        dataGamesMode.losses = Int32(result.losses)
        dataGamesMode.maxKillStreaks = Int32(result.maxKillStreaks)
        dataGamesMode.mostSurvivalTime = Int32(result.mostSurvivalTime)
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
        dataGamesMode.wins = Int32(result.wins)
        dataGamesMode.bestRankPoint = Int32(data.bestRank)
        dataGamesMode.killsTotal = Int32(data.killsTotal)
        dataGamesMode.gamesPlayed = Int32(data.gamesPlayed)
        dataGamesMode.timePlayed = data.timePlayed
        dataGamesMode.assistsTotal = Int32(data.assistsTotal)
        dataGamesMode.wonTotal = Int32(data.wonTotal)
        profile.addToGamesMode(dataGamesMode)
        try? context.save()
    }
    
    func setSurvival<T: NSManagedObject & HasEntities>(survivalData: [SurvivalDTO], key: String, value: String, fetchRequest: NSFetchRequest<T>) {
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
    
    func saveGames<T: HasEntities>(gamesModeData: GamesModesDTO, type: NavigationStats, request: NSFetchRequest<T>, name: String){
        request.predicate = NSPredicate(format: "player == %@", name)
        do {
            let result = try context.fetch(request)
            if let profile = result.first{
                let gameModes = [
                    "solo": gamesModeData.solo,
                    "soloFpp": gamesModeData.soloFpp,
                    "duo": gamesModeData.duo,
                    "duoFpp": gamesModeData.duoFpp,
                    "squad": gamesModeData.squad,
                    "squadFpp": gamesModeData.squadFpp
                ]
                gameModes.forEach { mode in
                    saveGameData(profile: profile, mode: mode.key, result: mode.value, data: gamesModeData)
                }
            }
        } catch {
            print("Error en core data")
        }
    }
    
    func saveWeapon<T: HasEntities>(weaponData: WeaponDTO, type: NavigationStats, request: NSFetchRequest<T>, name: String){
        request.predicate = NSPredicate(format: "player == %@", name)
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
    }
    
    func getDataSulvival<T: HasEntities>(fetchRequest: NSFetchRequest<T>, name: String) -> SurvivalDataProfileRepresentable? {
        fetchRequest.predicate = NSPredicate(format: "player == %@", name)
        do {
            let profile = try context.fetch(fetchRequest)
            guard let survival = profile.first?.survival else { return nil }
            return DefaultSurvivalDataProfile(survival)
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getDataGameModes<T: HasEntities>(fetchRequest: NSFetchRequest<T>, name: String) -> [GamesModes]? {
        fetchRequest.predicate = NSPredicate(format: "player == %@", name)
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
    
    func getDataWeapon<T: HasEntities>(fetchRequest: NSFetchRequest<T>, name: String) -> [Weapon]? {
        fetchRequest.predicate = NSPredicate(format: "player == %@", name)
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

protocol HasEntities {
    var survival: Survival? { get set }
    var weapon: NSSet? {get set}
    func addToWeapon(_ value: Weapon)
    var gamesMode: NSSet? {get set}
    func addToGamesMode(_ value: GamesModes)
}

extension Profile: HasEntities {}
extension Favourite: HasEntities {}
