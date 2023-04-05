//
//  nomalTableViewCell.swift
//  testView
//
//  Created by myPuppy on 2023/03/21.
//

import UIKit

class nomalTableViewCell: UITableViewCell {

    // 셀 연결
    static let identifier = "nomalTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "nomalTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: configure
    func configure(title:String){
        titleLabel.text = title
    }

    
}
