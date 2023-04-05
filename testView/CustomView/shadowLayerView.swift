//
//  shadowLayerView.swift
//  testView
//
//  Created by myPuppy on 2023/03/14.
//

import UIKit

class shadowLayerView: UIView {
    
    /// 그림자 true:유/ false:무
    var shadowEnable = false
    // 그림자
    private var shadowColor : UIColor?
    private var shadowX: CGFloat? = 0
    private var shadowY: CGFloat? = 0
    private var blur:CGFloat? = 0
    private var spread:CGFloat? = 0
    
    // gradient
    private var gradientColor1: UIColor?
    private var gradientColor2: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("쉐도우뷰 init 동작 :\(frame)")
        print("테스트값 확인111:\(shadowEnable)")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("커스텀뷰 에러 발생")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("쉐도우뷰 layoutSubviews 동작")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("쉐도우뷰 draw 동작 :\(rect)")
        print("테스트값 확인222:\(shadowEnable)")
        setShadowView()
        setGradientView()
    }
    
    
    func setShadow(color:UIColor, x:CGFloat, y:CGFloat, blur:CGFloat, spread:CGFloat){
        self.shadowColor = color
        self.shadowX = x
        self.shadowY = y
        self.blur = blur
        self.spread = spread
    }
    
    // 그림자 설정
    private func setShadowView(){
        if shadowEnable {
            if spread == 0{
                layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: layer.cornerRadius).cgPath
            }else{
                let rect = self.bounds.insetBy(dx: -spread!, dy: -spread!)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
            
            layer.shadowColor = shadowColor!.cgColor
            layer.shadowOpacity = Float(shadowColor!.cgColor.alpha)
            layer.shadowOffset = CGSize(width: shadowX!, height: shadowY!)
            layer.shadowRadius = blur! / UIScreen.main.scale
            layer.masksToBounds = false
        }
    }
    
    func setGradient(color1:UIColor, color2:UIColor){
        self.gradientColor1 = color1
        self.gradientColor2 = color2
    }
    
    
    // gradient설정
    private func setGradientView(){
        // 한번만 동작하기 위해서 조건을 건다
        let sublayer = self.layer.sublayers?[0]
        if sublayer is CAGradientLayer {
            print("활성화 그라디언트 레이어")
            // 레이어에 이미 그라디언트가 있으면 더이상 진행안함
            return
        }
        print("gradient 전 크기:\(self.bounds)")
        if self.gradientColor1 == nil{
            return
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [self.gradientColor1!.cgColor, self.gradientColor2!.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
        print("gradient 후 크기:\(gradient.frame)")
    }
    
    
    
}
