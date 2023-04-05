//
//  Logic.swift
//  testView
//
//  Created by myPuppy on 2023/03/17.
//
/*
 서비스에서는 레포지토리(서버통신)를 선언하고, 클라이언트 모델을 선언한다.
 사용할 알고리즘은 여기서 구현해서 viewController에서 사용한다.
 */
import Foundation

class Service {
    // 서버통신
    let repository = CustomAPI()
    // 모델
    var currentModel = Model(currentDateTime: Date())
    
    //
    // 서버통신해서 받은 값을 여기서 처리하고 뷰모델로 내보낸다.
    // 모델타입으로 내보낸다.
    func fetchNow(onCompleted: @escaping (Model) -> Void){
        repository.fetchNow { [weak self] servermodel in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"

            guard let now = formatter.date(from: servermodel.currentDateTime ?? "") else { return }
            
            let model = Model(currentDateTime: now)
            self?.currentModel = model 
            
            onCompleted(model)
            
        }
    }
    
        
        
    // 날짜변경 함수
    func moveDay(day:Int){
        guard let movedDay = Calendar.current.date(byAdding: .day,
                                                   value: day,
                                                   to: currentModel.currentDateTime) else {
            return
        }
        // 클라이언트 모델안의 변수를 변경한다.
        currentModel.currentDateTime = movedDay
    }
    
}
