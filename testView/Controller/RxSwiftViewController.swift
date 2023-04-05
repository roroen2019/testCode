//
//  RxSwiftViewController.swift
//  testView
//
//  Created by myPuppy on 2023/03/27.
//
/*
 ios academy 출처: https://www.youtube.com/watch?v=ES5RuLSv61g&t=1s
 rxSwift 연습
 */
import UIKit
import RxSwift
import RxCocoa

//MARK: - model
struct Product {
    let imageName:String
    let title:String
}

//MARK: - viewModel
struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    // 서버에 데이터 요청 메소드, 지금은 임시 데이터 모델 설정.
    func fetchItems(){
        // 데이터배열, 타입은 Product모델
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Setting"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
        ]
        
        items.onNext(products) //데이터를 넣는다?
        items.onCompleted() //아이템 항목이 완료됬다?
    }
    
}

//MARK: - controller(view)
class RxSwiftViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 테이블뷰 설정
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        bindTableData()
    }
    
    private func bindTableData(){
        // 테이블뷰에 아이템을 바인드 한다.
        viewModel.items.bind(to: tableView.rx.items(
            cellIdentifier: "cell",
            cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        // 선택 핸들러를 모델에 바인드한다.
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        
        // 뷰모델의 fetchItems 메소드를 실행한다.
        viewModel.fetchItems()
    }
    

}
