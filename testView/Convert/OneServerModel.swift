//
//  OneServerModel.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//

import Foundation

// MARK: - tap 홈(메인)
// MARK: - MainHomeData
struct MainHomeData: Codable {
    let bannerList: [BannerList]
    let newAdoptList: [NewAdoptList]
    let newsList: [NewsList]
}

// MARK: - BannerList
struct BannerList: Codable {
    let uid: Int?
    let imageFullURL: String?
    let linkFullURL: String?

    enum CodingKeys: String, CodingKey {
        case uid
        case imageFullURL = "imageFullUrl"
        case linkFullURL = "linkFullUrl"
    }
}

// MARK: - NewAdoptList
struct NewAdoptList: Codable {
    let uid: Int?
    let imageFullURL: String?
    let adoptTypeLabel, speciesLabel, breedLabel, gender: String?
    let age: String?
    let hasInsurance: Bool?

    enum CodingKeys: String, CodingKey {
        case uid
        case imageFullURL = "imageFullUrl"
        case adoptTypeLabel, speciesLabel, breedLabel, gender, age, hasInsurance
    }
}

// MARK: - NewsList
struct NewsList: Codable {
    let uid: Int?
    let imageFullURL, htmlURL: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case imageFullURL = "imageFullUrl"
        case htmlURL = "htmlUrl"
    }
}
