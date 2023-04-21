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
    
    // 이미지뷰
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // exJust
    private let exJustButton3: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exJust3", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // exlogin
    private let exLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("exLogin", for: .normal)
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
        exMapButton3.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.exMapButton3.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.backgroundColor = .lightGray
        
        self.view.addSubview(exJustButton3)
        exJustButton3.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        exJustButton3.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exJustButton3.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exJustButton3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exJustButton3.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(exLoginButton)
        exLoginButton.topAnchor.constraint(equalTo: self.exJustButton3.bottomAnchor).isActive = true
        exLoginButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        exLoginButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        exLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exLoginButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
    }
    
    //MARK: buttonAction
    // just: 일반값을 넣는 함수(배열도 가능)
    // from: 값을 하나하나 내려보내는 방식
    // map: 입력된 값을 가공하는 부분
    // filter: 안의 조건식이 true일 경우에 값을 다음으로 보낸다.
    // subscribe: 최종값을 사용하겠다. 외부와 연결가능한곳1
    // obser
    // do: 외부와 연결가능한곳2
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
            Observable.just("800x600")
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .default)) // 이 다음 실행되는 스트림은 컨커런트스케쥴러로 실행한다(메인스레드에서 실행안한다는 뜻), qos:우선순위
                .map { $0.replacingOccurrences(of: "x", with: "/") } //"800x600"값에서 x를 /로 변경함
                .map { "http://picsum.photos/\($0)/?random" } //위에서 변경된 "800/600"값을 스트링 사이에 넣는다.
                .map { URL(string: $0) } //스트링을 URL로 변경한다.
                .filter { $0 != nil } //URL값을 확인해서 닐이 아닐경우에 다음으로 진행한다.
                .map { $0! } //위에서 내려온 값이 옵셔널이라서 강제언레핑으로 옵셔널을 해제한다.
                .map { try Data(contentsOf: $0) } //URL을 데이터로 변환
                .map { UIImage(data: $0) } //데이터를 UIimage타입으로 변환
//                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default)) //subscribe(on) 은 첫줄부터 스케줄러를 적용하기위해서 사용한다. 위치는 어디에 있든 상관없음
                .observe(on: MainScheduler.instance) // 다음 스트림부터는 메인스레드로 동작
                .do()
                .subscribe { image in
                    // 외부와 연결되는 부분
                    self.imageView.image = image
                }.disposed(by: disposeBag)
            
        case exJustButton3:
            print("exjust")
            Observable.from(["hello world", "test", 1, "2222"])
//                .single()
                .subscribe { event in
                    switch event {
                    case .next(let str):
                        print("next: \(str)")
                        break
                    case .error(let err):
                        print("error: \(err)")
                        break
                    case .completed:
                        print("completed")
                        break
                    }
                }
                .disposed(by: disposeBag)
            
        case exLoginButton:
            print("exLogin")
            let login = GomLoginViewController()
            self.present(login, animated: true)
            
            
        default:
            return
        }
    }
    
}
