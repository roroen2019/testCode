//
//  GomLoginViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/13.
//
/*
 로그인 예제
 snapkit 해보기
 */
import UIKit
import RxSwift
import SnapKit

class GomLoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let idTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    // exlogin
    private lazy var loginbutton = UIButton()
//    private let loginButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("login", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        return button
//    }()
    
    private lazy var idCheckView = UIView()
    private lazy var passwordCheckView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setBind()
    }
    

}

extension GomLoginViewController {
    //MARK: 뷰 설정
    private func setupView(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(idTextField)
        idTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        idTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        idTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        idTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        idTextField.borderStyle = .roundedRect
        idTextField.placeholder = "아이디"
        
        
        self.view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "비밀번호"
        
        
        //snapkit 테스트
        self.view.addSubview(loginbutton)
        loginbutton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
        
        loginbutton.backgroundColor = .systemBlue
        loginbutton.setTitle("로그인", for: .normal)
        loginbutton.setTitleColor(.black, for: .normal)
        
        // 아이디 체크뷰
        self.view.addSubview(idCheckView)
        idCheckView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.trailing.equalTo(idTextField.snp.trailing).offset(-10)
            make.centerY.equalTo(idTextField.snp.centerY)
        }
        
        idCheckView.backgroundColor = .red
        
        
        // 비번 체크뷰
        self.view.addSubview(passwordCheckView)
        passwordCheckView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.trailing.equalTo(passwordTextField.snp.trailing).offset(-10)
            make.centerY.equalTo(passwordTextField.snp.centerY)
        }
        
        passwordCheckView.backgroundColor = .red
        
    }
    
    //MARK: 바인딩
    private func setBind(){
        // 입력값 확인후 체크뷰를 보여줄지 말지 설정.
        idTextField.rx.text
            .orEmpty
//            .filter({ $0 != nil })
//            .map({ $0! })
            .map(self.checkEmailValid(_:))
            .subscribe { text in
            
                self.idCheckView.isHidden = text
            
        }.disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
//            .filter({ $0 != nil })
//            .map({ $0! })
            .map(self.checkPasswordValid(_:))
            .subscribe { text in
            
                self.passwordCheckView.isHidden = text
            
        }.disposed(by: disposeBag)
        
        // 아이디, 비밀번호를 두개 다 입력되었는지 확인
        
        
    }
    
    //MARK: 이메일 체크
    private func checkEmailValid(_ email:String) -> Bool{
        return email.contains("@") && email.contains(".")
    }
    
    //MARK: 비번 체크
    private func checkPasswordValid(_ password:String) -> Bool{
        return password.count > 5
    }
    
}
