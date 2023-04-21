//
//  OneModel.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//

import Foundation


// MARK: - tap 홈(메인)
// MARK: - MainHomeData
struct CurrentModel {
    let bannerList: [CurrentBannerList]
    let newAdoptList: [CurrentNewAdoptList]
    let newsList: [CurrentNewsList]
}

// MARK: - BannerList
struct CurrentBannerList {
    let uid: Int?
    let imageFullURL: String?
    let linkFullURL: String?

}

// MARK: - NewAdoptList
struct CurrentNewAdoptList {
    let uid: Int?
    let imageFullURL: String?
    let adoptTypeLabel, speciesLabel, breedLabel, gender: String?
    let age: String?
    let hasInsurance: Bool?

}

// MARK: - NewsList
struct CurrentNewsList {
    let uid: Int?
    let imageFullURL, htmlURL: String?
    
}
