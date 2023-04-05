//
//  MVVMViewController.swift
//  testView
//
//  Created by myPuppy on 2023/03/17.
//
/*
 1.mvvm 테스트 https://www.youtube.com/watch?v=M58LqynqQHc
 2.프리뷰 적용해보기
 
 정리
 뷰(뷰컨)에서 버튼 또는 실행(viewDidLoad)으로 데이터를 요청한다.
 뷰모델에서 요청을 받는다.
 뷰모델 안의 서비스(알고리즘)가 동작한다.
 
 
 */
import UIKit
import SwiftUI
import RxSwift
import RxCocoa


class MVVMViewController: UIViewController {

    // 레이블1, 버튼3개
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yesterDayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tommorrwButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 뷰모델 가져오기
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // 뷰 모델의 onUpdated 변수가 동작하면 그 안의 코드가 동작한다.
//        viewModel.onUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.timeLabel.text = self?.viewModel.dateTimeString
//            }
//        }
        
        // 뷰 모델의 dateTimeString값이 변형이 일어나면, 변형된 값을 레이블에 넣는다
        viewModel.dateTimeString
            .bind(to: self.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // 뷰 모델의 리로드 메소드 동작
        viewModel.reload()
    }
    
    //MARK: - 뷰 설정
    private func setupView(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(timeLabel)
        timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
//        timeLabel.text = viewModel.dateTimeString
        
        self.view.addSubview(yesterDayButton)
        yesterDayButton.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 20).isActive = true
        yesterDayButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        yesterDayButton.setTitle("yesertDay", for: .normal)
        yesterDayButton.setTitleColor(.blue, for: .normal)
        yesterDayButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(nowButton)
        nowButton.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 20).isActive = true
        nowButton.leadingAnchor.constraint(equalTo: yesterDayButton.trailingAnchor, constant: 20).isActive = true
        
        nowButton.setTitle("now", for: .normal)
        nowButton.setTitleColor(.blue, for: .normal)
        nowButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(tommorrwButton)
        tommorrwButton.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 20).isActive = true
        tommorrwButton.leadingAnchor.constraint(equalTo: nowButton.trailingAnchor, constant: 20).isActive = true
        
        tommorrwButton.setTitle("tommorrw", for: .normal)
        tommorrwButton.setTitleColor(.blue, for: .normal)
        tommorrwButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    //MARK: - buttonAction
    @objc
    private func buttonAction(sender:UIButton){
        
        switch sender {
        case yesterDayButton:
            print("어제")
            viewModel.moveDay(day: -1)
        case nowButton:
            print("오늘")
            timeLabel.text = "Loading..."
            viewModel.reload()
        case tommorrwButton:
            print("내일")
            viewModel.moveDay(day: 1)
        default:
            ()
        }
    }

}

//MARK: - 프리뷰
struct VCPreView:PreviewProvider {
    static var previews: some View {
        MVVMViewController().toPreview()
    }
}
