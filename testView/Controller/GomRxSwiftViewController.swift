//
//  GomRxSwiftViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/07.
//
/*
 곰튀김
 rxSwift 4시간 끝내기 연습하기
 */
import UIKit
import RxSwift

class GomRxSwiftViewController: UIViewController {

    
    var disposeBag = DisposeBag()
    
    //exJust1
    private let exJustButton1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exJust1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //exJust2
    private let exJustButton2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exJust2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //exFrom1
    private let exFromButton1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exFrom1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //exMap1
    private let exMapButton1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exMap1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //exMap2
    private let exMapButton2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exMap2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //exFilter
    private let exFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exFilter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //exMap3
    private let exMapButton3: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exMap3", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
}

extension GomRxSwiftViewController {
    private func setupView(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(exJustButton1)
        exJustButton1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        exJustButton1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exJustButton1.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exJustButton1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exJustButton1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exJustButton2)
        exJustButton2.topAnchor.constraint(equalTo: self.exJustButton1.bottomAnchor).isActive = true
        exJustButton2.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exJustButton2.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exJustButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exJustButton2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exFromButton1)
        exFromButton1.topAnchor.constraint(equalTo: self.exJustButton2.bottomAnchor).isActive = true
        exFromButton1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exFromButton1.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exFromButton1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exFromButton1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exMapButton1)
        exMapButton1.topAnchor.constraint(equalTo: self.exFromButton1.bottomAnchor).isActive = true
        exMapButton1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exMapButton1.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exMapButton1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exMapButton1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exMapButton2)
        exMapButton2.topAnchor.constraint(equalTo: self.exMapButton1.bottomAnchor).isActive = true
        exMapButton2.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exMapButton2.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exMapButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exMapButton2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exFilterButton)
        exFilterButton.topAnchor.constraint(equalTo: self.exMapButton2.bottomAnchor).isActive = true
        exFilterButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exFilterButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exFilterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exFilterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exMapButton3)
        exMapButton3.topAnchor.constraint(equalTo: self.exFilterButton.bottomAnchor).isActive = true
        exMapButton3.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exMapButton3.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exMapButton3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exMapButton3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //MARK: buttonAction
    // just: 일반값을 넣는 함수(배열도 가능)
    // from: 값을 하나하나 내려보내는 방식
    // map: 입력된 값을 가공하는 부분
    // filter: 안의 조건식이 true일 경우에 값을 다음으로 보낸다.
    @objc private func buttonAction(_ sender:UIButton){
        switch sender {
        case exJustButton1:
            Observable.just("Hello World").subscribe { str in
                print(str)
            }.disposed(by: disposeBag)
            
        case exJustButton2:
            Observable.just(["Hello", "World"]).subscribe { arr in
                print(arr)
            }.disposed(by: disposeBag)
            
        case exFromButton1:
            
            Observable.from(["RxSwift", "In", "3", "Hours"]).subscribe { value in
                print(value)
            }.disposed(by: disposeBag)
            
        case exMapButton1:
            Observable.just("hello").map { str in
                "데이터 변경?" + str
            }.subscribe { value in
                print(value)
            }.disposed(by: disposeBag)
            
            
        case exMapButton2:
            Observable.from(["with", "곰튀김 따라하기"]).map {
                $0.count
            }.subscribe { value in
                print(value)
            }.disposed(by: disposeBag)
            
        case exFilterButton:
            Observable.from([1,2,3,4,5,6,7,8,9,10]).filter {
                $0 % 2 == 0
            }.subscribe { number in
                print(number)
            }.disposed(by: disposeBag)
            
            
        case exMapButton3:
            print("exmap3")
            
            
        default:
            return
        }
    }
    
}
