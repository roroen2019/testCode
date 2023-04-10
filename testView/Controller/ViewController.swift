//
//  ViewController.swift
//  testView
//
//  Created by myPuppy on 2023/03/14.
//
/*
 가장 처음 보여지는 화면
 */
import UIKit

class ViewController: UIViewController {
    
    // 셀 제목
    private let cellTitle = ["mvvm", "그림자, 레이어", "rxSwift", "mvvm2", "rx 4시간"]
    
    // 테이블뷰
    private let mainTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad 동작")
        setupView()
    }
    
}

extension ViewController {
    //MARK: - 뷰 설정
    private func setupView(){
        self.view.addSubview(mainTableView)
        mainTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        
        mainTableView.register(nomalTableViewCell.nib(), forCellReuseIdentifier: nomalTableViewCell.identifier)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.estimatedRowHeight = 50 //기본높이
        mainTableView.rowHeight = UITableView.automaticDimension //유동적
    }
    
}

//MARK: - 테이블뷰 델리게이트
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    // 셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택:\(indexPath.row)")
        var viewController = UIViewController()
        switch indexPath.row {
        case 0: //mvvm
            viewController = MVVMViewController()
        case 1: //쉐도우 레이어
            viewController = testViewController()
        case 2: //rxswift
            viewController = RxSwiftViewController()
        case 3:
            viewController = MVVM2ViewController()
        case 4:
            viewController = GomRxSwiftViewController()
        default:
            return
        }
        self.present(viewController, animated: true)
    }
    
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTitle.count
    }
    
    // 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nomalTableViewCell.identifier, for: indexPath) as? nomalTableViewCell else {
            fatalError()
        }
        
        let title = "\(indexPath.row). " + self.cellTitle[indexPath.row]
        cell.configure(title: title)
        
        return cell
    }
    
    
}
