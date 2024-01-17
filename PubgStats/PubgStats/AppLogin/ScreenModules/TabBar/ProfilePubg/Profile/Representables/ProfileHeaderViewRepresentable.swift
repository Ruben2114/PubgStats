//
//  ProfileHeaderViewRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/1/24.
//

protocol ProfileHeaderViewRepresentable {
    var dataPlayer: IdAccountDataProfileRepresentable { get }
    var level: String { get }
    var xp: String { get }
}

struct DefaultProfileHeaderView: ProfileHeaderViewRepresentable {
    var dataPlayer: IdAccountDataProfileRepresentable
    var level: String
    var xp: String
    
    init(dataPlayer: IdAccountDataProfileRepresentable, level: String, xp: String) {
        self.dataPlayer = dataPlayer
        self.level = level
        self.xp = xp
    }
}
