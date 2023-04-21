//
//  PreviewTestViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/14.
//

import UIKit
import SwiftUI

//MARK: - 프리뷰
struct TestVCPreView:PreviewProvider {
    static var previews: some View {
        PreviewTestViewController().toPreview()
    }
}


class PreviewTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "테스트"
        titleLabel.textColor = .blue
        self.view.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
    

}
