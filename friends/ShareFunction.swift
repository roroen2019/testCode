//
//  ShareFunction.swift
//  friend
//
//  Created by myPuppy on 2022/12/06.
//

import UIKit
import KakaoSDKUser //카카오
import NaverThirdPartyLogin //네이버
import FirebaseFirestore
import FirebaseFirestoreSwift


//MARK: - 서브뷰 삭제
/// 뷰 컨트롤러의 마지막 뷰를 제거한다
func removeLastSubview(vc:UIViewController){
    let lastSubView = vc.view.subviews.last
    lastSubView?.removeFromSuperview()
}

//MARK: - 윈도우 마지막 뷰 삭제
/// 뷰 컨트롤러의 마지막 윈도우 뷰를 제거한다
func removeLastWindow(vc:UIViewController){
    let lastSubView = vc.view.window?.subviews.last
    lastSubView?.removeFromSuperview()
}

//MARK: - 커스텀 프린트
func myLogPrint(_ object: Any, filename: String = #file, _ line: Int = #line, _ funcname: String = #function) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss:SSS"
    print("mylog - [\(dateFormatter.string(from: Date()))]: \(object)")
//    print("Log!! : \(dateFormatter.string(from: Date())) file: \(filename) line: \(line) func: \(funcname))")
//    print(object)
}

//MARK: - 뷰 키보드 위치 확인
func checkViewKeyboardPosition(activeView:UIView) -> CGFloat{
    let globalPoint = activeView.superview?.convert(activeView.frame.origin, to: nil)
    // 윈도우를 기준으로 고정된 위치값이 아닌 선택했을때의 위치값을 알려준다(안전지역 + 네비게이션 높이를 생각하지 말자)
    myLogPrint("글로벌 위치 확인:\(globalPoint)")
    
    // 선택한뷰의 위치값
    let originY = globalPoint?.y ?? 0
    let height = activeView.frame.size.height
    let selectViewHeight = originY + height
//    print("선택한 뷰 하단까지 높이값:\(selectViewHeight)")
    
    // 키보드로 가려지는 높이값을 구하기
    let viewHeight = UIScreen.main.bounds.height
    let scenes = UIApplication.shared.connectedScenes //연결된 scean 인스턴스 가져오기
    let windowScene = scenes.first as? UIWindowScene //첫번째 scean
    let window = windowScene?.windows.first //scean의 첫번째 화면
    let safeFrame = window?.safeAreaLayoutGuide.layoutFrame //화면의 안전구역 프레임
    let safeAreaBottomHeight = viewHeight - (safeFrame?.maxY ?? 0) //하단 안전구역 높이
//    print("하단 안전지역 높이값:\(safeAreaBottomHeight)")
    let keyboardHeight = AppConfig.defaultValue.keyboardHeight // 키보드 높이
    
//    myLogPrint("전체뷰 높이:\(viewHeight), 키보드 높이:\(keyboardHeight), 안전구역 높이:\(safeAreaBottomHeight)")
    // (화면높이 - 네비게이션바 높이) - (키보드높이 + 하단 안전구역 높이)
    let overshadowHeight = viewHeight - (keyboardHeight + safeAreaBottomHeight)
    myLogPrint("선택뷰 높이:\(selectViewHeight), 가려지는 높이:\(overshadowHeight)")
    if selectViewHeight >= overshadowHeight {
        myLogPrint("가려진다")
        // 차이만큼 콘텐츠옵셋값을 변경한다
        return selectViewHeight - overshadowHeight
    }else{
        myLogPrint("가려지지 않는다")
        return 0
    }
}

//MARK: 노티피케이션 해제
func removeNotifiCation(vc:UIViewController){
    NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillHideNotification, object: nil)
}

//MARK: 줄 사이 간격 조절하기
/// 줄 사이 간격 조절하기
func setLineSpacing(text:String, spacing:CGFloat) -> NSMutableAttributedString{
    // 줄 사이 간격 조절하기
    let attriString = NSMutableAttributedString(string: text)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = spacing
    attriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attriString.length))
    
    return attriString
}

//MARK: 특정글자 폰트 변경하기
/// 특정글자 폰트 변경하기
func setChangeFont(fullText:String, changeText:String, changeFont:UIFont) -> NSMutableAttributedString{
    
    let attriString = NSMutableAttributedString(string: fullText)
    // 특정단어 폰트 변경
    attriString.addAttribute(.font, value: changeFont, range: (fullText as NSString).range(of: changeText))
    
    return attriString
}

//MARK: 특정글자 변경 및 간격 변경하기
/// 특정글자 변경 및 간격 변경하기
func setFontLine(fullText:String, changeText:String, changeFont:UIFont, spacing:CGFloat) -> NSMutableAttributedString{
    let attriString = NSMutableAttributedString(string: fullText)
    // 특정단어 폰트 변경
    attriString.addAttribute(.font, value: changeFont, range: (fullText as NSString).range(of: changeText))
    // 글자간격 변경하기
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = spacing
    attriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attriString.length))
    
    return attriString
}

//MARK: 배열을 하나의 스트링으로 변경하기
func setTagList(list:[String]) -> String{
    // 앞에는 #, 뒤에는 빈칸을 추가해야한다
    var result = ""
    for i in list{
        let front = "#"
        let end = " "
        
        let word = front + i + end
        
        result += word
    }
    
    return result
}

//MARK: 3자리마다 콤마 넣기
/// 일반표시용 3잘마다 콤마 넣기
func moneyFormatter(number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(from: NSNumber(value: number))!
}

/// 텍스트필드용 3자리마다 콤마 넣기
func moneyUnit(number: String, replacementString string:String) -> String {
    myLogPrint("입력값 확인:\(number)")
    var text = number
    
    
    text = text.replacingOccurrences(of: ",", with: "")
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    if (string.isEmpty) {
        // delete
        if text.count > 1 {
            guard let price = Int.init("\(text.prefix(text.count - 1))") else {
                return ""
            }
            guard let result = numberFormatter.string(from: NSNumber(value:price)) else {
                return ""
            }
            
            return "\(result)"
        }
        else {
            
            return ""
        }
    }else{
        // add
        guard let price = Int.init("\(text)\(string)") else {
            return ""
        }
        guard let result = numberFormatter.string(from: NSNumber(value:price)) else {
            return ""
        }
        
        return "\(result)"
    }
    
    
    
}




//MARK: 현재 날짜, 시간 구하기
func getNowTime() -> String{
    let now = Date()
    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
    
    return dateFormatter.string(from: now)
}


//MARK: 시간비교하기
func comparisonTime(openCloseTime:String) -> Bool{
    if openCloseTime == "" { return false}
    // "연중무휴 10:00 ~ 20:00"
    let split = openCloseTime.components(separatedBy: " ")
    let startStringTime = split[1] + ":00"
    let endStringTime = split[3] + ":00"
//        myLogPrint("시작시간:\(startStringTime), 종료시간:\(endStringTime)")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    
    
    let shopStart = dateFormatter.date(from: startStringTime)!
    let shopEnd = dateFormatter.date(from: endStringTime)!
    
    let now = getNowTime()
    let nowTime = dateFormatter.date(from: now)!
    
    myLogPrint("지금 확인:\(nowTime), 시작시간:\(shopStart), 닫는시간:\(shopEnd)")
    
    if nowTime > shopStart && nowTime < shopEnd {
        myLogPrint("영업시간")
        return true
    }else{
        myLogPrint("영업시간 아님")
        return false
    }
}

//MARK: 토스트 메세지
func toastMessageView(view:UIView, message:String){
    // view 사용안함
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let scenes = UIApplication.shared.connectedScenes //연결된 scean 인스턴스 가져오기
    let windowScene = scenes.first as? UIWindowScene //첫번째 scean
    guard let window = windowScene?.windows.first else { return } //scean의 첫번째 화면
    let safeFrame = window.safeAreaLayoutGuide
    
    window.addSubview(label)
    
    label.leadingAnchor.constraint(equalTo: safeFrame.leadingAnchor, constant: 40).isActive = true
    label.trailingAnchor.constraint(equalTo: safeFrame.trailingAnchor, constant: -40).isActive = true
    label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    label.bottomAnchor.constraint(equalTo: safeFrame.bottomAnchor, constant: -100).isActive = true
    
    
    label.backgroundColor = .black.withAlphaComponent(0.7)
    label.font = .SCDFont(type: .four, size: 14)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    label.alpha = 1
    label.textColor = .white
    label.text = message
    
    UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
        label.alpha = 0.0
    }, completion: {(isCompleted) in
        label.removeFromSuperview()
    })
    
}

//MARK: 로그아웃
// 어떤방식으로 로그인 했는지 확인
// 로컬에 저장된 모든값을 삭제한다
func logout(VC:UIViewController){
    
    // 네이버 로그인
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    // 로컬저장
    let userdefault = UserDefaults.standard
    let atType = userdefault.string(forKey: UserDefaultKey.snsType.rawValue)
    
    // 카카오로 로그인 또는 회원가입일 경우 카카오에 로그아웃 요청
    //    myLogPrint("로그아웃 타입:\(atType)")
    if atType == "kakao"{
        UserApi.shared.logout {(error) in
            if let error = error {
                print("@@@@ 에러:\(error)")
            }
            else {
                print("@@@@ logout() success.")
            }
        }
    }
    
    
    // 네이버 로그인인지 확인
    if atType == "naver"{
        naverLoginInstance?.requestDeleteToken()
    }
    
    // 애플 로그아웃 없음
    
    // 로컬에 저장된 값 모두 삭제(내가 저장한 값만 삭제한다. 내가 저장한값 외에도 여러가지가 저장되어있어서 for문 돌려서 삭제는 못한다)
//    userdefault.removeObject(forKey: UserDefaultKey.fcmToken.rawValue) //fcm은 삭제하면 안된다.
    userdefault.removeObject(forKey: UserDefaultKey.headerToken.rawValue)
    userdefault.removeObject(forKey: UserDefaultKey.userID.rawValue)
    userdefault.removeObject(forKey: UserDefaultKey.snsType.rawValue)
    userdefault.removeObject(forKey: UserDefaultKey.nickName.rawValue)
    
    //로컬파일에 저장된 안읽은 메시지 전체 삭제
    PushNotification.removeAll()
    UIApplication.shared.applicationIconBadgeNumber = 0
    
    // 처음화면으로 이동
    VC.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    
}

//MARK: api에러코드 처리 함수
func apiErrorCode(vc:UIViewController, code:String){
    // 예외처리
    guard code != "" else { return }
    
    switch code {
    case "a":
        // 유효하지 않은 JWT AccessToken. (액세스 토큰으로 반환한 키가 근본적으로 잘못되었음 = 정상 로직상 일어날 일 없음)
        ()
    case "b", "c":
        // b: 만료된 JWT RefreshToken.
        // c: 존재하지 않는 유저 (API 요청시 JWT 토큰을 전달한 경우, 해당 토큰의 주인이 누군지를 파악하려고 DB 정보를 가져왔지만 그 시점, 다른 곳에서 회원 탈퇴를 해서 null 이 반환될 때)
        
        
        
        // 1.현재 저장된 토큰을 삭제한다(로그아웃과 같은거 아닌가?)
        // 네이버 로그인
        let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        // 로컬저장
        let userdefault = UserDefaults.standard
        let atType = userdefault.string(forKey: UserDefaultKey.snsType.rawValue)
        
        // 카카오로 로그인 또는 회원가입일 경우 카카오에 로그아웃 요청
        myLogPrint("로그아웃 타입:\(atType)")
        if atType == "kakao"{
            UserApi.shared.logout {(error) in
                if let error = error {
                    print("@@@@ 에러:\(error)")
                }
                else {
                    print("@@@@ logout() success.")
                }
            }
            
        }else{
            // 네이버 로그인
            naverLoginInstance?.requestDeleteToken()
        }
        
        // 애플 로그아웃 없음
        myLogPrint("로컬 저장값 모두 삭제하기")
        // 로컬에 저장된 값 모두 삭제(내가 저장한 값만 삭제한다. 내가 저장한값 외에도 여러가지가 저장되어있어서 for문 돌려서 삭제는 못한다)
        userdefault.removeObject(forKey: UserDefaultKey.headerToken.rawValue)
        userdefault.removeObject(forKey: UserDefaultKey.userID.rawValue)
        userdefault.removeObject(forKey: UserDefaultKey.snsType.rawValue)
        userdefault.removeObject(forKey: UserDefaultKey.nickName.rawValue)
        
        let className = NSStringFromClass(vc.classForCoder)
        myLogPrint("클래스 이름:\(className)")
        if className == "friend.SplashViewController"{
            myLogPrint("스플래시에서 api에러코드 발생")
            // 홈화면으로 이동
            // 다음화면 이동
            guard let nextViewController = vc.storyboard?.instantiateViewController(withIdentifier: "startNavi") else{
                return
            }

            nextViewController.modalTransitionStyle = .crossDissolve // 화면넘어갈때 애니메이션 효과
            nextViewController.modalPresentationStyle = .fullScreen //전체화면

            vc.present(nextViewController, animated: false, completion: {
                // 키보드 높이 구하기
                let keyboardHeight = KeyboardService.keyboardHeight()
                AppConfig.defaultValue.keyboardHeight = keyboardHeight
                myLogPrint("키보드높이:\(keyboardHeight)")
            })
        }else{
            // 홈화면으로 이동
            vc.navigationController?.popToRootViewController(animated: true)
            
        }
        
        // 2.재시작 하기(가장 처음 화면으로 이동) -> 아.. 그냥 홈 화면으로 이동시키면 되는군;
//        vc.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
        
    default:
        myLogPrint("무슨에러코드지?:\(code)")
    }
}


//MARK: Dictionary, 배열을 jsonstring으로 변환한다
///배열을 jsonString으로 변환한다
func convertJsonStringToDictionary(data:Any) -> String{
    print("@@@@ 딕셔너리, 배열 값 확인:\(data)")
    var stringValue = ""
    do {
        // Convert object to JSON as NSData
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        print("@@@@ JSON data: \(jsonData)")
        
        // Convert NSData to String
        stringValue = String(data: jsonData, encoding: .utf8)!
        print("@@@@ JSON string: \(stringValue)")
    } catch {
        print("@@@@ error writing JSON: \(error)")
    }
    
    return stringValue
}



//MARK: 채팅방에 인포메시지 보내고 상태값 변경
func setChatRoomDeactiveAndSendMsg(applicationUid: Int, msg: String, infoMsg: String, senderUid: Int, status: Int){ //0:분양자->입양자, 1:입양자->분양자
    
    let chat_db = Firestore.firestore().collection(AppConfig.defaultValue.CHAT_COLLECTION)
    
    if 0 == status { //0:분양자->입양자
        
        let db = chat_db.whereField("adoptPetApplicationUid", isEqualTo: applicationUid)
        db.getDocuments { (chatQuerySnap, error) in
            
            if error != nil {
                
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    
                    return
                }
                
                if queryCount == 0 { //기존에 채팅방이 없는 경우(error)
                    
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    return
                }
                else { //방이 존재하는 경우
                    
                    for doc in chatQuerySnap!.documents {
                        
                        //(1)adoptPetOwnerLeave => true
                        chat_db.document(doc.reference.documentID).updateData(["adoptPetOwnerLeave": true]) { err in
                            
                            if let err = err {
                                print("Error updating document: \(err)")
                                
                                return
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        //(2)activate == true 일때만 인포메시지 보내기
                        if let activate = doc.get("activate") as? Bool, activate == true {
                            
                            //채팅방 안에 인포메시지 보내기
                            let message = Message(chatContent: msg, chatContentType: infoMsg, chatCreateDate: Timestamp(), chatSenderUserUid: senderUid)
                            doc.reference.collection(AppConfig.defaultValue.MSG_COLLECTION).addDocument(data: message.representation, completion: { (error) in
                                
                                if let error = error {
                                    print("Error Sending message: \(error)")
                                    
                                    return
                                }
                                
                                //채팅방 상태값 변경
                                chat_db.document(doc.reference.documentID).updateData(["lastMsgDate" : message.chatCreateDate, "unreadCnt_owner" : 0, "unreadCnt_adoptee" : FieldValue.increment(Int64(1))]) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                        
                                        return
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            })
                        }
                        
                        break
                    }
                }
            }
        }
    }else{ //1:입양자->분양자
        
        let db = chat_db.whereField("adoptPetApplicationUid", isEqualTo: applicationUid)
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if error != nil {
                
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    
                    return
                }
                
                if queryCount == 0 { //기존에 채팅방이 없는 경우(error)
                    
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    return
                }
                else { //방이 존재하는 경우
                    
                    for doc in chatQuerySnap!.documents {
                        
                        //(1)activate => false
                        chat_db.document(doc.reference.documentID).updateData(["activate": false]) { err in
                            
                            if let err = err {
                                print("Error updating document: \(err)")
                                
                                return
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        //(2)adoptPetOwnerLeave == false 일때만 인포메시지 보내기
                        if let activate = doc.get("adoptPetOwnerLeave") as? Bool, activate == false {
                            
                            //채팅방 안에 인포메시지 보내기
                            let message = Message(chatContent: msg, chatContentType: infoMsg, chatCreateDate: Timestamp(), chatSenderUserUid: senderUid)
                            doc.reference.collection(AppConfig.defaultValue.MSG_COLLECTION).addDocument(data: message.representation, completion: { (error) in
                                
                                if let error = error {
                                    print("Error Sending message: \(error)")
                                    
                                    return
                                }
                                
                                //채팅방 상태값 변경
                                chat_db.document(doc.reference.documentID).updateData(["lastMsgDate" : message.chatCreateDate, "unreadCnt_owner" : FieldValue.increment(Int64(1)), "unreadCnt_adoptee" : 0]) { err in
                                    
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                        
                                        return
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            })
                        }
                        
                        break
                    }
                }
            }
        }
    }
}

//MARK: 채팅방에만 푸쉬 보냄(Active==True)
func sendPushWhenActive(toUserUid: Int?, toTokens: [String]?, body: String, sound: Bool, type: Int, adoptPetApplicationUid: Int, adoptPetUid: Int, adoptPetOwnerUserUid: Int, adopteeUserUid: Int, status: Int) { //0:분양자->입양자, 1:입양자->분양자
    
    let chat_db = Firestore.firestore().collection(AppConfig.defaultValue.CHAT_COLLECTION)
    
    if 0 == status { //0:분양자->입양자
     
        let db = chat_db.whereField("adoptPetApplicationUid", isEqualTo: adoptPetApplicationUid)
        db.getDocuments { (chatQuerySnap, error) in
            
            if error != nil {
                
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    
                    return
                }
                
                if queryCount == 0 { //기존에 채팅방이 없는 경우(error)
                    
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    return
                }
                else { //방이 존재하는 경우
                    
                    for doc in chatQuerySnap!.documents {
                        
                        //activate == true 일때만 Push 보내기
                        if let activate = doc.get("activate") as? Bool, activate == true {
                            
                            DispatchQueue.global().async {
                             
                                let sender = PushNotificationSender()
                                if let userUid = toUserUid {
                                 
                                    sender.sendPushNotificationByUserUid(userUid: userUid, body: body, sound: sound, type: type, adoptPetApplicationUid: adoptPetApplicationUid, adoptPetUid: adoptPetUid, adoptPetOwnerUserUid: adoptPetOwnerUserUid, adopteeUserUid: adopteeUserUid)
                                }else if let tokens = toTokens {
                                    
                                    sender.sendPushNotification(to: tokens, body: body, sound: sound, type: type, adoptPetApplicationUid: adoptPetApplicationUid, adoptPetUid: adoptPetUid, adoptPetOwnerUserUid: adoptPetOwnerUserUid, adopteeUserUid: adopteeUserUid)
                                }
                            }
                        }
                        
                        break
                    }
                }
            }
        }
    }else{ //1:입양자->분양자
        
        let db = chat_db.whereField("adoptPetApplicationUid", isEqualTo: adoptPetApplicationUid)
        db.getDocuments { (chatQuerySnap, error) in
            
            if error != nil {
                
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    
                    return
                }
                
                if queryCount == 0 { //기존에 채팅방이 없는 경우(error)
                    
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    return
                }
                else { //방이 존재하는 경우
                    
                    for doc in chatQuerySnap!.documents {
                        
                        //activate == true 일때만 Push 보내기
                        if let activate = doc.get("adoptPetOwnerLeave") as? Bool, activate == false {
                            
                            DispatchQueue.global().async {
                             
                                let sender = PushNotificationSender()
                                if let userUid = toUserUid {
                                 
                                    sender.sendPushNotificationByUserUid(userUid: userUid, body: body, sound: sound, type: type, adoptPetApplicationUid: adoptPetApplicationUid, adoptPetUid: adoptPetUid, adoptPetOwnerUserUid: adoptPetOwnerUserUid, adopteeUserUid: adopteeUserUid)
                                }else if let tokens = toTokens {
                                    
                                    sender.sendPushNotification(to: tokens, body: body, sound: sound, type: type, adoptPetApplicationUid: adoptPetApplicationUid, adoptPetUid: adoptPetUid, adoptPetOwnerUserUid: adoptPetOwnerUserUid, adopteeUserUid: adopteeUserUid)
                                }
                            }
                        }
                        
                        break
                    }
                }
            }
        }
    }
}

//MARK: 채팅방 정보 가져오기
func getChattingRoomInfo(applicationUid: Int, completion: @escaping (_ adoptPetOwnerUserUid:Int, _ adoptPetUid: Int, _ adopteeUserUid: Int, _ adopteeUserNickname: String) -> Void) {
    
    let chat_db = Firestore.firestore().collection(AppConfig.defaultValue.CHAT_COLLECTION)
    let db = chat_db.whereField("adoptPetApplicationUid", isEqualTo: applicationUid)
    db.getDocuments { (chatQuerySnap, error) in
        
        if error != nil {
            
            completion(-1,-1,-1,"")
        } else {
            
            //Count the no. of documents returned
            guard let queryCount = chatQuerySnap?.documents.count else {
                
                completion(-1,-1,-1,"")
                return
            }
            
            if queryCount == 0 { //기존에 채팅방이 없는 경우(error)
                
                //If documents count is zero that means there is no chat available and we need to create a new instance
                completion(-1,-1,-1,"")
            }
            else { //방이 존재하는 경우
                
                for doc in chatQuerySnap!.documents {
                    
                    if let adoptPetOwnerUserUid = doc.get("adoptPetOwnerUserUid") as? Int, let adoptPetUid = doc.get("adoptPetUid") as? Int, let adopteeUserUid = doc.get("adopteeUserUid") as? Int, let adopteeUserNickname = doc.get("adopteeUserNickname") as? String   {
                        
                        completion(adoptPetOwnerUserUid, adoptPetUid, adopteeUserUid, adopteeUserNickname)
                        return
                    }
                }
                
                completion(-1,-1,-1,"")
            }
        }
    }
}

//MARK: 채팅방에 메시지 보내기
func sendMsgToChatRoom(applicationUid: Int, msg: String, infoMsg: String, senderUid: Int, status: Int){ //0:분양인인 경우, 1:입양인인 경우
    
    let chat_db = Firestore.firestore().collection(AppConfig.defaultValue.CHAT_COLLECTION)
    let db = chat_db.whereField("adoptPetApplicationUid", isEqualTo: applicationUid)
    
    db.getDocuments { (chatQuerySnap, error) in
        
        if error != nil {
            
            return
        } else {
            
            //Count the no. of documents returned
            guard let queryCount = chatQuerySnap?.documents.count else {
                
                return
            }
            
            if queryCount == 0 { //기존에 채팅방이 없는 경우(error)
                
                //If documents count is zero that means there is no chat available and we need to create a new instance
                return
            }
            else { //방이 존재하는 경우
                
                for doc in chatQuerySnap!.documents {
                    
                    //채팅방 안에 인포메시지 보내기
                    let message = Message(chatContent: msg, chatContentType: infoMsg, chatCreateDate: Timestamp(), chatSenderUserUid: senderUid)
                    doc.reference.collection(AppConfig.defaultValue.MSG_COLLECTION).addDocument(data: message.representation, completion: { (error) in
                        
                        if let error = error {
                            print("Error Sending message: \(error)")
                            
                            return
                        }
                        
                        //채팅방 상태값 변경
                        if 0 == status { //분양인인 경우
                            
                            chat_db.document(doc.reference.documentID).updateData(["lastMsgDate" : message.chatCreateDate, "unreadCnt_owner" : 0, "unreadCnt_adoptee" : FieldValue.increment(Int64(1))]) { err in
                                
                                if let err = err {
                                    print("Error updating document: \(err)")
                                    
                                    return
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        }else{ //입양인인 경우
                            
                            chat_db.document(doc.reference.documentID).updateData(["lastMsgDate" : message.chatCreateDate, "unreadCnt_owner" : FieldValue.increment(Int64(1)), "unreadCnt_adoptee" : 0]) { err in
                                
                                if let err = err {
                                    print("Error updating document: \(err)")
                                    
                                    return
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        }
                    })
                    
                    break
                }
            }
        }
    }
}

//MARK: 이미지 줄이기
func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
