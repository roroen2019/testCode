//
//  AdoptCollectionViewCell.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//

import UIKit

class AdoptCollectionViewCell: UICollectionViewCell {
    
    // 셀 연결
    static let identifier = "AdoptCollectionViewCell"
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("커스텀셀 에러 발생")
    }
    
    
}

extension AdoptCollectionViewCell {
    private func setupView(){
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
