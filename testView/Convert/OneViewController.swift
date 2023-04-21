//
//  OneViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//
/*
 스크롤뷰안에 여러가지 뷰가 있음
 
 */
import UIKit
import SwiftUI
import RxSwift


//MARK: - 프리뷰
struct OnePreView:PreviewProvider {
    static var previews: some View {
        OneViewController().toPreview()
    }
}

class OneViewController: UIViewController {
    
    private let viewModel = OneViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    private let mainScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 상단배너
    private let bannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 레이블
    private let animalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트"
        label.textColor = .black
        return label
    }()
    
    // 추천 콜렉션뷰
    private let adoptCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.itemSize = CGSize(width: 150, height: 199)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setBinding()
    }
    
}

extension OneViewController {
    //MARK: 뷰 설정
    private func setupView(){
        self.view.addSubview(mainScrollView)
        mainScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        mainScrollView.backgroundColor = .blue
        
        // 높이 빼고 제약값을 설정
        self.mainScrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: 0).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, multiplier: 1).isActive = true //위,아래 스크롤 되도록 가로길이를 1:1로 설정한다.
        contentView.backgroundColor = .brown
        
        
        // 상단의 베너
        self.contentView.addSubview(bannerView)
        bannerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        bannerView.backgroundColor = .green
        
        // 레이블
        self.contentView.addSubview(animalLabel)
        animalLabel.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 40).isActive = true
        animalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        
        // 추천 콜렉션뷰
        self.contentView.addSubview(adoptCollectionView)
        adoptCollectionView.topAnchor.constraint(equalTo: animalLabel.bottomAnchor, constant: 20).isActive = true
        adoptCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        adoptCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        adoptCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        adoptCollectionView.register(AdoptCollectionViewCell.self, forCellWithReuseIdentifier: AdoptCollectionViewCell.identifier)
        
        
        
    }
    
    //MARK: 데이터바인딩
    private func setBinding(){
        
        // 배너
//        viewModel.bannerData.bind(to: <#T##[CurrentBannerList]...##[CurrentBannerList]#>)
        
        // 추천콜렉션뷰
        viewModel.adoptData.bind(to: adoptCollectionView.rx.items(cellIdentifier: AdoptCollectionViewCell.identifier, cellType: AdoptCollectionViewCell.self))
        { row, model, cell in
            cell.backgroundColor = .brown
            cell.titleLabel.text = model.breedLabel
            
        }.disposed(by: disposeBag)
        
        // 흐음 왜 안되지..
        adoptCollectionView.rx.modelSelected(CurrentNewAdoptList.self).map { data in
            return data.breedLabel
        }.subscribe { value in
            print(value)
        }.disposed(by: disposeBag)
        
        
        // 뉴스콜렉션뷰
        
        
        // 데이터 요청
        viewModel.receiveData()
    }
}
