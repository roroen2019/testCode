//
//  testViewController.swift
//  testView
//
//  Created by myPuppy on 2023/03/21.
//
/*
 레이어와 쉐도우 테스트
 */
import UIKit

class testViewController: UIViewController {

    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let testView: shadowLayerView = {
        let view = shadowLayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientView: shadowLayerView = {
        let view = shadowLayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nextButotn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    

}


extension testViewController {
    private func setupView(){
        self.view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.backgroundColor = .green
        
        // ====
        // ScrollView에 내용 추가
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        

        // ContentView Constraints 설정
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true //세로방향 스크롤
        
        
        
        // 테스트뷰 설정
        // 콘텐츠뷰가 내부사이즈에 맞춰진다.
        contentView.addSubview(testView)
        testView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        testView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        testView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        testView.heightAnchor.constraint(equalToConstant: 400).isActive = true

        testView.backgroundColor = .blue
        testView.shadowEnable = false
        testView.setShadow(color: .black, x: 0, y: 5, blur: 10, spread: 0)
        
        
        // clipToBound 테스트, gradient테스트
        contentView.addSubview(gradientView)
        gradientView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: testView.bottomAnchor).isActive = true
        gradientView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
//        gradientView.backgroundColor = .purple
        gradientView.layer.cornerRadius = 10
        print("gradientView 크기:\(gradientView.frame)")
        let color1 = UIColor.purple
        let color2 = UIColor.blue
        gradientView.setGradient(color1: color1, color2: color2)
        
//        gradientView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
//        gradientView.addGestureRecognizer(tap)
        
        
        view.addSubview(nextButotn)
        nextButotn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        nextButotn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButotn.setTitle("다음", for: .normal)
        nextButotn.addTarget(self, action: #selector(self.tapGesture(sender:)), for: .touchUpInside)
    }
    
    @objc
    private func tapGesture(sender:UIButton){
        print("제스처 동작")
//        guard let next = self.storyboard?.instantiateViewController(withIdentifier: "MVVMViewController") as? MVVMViewController else { return }
        let vc = MVVMViewController()
//        self.navigationController?.pushViewController(next, animated: true)
        self.present(vc, animated: true)
    }
    
}
