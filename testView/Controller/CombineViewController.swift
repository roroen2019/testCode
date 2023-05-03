//
//  CombineViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/27.
//
/*
 ios academy 참고
 https://www.youtube.com/watch?v=hbY1KTI0g70
 */
import UIKit
import Combine

//MARK: - UITableViewCell
class MyCustomTableCell: UITableViewCell {
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("버튼", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 6)
    }
    
    @objc private func buttonAction(){
        action.send("버튼선택")
    }
    
}

//MARK: - UIViewController
class CombineViewController: UIViewController {

    private let mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    private var models = [String]()
    
    var observer: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
    }
    
    //MARK: 뷰 설정
    private func setupView(){
        self.view.addSubview(mainTableView)
        mainTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        mainTableView.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        
        // api 호출
        APICaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main) //스레드 설정
            .sink { completion in
                // 완료되면 호출되는 곳
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
                
            } receiveValue: { [weak self] value in
                // 받는값 확인
                self?.models = value
                self?.mainTableView.reloadData()
            }.store(in: &observer)

        
    }
    
}

//MARK: - 뷰 설정
extension CombineViewController :UITableViewDelegate, UITableViewDataSource {
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    // 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else { fatalError()
        }
        
        cell.action.sink { string in
            print(string)
        }.store(in: &observer)
//        cell.textLabel?.text = self.models[indexPath.row]
        
        return cell
    }
    
    
}
