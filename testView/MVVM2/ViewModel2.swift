//
//  ViewModel2.swift
//  testView
//
//  Created by myPuppy on 2023/04/03.
//

import Foundation

class ViewModel2 {
    
    // 서비스(알고리즘 모음)
    private let service2 = Service2()
    
    // 테이블뷰 데이터 알림용 변수
    var onUpdated: () -> Void = {}
    
    // dataArray변수값이 변하면(didset) onUpdated변수가 동작한다
    var dataArray = [Model2]()
    {
        didSet{
            onUpdated()
        }
    }
    
    // 테이블뷰에 들어갈 데이터를 설정
    func setTableViewData(){
        
        service2.setTableValue { model in
            
            self.dataArray = model
        }
    }
    
    
    
    // 타이틀 알림용 변수
    var setTitleUpdated: () -> Void = {}
    
    var titleValue: String = "디폴트값"
    {
        didSet{
            setTitleUpdated()
        }
    }
    
    
    // 테이블뷰 데이터 말고 다른 데이터가 필요할때
    func setTitleLabel(){
        service2.setTitleValue { value in
            self.titleValue = value
        }
    }
    
    
}
