//
//  Service2.swift
//  testView
//
//  Created by myPuppy on 2023/04/03.
//

import Foundation

class Service2 {
    
    // 모델 선언하기
    var model2 = [Model2(title: "")]
    
    func setTableValue(completion:@escaping(([Model2]) -> Void)){
        //
        let value = [
            Model2(title: "테스트"),
            Model2(title: "테스트1"),
            Model2(title: "테스트2")
        ]
        
        self.model2 = value //변경값 저장, 뷰모델에서 모델2값을 사용할수 있어서 갱신해준다.
        
        completion(value)
    }
    
    func setTitleValue(completion:@escaping((String) -> Void)){
        //
        let value = "타이틀값 변경"
        
        completion(value)
    }
    
}
