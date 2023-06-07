//
//  Combine2ViewController.swift
//  testView
//
//  Created by myPuppy on 2023/05/02.
//
/*
 zedd 따라하기
 https://zeddios.tistory.com/925 11
 */
import UIKit
import Combine

//MARK: - ZeddSubscriber
class ZeddSubscriber: Subscriber {
    
    typealias Input = String
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        print("응 구독 시작이야~")
//        subscription.request(.max(2)) // 2개 까지.
        subscription.request(.unlimited)
    }
    
    // 여기는 반복되는 구간?
    func receive(_ input: String) -> Subscribers.Demand {
        print("\(input)")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("응 완료야", completion)
    }
}

//MARK: - Combine2ViewController
class Combine2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let publisher = ["Zedd", "Terror Jr", "Alan Walker", "Martin Garrix"].publisher
        publisher.subscribe(ZeddSubscriber())
        
        
    }
    

}
