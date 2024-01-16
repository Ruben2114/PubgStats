//
//  NewsCardRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 15/1/24.
//

protocol NewsCardRepresentable {
    var title: String { get }
    var subTitle: String? { get }
    var customImageView: String? { get }
}

struct DefaultNewsCard: NewsCardRepresentable {
    var title: String
    var subTitle: String?
    var customImageView: String?
    
    public init(title: String,
                subTitle: String? = nil,
                customImageView: String? = nil){
        self.title = title
        self.subTitle = subTitle
        self.customImageView = customImageView
    }
}
