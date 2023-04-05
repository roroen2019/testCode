//
//  MVVM2ViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/03.
//
/*
 rxswift없는 mvvm테스트
 */
import UIKit

class MVVM2ViewController: UIViewController {
    
    // 데이터
    private var dataArray = [Model2]()
    private var vcTitle = ""
    
    
    // 뷰 모델
    private let viewModel2 = ViewModel2()
    
    // 테이블뷰
    private let mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    // 레이블
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        setBind()
    }
    
}

extension MVVM2ViewController {
    private func setupView(){
        // 뷰 설정
        self.view.addSubview(mainTableView)
        mainTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        
        mainTableView.register(nomalTableViewCell.nib(), forCellReuseIdentifier: nomalTableViewCell.identifier)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        
        self.view.addSubview(mainTitleLabel)
        
        NSLayoutConstraint.activate([
            mainTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainTitleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            
        ])
        
    }
    
    private func setBind(){
        // 뷰모델의 onUpdated변수가 동작하면 실행할 코드를 설정
        viewModel2.onUpdated = { [weak self] in
            self?.dataArray = self?.viewModel2.dataArray ?? [Model2(title: "")]
            self?.mainTableView.reloadData()
        }
        
        viewModel2.setTitleUpdated = { [weak self] in
            self?.mainTitleLabel.text = self?.viewModel2.titleValue
        }
        
        // 뷰모델의 메소드 실행
        viewModel2.setTableViewData()
        viewModel2.setTitleLabel()
        
    }
    
    
    
}

//MARK: 테이블뷰 델리게이트
extension MVVM2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nomalTableViewCell.identifier, for: indexPath) as? nomalTableViewCell else {
            fatalError()
        }
        
        let model = self.dataArray[indexPath.row]
        cell.configure(title: model.title ?? "")
        
        return cell
    }
    
    
}
