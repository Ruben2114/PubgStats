//
//  AppContainer.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import CoreData

protocol AppContainer{
    var localDataService: LocalDataProfileService { get }
}

struct AppContainerImp: AppContainer {
    
    var localDataService: LocalDataProfileService = LocalDataProfileServiceImp()
    var remoteDataService: RemoteService = RemoteServiceImp()
}
