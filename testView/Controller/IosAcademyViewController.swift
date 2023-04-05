//
//  IosAcademyViewController.swift
//  testView
//
//  Created by myPuppy on 2023/03/30.
//
/*
 유튜브 채널 ios Academy 예시코드 테스트
 */
import UIKit

class IosAcademyViewController: UIViewController {
    
    // 셀 제목
    private let cellTitle = ["forWhere"]
    
    // 테이블뷰
    private let mainTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        forWhere()
        handleUserName(name: "테스트")
    }
    

}

extension IosAcademyViewController {
    //MARK: 뷰 설정
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
    
    
    //MARK: forWhere
    //https://www.youtube.com/watch?v=-yhFrRmF_0w
    private func forWhere(){
        let numbers = Array(0...1000)
        
        // 기존방법
        for num in numbers {
            if num <= 101{
                print("\(num)")
            }
        }
        
        // for where 적용
        for num in numbers where num <= 101{
            print("적용:\(num)")
        }
        
    }
    
    private func handleUserName(name:String?){
        // name값이 ""값이거나 nil값이 올수 있다.
        // ""값, nil이 아닌경우에만 코드 진행
        if name != "", name != nil{
            print("값 있음")
        }
        
        // ""값 또는 nil이면 false
        if !name.isNilOrEmpty {
            print("값 있음22")
        }
    }
    
}

//MARK: - 테이블뷰 델리게이트
extension IosAcademyViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nomalTableViewCell.identifier, for: indexPath) as? nomalTableViewCell else {
            fatalError()
        }
        
        let title = "\(indexPath.row). " + self.cellTitle[indexPath.row]
        cell.configure(title: title)
        
        return cell
    }
}

// 스트링 옵셔널 확장
extension String? {
    // 이변수를 사용하면 사용한 값이 nil 또는 ""값이면 false를 리턴해주게 된다.
    var isNilOrEmpty:Bool {
        return self == nil || self == ""
    }
}
