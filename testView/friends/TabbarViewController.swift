//
//  TabbarViewController.swift
//  friend
//
//  Created by myPuppy on 2022/11/30.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    private let customColor = AppCustomColor.shared
    
    // 상단 뷰
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    // 타이틀 버튼
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 스택뷰
    private lazy var stackview: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 7
        return stack
    }()
    
    
    // 검색버튼
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 알림버튼
    private lazy var alertButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Chatting
    lazy var chat_db = {
        
        return Firestore.firestore().collection(AppConfig.defaultValue.CHAT_COLLECTION)
    }()
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        checkLogin()

        //안읽은 메시지 갱신
        //NotificationCenter.default.addObserver(self, selector: #selector(setUnreadMsgCnt), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.setUnreadMsgCnt()
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let tabTitle = item.title
        self.setTabAction(tabTitle: tabTitle)
        
        
    }

}

extension TabbarViewController {
    
    //MARK: 뷰 설정
    private func setupView(){
        self.navigationController?.isNavigationBarHidden = true
//        self.delegate = self
        
        // 탭바 선택 효과
        self.tabBar.tintColor = AppCustomColor.shared.purple11460237
        // 탭바 기본 그림자 스타일 초기화
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        let tabbarShadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        self.tabBar.setShadow(rgba: tabbarShadowColor, x: 0, y: -3, blur: 6, spread: 0)
        
        
        
        let height = AppConfig.defaultValue.topViewHeight
        let statusHeight = AppConfig.defaultValue.statusHeight
        let leftPadding = AppConfig.defaultValue.leftPadding
        
        self.view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        // 타이틀 버튼
        self.topView.addSubview(titleButton)
        titleButton.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: leftPadding).isActive = true
        titleButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor).isActive = true
        let fontColor = customColor.gray102
        titleButton.setTitleColor(fontColor, for: .normal)
        titleButton.titleLabel?.font = UIFont.SCDFont(type: .nine, size: 20)
        
        let fullText = "펫링크프렌즈"
        let changeText = "펫링크"
        let changeColor = customColor.purple11460237
        // NSMutableAttributedString Type으로 바꾼 text를 저장
        let attributedStr = NSMutableAttributedString(string: fullText)
        // text의 range 중에서 number라는 글자는 UIColor를 메인칼라로 변경
        attributedStr.addAttribute(.foregroundColor, value: changeColor, range: (fullText as NSString).range(of: changeText)) //색 변경
        
        titleButton.setAttributedTitle(attributedStr, for: .normal)
        titleButton.addTarget(self, action: #selector(titleButtonClick), for: .touchUpInside)
        
        
        
        // 스택뷰
        self.topView.addSubview(stackview)
        stackview.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -leftPadding).isActive = true
        stackview.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor).isActive = true
        
        
        // 검색버튼
        self.stackview.addArrangedSubview(searchButton)
        searchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let searchImage = UIImage(named: "search")
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        searchButton.isHidden = true
        
        // 알림버튼
        self.stackview.addArrangedSubview(alertButton)
        alertButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        alertButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let alertImage = UIImage(named: "alert")
        alertButton.setImage(alertImage, for: .normal)
        alertButton.addTarget(self, action: #selector(alertButtonClick), for: .touchUpInside)
        
    }
    
    //MARK: 홈버튼
    @objc private func titleButtonClick(){
        myLogPrint("제목버튼 눌림")
        self.selectedIndex = 0
    }
    
    //MARK: 검색버튼
    @objc private func searchButtonClick(){
        myLogPrint("검색버튼 눌림")
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else{
            return
        }
        
        self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
    }
    
    
    //MARK: 알림버튼
    @objc private func alertButtonClick(){
        myLogPrint("알림버튼 눌림")
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else{
            return
        }
        
        self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
    }
    
    //MARK: 로그인 확인
    // 로그인인지 확인후 뷰 변경 함수
    private func checkLogin(){
        
        let login = UserDefaults.standard.string(forKey: UserDefaultKey.snsType.rawValue)
        
        if login == nil{
            //비 로그인 상태
            alertButton.isHidden = true
        }else{
            //로그인 상태
            alertButton.isHidden = false
            // 새 알림 카운트 서버통신
            requestNewAlertCount()
        }
    }
    
    
    //MARK: 탭별 동작
    private func setTabAction(tabTitle:String?){
        switch tabTitle {
        case "홈":
            searchButton.isHidden = true
        case "분양":
            searchButton.isHidden = true
        case "내주변":
            searchButton.isHidden = false
        case "마이펫링크":
            searchButton.isHidden = true
            
            // 로그인 확인
            let login = UserDefaults.standard.string(forKey: UserDefaultKey.snsType.rawValue)
            if login == nil {
                // 로그인 상태가 아니면 로그인 화면으로 이동
                let storyboard = UIStoryboard(name: "Contents", bundle: nil)
                guard let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
                    return
                }

                nextVC.receiveIndex = self.selectedIndex
                nextVC.delegate = self
                
                
                self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
            }
        default:
            ()
        }
    }
    
    
    //MARK: 서버통신 3-1
    // 새로운 알림 카운트 가져오기
    private func requestNewAlertCount(){
        let url = "/my/notice/exist"
        CustomApi.shared.getResponseData(route: .apiMobile, addUrl: url, method: .get, parameters: nil, encoding: .queryString) { result, data, statusCode in
            switch result {
            case .value:
                myLogPrint("\(url) : 정상동작")
                switch statusCode {
                case 200, 201:
                    do{
                        // data를 뿌리기 쉽게 모델타입으로 디코딩한다
                        let getDecodingData = try JSONDecoder().decode(NewAlertCount.self, from: data as! Data)
                        // 카운트가 1이상일경우 알림버튼 이미지 변경
                        let count = getDecodingData.newNoticeCount ?? 0
                        myLogPrint("알림개수 확인;\(count)")
                        
                        DispatchQueue.main.async {
                         
                            if count > 0 {
                                let alertImage = UIImage(named: "alert1")?.withRenderingMode(.alwaysOriginal)
                                self.alertButton.setImage(alertImage, for: .normal)
                            }else{
                                
                                let alertImage = UIImage(named: "alert")
                                self.alertButton.setImage(alertImage, for: .normal)
                            }
                        }
                    }catch{
                        print("@@@@ \(url) - 디코딩 하는 과정에서 에러발생:\(error.localizedDescription)")
                    }
                default:
                    myLogPrint("스테이터스 코드 확인:\(statusCode)")
                }
                
                
            case .apiError:
                myLogPrint("\(url) : api 에러 발생, code:\(data)")
                let errorCode = data as? String ?? ""
                apiErrorCode(vc: self, code: errorCode)
            case .httpError:
                myLogPrint("\(url) : 네트워크 에러 발생 : \(data)")
                toastMessageView(view: self.view, message: "네트워크 연결 상태가 좋지 않습니다.\n잠시후 다시 시도해 주세요")
            }
        }
    }
    
    //MARK: 노티피케이션 설정
    private func setNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(moveTwoTab), name: .tabbarTwo, object: nil)
        
        //알람 표시
        NotificationCenter.default.addObserver(self, selector: #selector(setAlarmNotification), name: .alarmReceived, object: nil)
        
    }
    
    @objc private func moveTwoTab(){
        myLogPrint("두번째 탭으로 이동")
        self.selectedIndex = 1
    }
    
    
    //MARK: 안읽은 메시지 동기화
    @objc func setUnreadMsgCnt() {
        
        guard let myUid = UserDefaults.standard.value(forKey: UserDefaultKey.userID.rawValue) as? Int else { return }
        
        //Remova all
        PushNotification.removeAll()
        
        //분양조회
        self.chat_db.whereField("adoptPetOwnerUserUid", isEqualTo: myUid).whereField("adoptPetOwnerLeave", isEqualTo: false).getDocuments { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
               
            } else {
                
                for document in querySnapshot!.documents {
                    
                    guard let chatRoom = ChatRoom(document: document) else { continue }
                    //print("adoptPetOwnerUserUid - \(myUid):\(chatRoom.unreadCnt_owner) - adoptPetApplicationUid:\(chatRoom.adoptPetApplicationUid)")
                    if chatRoom.unreadCnt_owner > 0 {
                     
                        //PushNotification.writeMsg(uid: chatRoom.adoptPetApplicationUid, adoptPetUid: chatRoom.adoptPetUid, adoptPetOwnerUserUid: chatRoom.adoptPetOwnerUserUid, adopteeUserUid: chatRoom.adopteeUserUid)
                        PushNotification.writeMsgCnt(uid: chatRoom.adoptPetApplicationUid, adoptPetUid: chatRoom.adoptPetUid, adoptPetOwnerUserUid: chatRoom.adoptPetOwnerUserUid, adopteeUserUid: chatRoom.adopteeUserUid, count: chatRoom.unreadCnt_owner)
                    }
                }
                
                //입양조회
                self.chat_db.whereField("adopteeUserUid", isEqualTo: myUid).whereField("activate", isEqualTo: true).getDocuments { (querySnapshot2, err2) in
                    
                    if let err = err2 {
                        
                        print("Error getting documents: \(err)")
                    } else {
                        
                        for document in querySnapshot2!.documents {
                            
                            guard let chatRoom = ChatRoom(document: document) else { continue }
                            //print("adopteeUserUid - \(myUid):\(chatRoom.unreadCnt_adoptee) - adoptPetApplicationUid:\(chatRoom.adoptPetApplicationUid)")
                            if chatRoom.unreadCnt_adoptee > 0 {
                             
                                //PushNotification.writeMsg(uid: chatRoom.adoptPetApplicationUid, adoptPetUid: chatRoom.adoptPetUid, adoptPetOwnerUserUid: chatRoom.adoptPetOwnerUserUid, adopteeUserUid: chatRoom.adopteeUserUid)
                                PushNotification.writeMsgCnt(uid: chatRoom.adoptPetApplicationUid, adoptPetUid: chatRoom.adoptPetUid, adoptPetOwnerUserUid: chatRoom.adoptPetOwnerUserUid, adopteeUserUid: chatRoom.adopteeUserUid, count: chatRoom.unreadCnt_adoptee)
                            }
                        }
                        
                        //앱 아이콘 및 탭바 배지 갱신
                        let cnt = PushNotification.loadAllCount()
                        if cnt > 0 {
                         
                            DispatchQueue.main.async {
                             
                                self.viewControllers?.last?.tabBarItem.badgeValue = "\(cnt)"
                            }
                        }else{
                            
                            DispatchQueue.main.async {
                             
                                self.viewControllers?.last?.tabBarItem.badgeValue = nil
                            }
                        }
                        DispatchQueue.main.async {
                         
                            UIApplication.shared.applicationIconBadgeNumber = cnt
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - 알람 표시
    @objc func setAlarmNotification() {
        
        let alertImage = UIImage(named: "alert1")?.withRenderingMode(.alwaysOriginal)
        self.alertButton.setImage(alertImage, for: .normal)
    }
    
}




//MARK: - 로그인 뷰컨트롤러 델리게이트
extension TabbarViewController: LoginVCProtocol {
    func tabbarIndex(index: Int) {
        myLogPrint("탭바인덱스 확인:\(index)")
        // 탭 이동
        self.selectedIndex = index
    }
}
