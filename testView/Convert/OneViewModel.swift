//
//  OneViewModel.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//

import Foundation
import RxRelay

class OneViewModel {
    // 서비스(로직)
    let service = OneService()
    
    // 데이터
    let bannerData = BehaviorRelay(value: [CurrentBannerList]())
    let adoptData = BehaviorRelay(value: [CurrentNewAdoptList]())
    let newsData = BehaviorRelay(value: [CurrentNewsList]())
    
}

//MARK: 콜렉션뷰 데이터 요청하기
extension OneViewModel {
    
    func receiveData(){
        service.fetchNow { [weak self] model in
            guard let self = self else { return }
            // 값이 오면 동작
            self.bannerData.accept(model.bannerList)
            self.adoptData.accept(model.newAdoptList)
            self.newsData.accept(model.newsList)
        }
    }
    
}
