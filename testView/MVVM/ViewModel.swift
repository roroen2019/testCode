//
//  ViewModel.swift
//  testView
//
//  Created by myPuppy on 2023/03/17.
//
/*
 곰튀김
 MVVMViewController에 데이터를 전달하는 역할
 동작하는 코드들은 서비스에 있으니 서비스를 선언한다.
 
 */
import Foundation
import RxRelay

class ViewModel {
    
    //rxswift
    let dateTimeString = BehaviorRelay(value: "Loading..")
    
    
    
    //rxswift안쓸때 사용
//    var onUpdated: () -> Void = {} //파라미터없고, 리턴값도 없는 클로저타입 변수.
    
//    var dateTimeString: String = "Loading.." // 화면에 보여지는 값
//    {
//        didSet{ //새로운 값이 저장되고 난 직후에 동작.
//            onUpdated()
//        }
//    } 
    
    
    let service = Service()
    
    private func dateToString(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return formatter.string(from: date)
    }
    
    /// 뷰컨트롤러에서 사용할 함수
    // 서비스의 패치나우 메소드를 사용한다. 메소드에서 내보내는 값을 가공하고 dateTimeString값에 넣는다.
    func reload(){
        service.fetchNow { [weak self] model in //약한참조
            guard let self = self else { return }
            // 값이 오면 동작
            let dateString = self.dateToString(date: model.currentDateTime)
//            self.dateTimeString = dateString
            self.dateTimeString.accept(dateString)
        }
    }
    
    // 뷰컨트롤러에서 사용할 함수
    func moveDay(day: Int) {
        service.moveDay(day: day)
        // dateTimeString값을 변경한다.
//        dateTimeString = dateToString(date: service.currentModel.currentDateTime)
        dateTimeString.accept(dateToString(date: service.currentModel.currentDateTime))
    }
    
}
