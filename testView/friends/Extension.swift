//
//  Extension.swift
//  friend
//
//  Created by myPuppy on 2022/12/01.
//

import UIKit

//MARK: - UIFont
extension UIFont {
    
    /*
     // 폰트정보 확인하기(여기서 내가 등록한 폰트가 안나올경우 info 확인(파일확장자까지 입력해야한다. abcd.otf)
     for fontFamilyName in UIFont.familyNames{
         for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
             print("Family: \(fontFamilyName)     Font: \(fontName)")
         }
     }
     */
    
    public enum SCDType: String {
        case one = "1Thin"
        case two = "2ExtraLight"
        case three = "3Light"
        case four = "4Regular"
        case five = "5Medium"
        case six = "6Bold"
        case seven = "7ExtraBold"
        case eight = "8Heavy"
        case nine = "9Black"
    }
    
    static func SCDFont(type: SCDType, size: CGFloat) -> UIFont {
        let fontName = "S-CoreDream-\(type.rawValue)"
//        print("폰트이름 확인:\(fontName)")
        return UIFont(name: fontName, size: size)!
    }
}

//MARK: - UIView
extension UIView {
    
    /// 좌우 2가지 색상 그라데이션, 만약 cornerRadius를 뷰에 적용했다면 해당 함수를 가장 나중에 실행한다
    /// frame:스토리보드의 버튼 크기가 아닌 코드상의 버튼크기를 넣는다.
    func setHorizontalGradient(color1:UIColor, color2:UIColor, frame:CGRect? = nil){
        
        // 한번만 동작하기 위해서 조건을 건다
        let sublayer = self.layer.sublayers?[0]
        if sublayer is CAGradientLayer {
            myLogPrint("활성화 그라디언트 레이어")
            // 레이어에 이미 그라디언트가 있으면 더이상 진행안함
            return
        }
        myLogPrint("gradient 전 크기:\(self.bounds)")
        
        let gradient = CAGradientLayer()
        if frame == nil {
            gradient.frame = bounds
        }else{
            gradient.frame = frame!
        }
        
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
        myLogPrint("gradient 후 크기:\(gradient.frame)")
    }
    
    /// 상하 2가지 색상 그라데이션
    func setVerticalGradient(color1:UIColor, color2:UIColor){
        
        // 한번만 동작하기 위해서 조건을 건다
        let sublayer = self.layer.sublayers?[0]
        if sublayer is CAGradientLayer {
            myLogPrint("활성화 그라디언트 레이어")
            // 레이어에 이미 그라디언트가 있으면 더이상 진행안함
            return
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    
    /// 상하 3가지 색상 그라데이션
    func setVerticalGradient(color1:UIColor, color2:UIColor, color3:UIColor){
        
        // 한번만 동작하기 위해서 조건을 건다
        let sublayer = self.layer.sublayers?[0]
        if sublayer is CAGradientLayer {
            myLogPrint("활성화 그라디언트 레이어")
            // 레이어에 이미 그라디언트가 있으면 더이상 진행안함
            return
        }
        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.frame = bounds
//        gradient.locations = [0.2, 0.8]
//        layer.addSublayer(gradient)
        layer.insertSublayer(gradient, at: 0)
    }
    
    
    /// 그림자 만들기
    func setShadow(rgba:UIColor, x:CGFloat, y:CGFloat, blur:CGFloat, spread:CGFloat, frame:CGRect? = nil){
        
        var newBounds:CGRect
        if frame == nil {
            newBounds = bounds
        }else{
            newBounds = frame!
        }
        
        
        
        if spread == 0{
            layer.shadowPath = UIBezierPath(roundedRect: newBounds, cornerRadius: layer.cornerRadius).cgPath
        }else{
            let rect = newBounds.insetBy(dx: -spread, dy: -spread)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        layer.shadowColor = rgba.cgColor
        layer.shadowOpacity = Float(rgba.cgColor.alpha)
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / UIScreen.main.scale
        layer.masksToBounds = false
        
    }
    
    /// view를 UIimage로 변환
    func asImage() -> UIImage{
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}

//MARK: - UIButton
extension UIButton {
    
    
    //MARK: 타이틀 밑줄
    func setUnderline(title:String) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        
        setAttributedTitle(attributedString, for: .normal)
    }
    
    //MARK: 콘텐츠 버튼 선택효과
    /// 버튼 선택효과(네, 아니오)
    func setSelectEffect(title:String, font:UIFont, nonSelectImage:UIImage?, selectImage:UIImage?, fontColor:UIColor, fontSelectColor:UIColor){
        setTitle(title, for: .normal)
        setTitle(title, for: .selected)
        setImage(nonSelectImage, for: .normal)
        setImage(selectImage, for: .selected)
        titleLabel?.font = font
        setTitleColor(fontColor, for: .normal)
        setTitleColor(fontSelectColor, for: .selected)
        tintColor = .clear
    }
    
    //MARK: 버튼 활성화 비활성화 뷰 변경
    /// 버튼 활성화 비활성화 뷰 변경(하단의 최종버튼)
    func setSelectEnable(){
        
        let color = AppCustomColor.shared
        let state = self.isEnabled
        myLogPrint("버튼 활성화 확인:\(state)")
        switch state {
        case true: //활성화
            self.setTitleColor(.white, for: .normal)
            
            // 한번만 동작하기 위해서 조건을 건다
            let layer = self.layer.sublayers?[0]
            if layer is CAGradientLayer {
                myLogPrint("활성화 그라디언트 레이어")
                // 레이어가 있으므로 아무것도 안함
            }else{
                myLogPrint("활성화 그라디언트 레이어 아님")
                // 그라디언트 레이어가 없으므로 레이어를 설정한다
                let color1 = color.purple11460237
                let color2 = color.purple15384255
                self.setHorizontalGradient(color1: color2, color2: color1)
            }
            
            
        case false: //비활성화
            self.setTitleColor(color.gray223, for: .normal)
            // 서브레이어 지우기
            let layer = self.layer.sublayers?[0]
            if let gradientLayer = layer as? CAGradientLayer {
                myLogPrint("그라디언트 레이어")
                gradientLayer.removeFromSuperlayer()
            }else{
                myLogPrint("그라디언트 레이어 아님")
            }
            
            
            self.backgroundColor = color.gray158
            
        }
    }
    
    
}


//MARK: - UITextField
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    // 참고: https://woongsios.tistory.com/315
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
        self.rightView = clearButton
        self.rightViewMode = mode
    }
    
    @objc
    private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
}

//MARK: - UIViewController
extension UIViewController {
    /// 뒤로가기버튼 설정
    func setupBackButton(vc:UIViewController, title:String? = nil){
        // 타이틀 설정
        vc.navigationItem.title = title
        let customFont = UIFont.SCDFont(type: .five, size: 16)
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        
        // 뒤로가기버튼 설정
        let backImage = UIImage(named: "naviArrow")
        let customBackButton = UIButton()
        customBackButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customBackButton.setImage(backImage, for: .normal)
        customBackButton.addTarget(vc, action: #selector(backButtonAction), for: .touchUpInside)
    //    customBackButton.contentHorizontalAlignment = .left
        let backButtonItem = UIBarButtonItem(customView: customBackButton)
        vc.navigationItem.leftBarButtonItem = backButtonItem
    //    vc.navigationItem.leftBarButtonItems = [negativeSpacer, backButtonItem]
    }
    
    
    @objc private func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - String
extension String {
    var lastIndex: Int {
        get {
            if self.isEmpty { return 0 }
            
            if let lastString = self.last, let i = self.lastIndex(of: lastString) {
                let index: Int = self.distance(from: self.startIndex, to: i)
                return index
            }
            
            return 0
        }
    }
    
    func trimingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }
        
        return String(self[index...])
    }
    
    func trimingTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }

        return String(self[...index])
    }
    
    func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
            
        return components(separatedBy: characterSet).joined()
    }
    
    // html태그 제거
    func removeHtmlTags() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            let plainText = attributedString.string
            let result = plainText
                .replacingOccurrences(of: "&lt;", with: "<")
                .replacingOccurrences(of: "&gt;", with: ">")
                .replacingOccurrences(of: "&quot;", with: "\"")
                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            return result
        } catch {
            print("Error: \(error.localizedDescription)")
            return self
        }
    }
    
}

//MARK: - Double
extension Double {
    var prettyDistance: String {
        guard self > -.infinity else { return "?" }
        let formatter = LengthFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        if self >= 1000 {
            let value = Double(Int(self / 1000)) // 소수점 제거
            return formatter.string(fromValue: value, unit: LengthFormatter.Unit.kilometer)
        } else {
            let value = Double(Int(self)) // 미터로 표시할 땐 소수점 제거
            return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
        }
    }
}

//MARK: - CALayer
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

//MARK: - UILabel
extension UILabel {
    func setImageText(image:UIImage?, text:String){
        let sexAttributed = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        sexAttributed.append(NSAttributedString(attachment: imageAttachment))
        sexAttributed.append(NSAttributedString(string: " "+text))
        
        self.attributedText = sexAttributed
    }
}


//MARK: - UIStackView
extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    /// 스택뷰 안의 모든 서브뷰를 제거한다
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}


//MARK: UIImage
extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            //return self.copy() as? UIImage
            return self
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        default:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}

//MARK: - 노티피케이션 이름 설정
extension Notification.Name {
    /// 나의 반려동물에서 반려동물보기 버튼 눌렀을때 동작
    static let tabbarTwo = Notification.Name("tabbarTwo")
    /// 동적링크
    static let dynamicLink = Notification.Name("dynamicLink")
    
    //채팅 메시지 갱신
    static let msgReceived = Notification.Name("msgReceived")
    
    //알람 표시 갱신
    static let alarmReceived = Notification.Name("alarmReceived")
   
}
