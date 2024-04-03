//
//  LocalDataProfileService.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import CoreData
import UIKit
import Combine

//TODO: manejar errores

protocol LocalDataProfileService {
    func save(player: IdAccountDataProfileRepresentable, type: NavigationStats)
    func saveSurvival(player: String?, survivalData: SurvivalDataProfileRepresentable, type: NavigationStats)
    func saveGamesMode(player: String?, gamesModeData: GamesModesDataProfileRepresentable, type: NavigationStats)
    func saveWeaponData(player: String?, weaponData: WeaponDataProfileRepresentable, type: NavigationStats)
    func getFavourites() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error>
    func getSurvival(player: String, type: NavigationStats) -> SurvivalDataProfileRepresentable?
    func getGameMode(player: String, type: NavigationStats) -> GamesModesDataProfileRepresentable?
    func getDataWeaponDetail(player: String, type: NavigationStats) -> WeaponDataProfileRepresentable?
    func getAccountProfile(player: String) -> IdAccountDataProfileRepresentable?
    func getAnyProfile() -> IdAccountDataProfileRepresentable?
    func deleteFavourite(_ profile: IdAccountDataProfileRepresentable)
    func deleteProfile(player: String)
}

struct LocalDataProfileServiceImp: LocalDataProfileService {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Profile")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save(player: IdAccountDataProfileRepresentable, type: NavigationStats) {
        switch type {
        case .profile:
            saveProfile(player: player)
        case .favourite:
            saveFavourite(player: player)
        }
    }
    
    func saveSurvival(player: String?, survivalData: SurvivalDataProfileRepresentable, type: NavigationStats) {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            saveSurvival(survivalData: survivalData, value: player ?? "", fetchRequest: fetchRequest)
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            saveSurvival(survivalData: survivalData, value: player ?? "", fetchRequest: fetchRequest)
        }
    }
    
    func saveGamesMode(player: String?, gamesModeData: GamesModesDataProfileRepresentable, type: NavigationStats) {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            saveGames(gamesModeData: gamesModeData, request: fetchRequest, name: player ?? "")
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            saveGames(gamesModeData: gamesModeData, request: fetchRequest, name: player ?? "")
        }
    }
    
    func saveWeaponData(player: String?, weaponData: WeaponDataProfileRepresentable, type: NavigationStats) {
        switch type {
        case .profile:
            let fetchRequest = Profile.fetchRequest()
            saveWeapon(weaponData: weaponData, request: fetchRequest, name: player ?? "")
        case .favourite:
            let fetchRequest = Favourite.fetchRequest()
            saveWeapon(weaponData: weaponData, request: fetchRequest, name: player ?? "")
        }
    }
    //TODO: poner todos como estos?
    func getFavourites() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        let profile = getAnyProfile()
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", profile?.name ?? "")
        return Future<[IdAccountDataProfileRepresentable], Error> { promise in
            do {
                guard let profile = try persistentContainer.viewContext.fetch(fetchRequest).first?.favourites as? Set<Favourite> else {
                    promise(.failure(NSError(domain: "", code: 0)))
                    return
                }
                promise(.success(profile.map {
                     DefaultIdAccountDataProfile(id: $0.account ?? "",
                                                       name: $0.player ?? "",
                                                       platform: $0.platform ?? "")
                }))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func getSurvival(player: String, type: NavigationStats) -> SurvivalDataProfileRepresentable? {
        switch type {
        case .profile:
            return getDataSulvival(fetchRequest: Profile.fetchRequest(), name: player)
        case .favourite:
            return getDataSulvival(fetchRequest: Favourite.fetchRequest(), name: player)
        }
    }
    
    
    func getGameMode(player: String, type: NavigationStats) -> GamesModesDataProfileRepresentable? {
        switch type {
        case .profile:
            return getDataGameModes(fetchRequest: Profile.fetchRequest(), name: player)
        case .favourite:
            return getDataGameModes(fetchRequest: Favourite.fetchRequest(), name: player)
        }
    }
  
    func getDataWeaponDetail(player: String, type: NavigationStats) -> WeaponDataProfileRepresentable? {
        switch type {
        case .profile:
            return getDataWeapon(fetchRequest: Profile.fetchRequest(), name: player)
        case .favourite:
            return getDataWeapon(fetchRequest: Favourite.fetchRequest(), name: player)
        }
    }
    
    func getAccountProfile(player: String) -> IdAccountDataProfileRepresentable? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", player)
        do {
            let profile = try persistentContainer.viewContext.fetch(fetchRequest)
            return DefaultIdAccountDataProfile(id: profile.first?.account ?? "",
                                               name: profile.first?.player ?? "",
                                               platform: profile.first?.platform ?? "")
        } catch {
            return nil
        }
    }
    
    func getAnyProfile() -> IdAccountDataProfileRepresentable? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        do {
            let profile = try persistentContainer.viewContext.fetch(fetchRequest)
            let response = DefaultIdAccountDataProfile(id: profile.first?.account ?? "",
                                                       name: profile.first?.player ?? "",
                                                       platform: profile.first?.platform ?? "")
            return profile == [] ? nil : response
        } catch {
            return nil
        }
    }
  
    //TODO: con combine y presentar un toast abajo de borrado con exito o el mensaje de error
    func deleteFavourite(_ profile: IdAccountDataProfileRepresentable) {
        let profileFavourite = Favourite.fetchRequest()
        profileFavourite.predicate = NSPredicate(format: "player == %@", profile.name)
        do {
            if let result = try persistentContainer.viewContext.fetch(profileFavourite).first {
                persistentContainer.viewContext.delete(result)
                saveContext()
            } else {
                print("error al borrar objeto")
                return
            }
        } catch {
            print("Error en core data: \(error.localizedDescription)")
            return
        }
    }
    
    //TODO: con combine y presentar un toast abajo si es error , si va bien pasar a otra pantalla
    func deleteProfile(player: String) {
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", player)
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest).first
            if let profileDelete = result {
                persistentContainer.viewContext.delete(profileDelete)
                saveContext()
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

// MARK: - saveContext
private extension LocalDataProfileServiceImp {
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save Core Data context: \(error)")
            }
        }
    }
}

private extension LocalDataProfileServiceImp {
    func saveGameData<T: HasEntities>(profile: T, result: StatisticsGameModesRepresentable, data: GamesModesDataProfileRepresentable) {
        let dataGamesMode = profile.gamesMode?.first(where: {($0 as? GamesModes)?.mode == result.mode }) as? GamesModes ?? GamesModes(context: persistentContainer.viewContext)
        dataGamesMode.mode = result.mode
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
        dataGamesMode.mostSurvivalTime = result.mostSurvivalTime
        dataGamesMode.revives = Int32(result.revives)
        dataGamesMode.rideDistance = result.rideDistance
        dataGamesMode.roadKills = Int32(result.roadKills)
        dataGamesMode.roundMostKills = Int32(result.roundMostKills)
        dataGamesMode.roundsPlayed = Int32(result.roundsPlayed)
        dataGamesMode.swimDistance = result.swimDistance
        dataGamesMode.suicides = Int32(result.suicides)
        dataGamesMode.teamKills = Int32(result.teamKills)
        dataGamesMode.timeSurvived = result.timeSurvived
        dataGamesMode.top10S = Int32(result.top10S)
        dataGamesMode.vehicleDestroys = Int32(result.vehicleDestroys)
        dataGamesMode.walkDistance = result.walkDistance
        dataGamesMode.weaponsAcquired = Int32(result.weaponsAcquired)
        dataGamesMode.weeklyKills = Int32(result.weeklyKills)
        dataGamesMode.weeklyWINS = Int32(result.weeklyWINS)
        dataGamesMode.wins = Int32(result.wins)
        dataGamesMode.bestRankPoint = data.bestRankPoint ?? 0
        dataGamesMode.killsTotal = Int32(data.killsTotal)
        dataGamesMode.gamesPlayed = Int32(data.gamesPlayed)
        dataGamesMode.timePlayed = data.timePlayed
        dataGamesMode.assistsTotal = Int32(data.assistsTotal)
        dataGamesMode.wonTotal = Int32(data.wonTotal)
        dataGamesMode.top10STotal = Int32(data.top10STotal)
        dataGamesMode.headshotKillsTotal = Int32(data.headshotKillsTotal)
        let data = try? PropertyListSerialization.data(fromPropertyList: data.matches, format: .binary, options: 0)
        dataGamesMode.matches = data
        profile.addToGamesMode(dataGamesMode)
        saveContext()
        //TODO: si esto falla no lo controlo
    }
    
    func saveSurvival<T: NSManagedObject & HasEntities>(survivalData: SurvivalDataProfileRepresentable, value: String, fetchRequest: NSFetchRequest<T>) {
        fetchRequest.predicate = NSPredicate(format: "player == %@", value)
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            if var perfil = result.first {
                let newSurvival = perfil.survival ?? Survival(context: persistentContainer.viewContext)
                newSurvival.airDropsCalled = survivalData.stats.airDropsCalled
                newSurvival.damageDealt = survivalData.stats.damageDealt
                newSurvival.damageTaken = survivalData.stats.damageTaken
                newSurvival.distanceBySwimming = survivalData.stats.distanceBySwimming
                newSurvival.distanceByVehicle = survivalData.stats.distanceByVehicle
                newSurvival.distanceOnFoot = survivalData.stats.distanceOnFoot
                newSurvival.distanceTotal = survivalData.stats.distanceTotal
                newSurvival.healed = survivalData.stats.healed
                newSurvival.hotDropLandings = survivalData.stats.hotDropLandings
                newSurvival.enemyCratesLooted = survivalData.stats.enemyCratesLooted
                newSurvival.uniqueItemsLooted = survivalData.stats.uniqueItemsLooted
                newSurvival.position = survivalData.stats.position
                newSurvival.revived = survivalData.stats.revived
                newSurvival.teammatesRevived = survivalData.stats.teammatesRevived
                newSurvival.timeSurvived = survivalData.stats.timeSurvived
                newSurvival.throwablesThrown = survivalData.stats.throwablesThrown
                newSurvival.top10 = survivalData.stats.top10
                newSurvival.totalMatchesPlayed = survivalData.totalMatchesPlayed
                newSurvival.xp = survivalData.xp
                newSurvival.level = survivalData.level
                perfil.survival = newSurvival
                saveContext()
            }
        } catch {
            print("Error en core data")
        }
    }
    
    func saveGames<T: HasEntities>(gamesModeData: GamesModesDataProfileRepresentable, request: NSFetchRequest<T>, name: String){
        request.predicate = NSPredicate(format: "player == %@", name)
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let profile = result.first {
                gamesModeData.modes.forEach { mode in
                    saveGameData(profile: profile, result: mode, data: gamesModeData)
                }
            }
        } catch {
            print("Error en core data saveGames")
        }
    }
    
    func saveWeapon<T: HasEntities>(weaponData: WeaponDataProfileRepresentable, request: NSFetchRequest<T>, name: String){
        request.predicate = NSPredicate(format: "player == %@", name)
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let profile = result.first {
                weaponData.weaponSummaries.forEach { weapon in
                    let dict = NSDictionary(dictionary: Dictionary(uniqueKeysWithValues: weapon.statsTotal.map { ($0.key, $0.value)}))
                    guard let data = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0) else { return }
                    let dataWeapon = profile.weapon?.first(where: {($0 as? Weapon)?.name == weapon.name }) as? Weapon ?? Weapon(context: persistentContainer.viewContext)
                    dataWeapon.name = weapon.name
                    dataWeapon.level = Int32(weapon.levelCurrent)
                    dataWeapon.xp = Int32(weapon.xpTotal)
                    dataWeapon.tier = Int32(weapon.tierCurrent)
                    dataWeapon.data = data
                    profile.addToWeapon(dataWeapon)
                    saveContext()
                }
            }
        } catch {
            print("Error en core data saveWeapon")
        }
    }
    
    func getDataSulvival<T: HasEntities>(fetchRequest: NSFetchRequest<T>, name: String) -> SurvivalDataProfileRepresentable? {
        fetchRequest.predicate = NSPredicate(format: "player == %@", name)
        do {
            let profile = try persistentContainer.viewContext.fetch(fetchRequest)
            guard let survival = profile.first?.survival as? Survival else { return nil }
            return DefaultSurvivalDataProfile(survival)
        } catch {
            return nil
        }
    }
    
    func getDataGameModes<T: HasEntities>(fetchRequest: NSFetchRequest<T>, name: String) -> GamesModesDataProfileRepresentable? {
        fetchRequest.predicate = NSPredicate(format: "player == %@", name)
        do {
            let profile = try persistentContainer.viewContext.fetch(fetchRequest)
            guard let gameModesSet = profile.first?.gamesMode as? Set<GamesModes> else {
                return nil
            }
            let gameModes = Array(gameModesSet)
            return DefaultGamesModesDataProfile(gameModes)
            
        } catch {
            return nil
        }
    }
    
    func getDataWeapon<T: HasEntities>(fetchRequest: NSFetchRequest<T>, name: String) -> WeaponDataProfileRepresentable? {
        fetchRequest.predicate = NSPredicate(format: "player == %@", name)
        do {
            let profile = try persistentContainer.viewContext.fetch(fetchRequest)
            guard let weaponSet = profile.first?.weapon as? Set<Weapon> else {
                return nil
            }
            let weapon = Array(weaponSet)
            return DefaultWeaponDataProfile(weapon)
        } catch {
            return nil
        }
    }
    
    private func saveProfile(player: IdAccountDataProfileRepresentable) {
        let newUser = Profile(context: persistentContainer.viewContext)
        newUser.player = player.name
        newUser.account = player.id
        newUser.platform = player.platform
        saveContext()
    }
    
    private func saveFavourite(player: IdAccountDataProfileRepresentable) {
        let profile = getAnyProfile()
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "player == %@", profile?.name ?? "")
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            if let perfil = result.first {
                let newFav = Favourite(context: persistentContainer.viewContext)
                newFav.player = player.name
                newFav.account = player.id
                newFav.platform = player.platform
                perfil.addToFavourites(newFav)
                saveContext()
            }
        } catch {
            print("Error en core data saveFav")
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
