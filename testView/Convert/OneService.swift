//
//  OneService.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//

import Foundation

class OneService {
    // 서버통신
    let repository = OneAPI()
   
    //배너 리스트
    var bannerArray = [CurrentBannerList]()
    
    //추천 리스트
    var adoptArray = [CurrentNewAdoptList]()
    
    //뉴스 리스트
    var newsArray = [CurrentNewsList]()
    
    
    func fetchNow(onCompleted:@escaping(CurrentModel)->Void){
        repository.fetchData { [weak self] server in
            // 데이터가공하고 내보내기
            // 서버모델로 데이터가 온다
            // 배너리스트
            guard let bannerList = server?.bannerList else { return }
            
            for banner in bannerList {
                let bannerModel = CurrentBannerList(uid: banner.uid, imageFullURL: banner.imageFullURL, linkFullURL: banner.linkFullURL)
                self?.bannerArray.append(bannerModel)
            }
            
            // 추천리스트
            guard let adoptList = server?.newAdoptList else { return }
            for adopt in adoptList {
                let adoptModel = CurrentNewAdoptList(uid: adopt.uid, imageFullURL: adopt.imageFullURL, adoptTypeLabel: adopt.adoptTypeLabel, speciesLabel: adopt.speciesLabel, breedLabel: adopt.breedLabel, gender: adopt.gender, age: adopt.age, hasInsurance: adopt.hasInsurance)
                self?.adoptArray.append(adoptModel)
            }
            
            
            // 뉴스리스트
            guard let newsList = server?.newsList else { return }
            for news in newsList {
                let newsModel = CurrentNewsList(uid: news.uid, imageFullURL: news.imageFullURL, htmlURL: news.htmlURL)
                self?.newsArray.append(newsModel)
            }
            
            guard let banner = self?.bannerArray else { return }
            guard let adopt = self?.adoptArray else { return }
            guard let news = self?.newsArray else { return }
            
          
            let totalModel = CurrentModel(bannerList: banner, newAdoptList: adopt, newsList: news)
            onCompleted(totalModel)
        }
    }
    
    
}
