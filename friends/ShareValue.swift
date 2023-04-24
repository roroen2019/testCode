//
//  ShareValue.swift
//  friend
//
//  Created by myPuppy on 2022/11/28.
//

import UIKit

//MARK: - 로컬저장소에 등록된 키
enum UserDefaultKey: String {
    case fcmToken = "fcmToken"
    
    case headerToken = "headerToken" // api헤더토큰
    case userID = "userID"
    case snsType = "snsType"
    case nickName = "nickName"
}

//MARK: - 앱 공통변수 값
/// 앱에서 사용하는 작은 값 모음 struct
struct AppConfig {
    
    struct defaultValue {
        /// true: 서비스, false: 개발용
        static var isTest = false
        static let testURL = "http://3.39.189.51:8080"
        static let serviceURL = "https://petlinkfamily.co.kr"
        
        // 웹뷰 url
        /// 이용약관
        static var termsUrl = "/api/mobile/wp/terms-service"
        /// 개인정보 수집
        static var privacyUrl = "/api/mobile/wp/terms-private"
        /// 마케팅
        static var marketingUrl = ""
        /// 보험 브랜드 로고이미지
        static let insranceLogoImageDEV = "https://petlink-friends-dev.s3.ap-northeast-2.amazonaws.com/temp/insurance-partner-logos.png"
        static let insranceLogoImage = "https://petlink-friends-prod.s3.ap-northeast-2.amazonaws.com/temp/insurance-partner-logos.png"
        
        /// 가입화면
        static let shopRegisterUrl = "https://petlinkpartner.co.kr/auth/signin/store/"
        static let hospitalRegisterUrl = "https://petlinkpartner.co.kr/auth/signin/clinic/"
        static let shopRegisterUrlDEV = "https://dev.petlink.co.kr/auth/signin/store/"
        static let hospitalRegisterUrlDEV = "https://dev.petlink.co.kr/auth/signin/clinic/"
  
        
        static let topViewHeight:CGFloat = 50 //헤더 고정 높이
        static let leftPadding:CGFloat = 24 //좌측 패딩값
        static let imageTransitionTime:CGFloat = 0.3 //이미지 로딩 표시 간격
        
        static var statusHeight:CGFloat = 0 //상단 스테이터스 높이
        static var keyboardHeight:CGFloat = 0 //키보드 높이
        /// 서버에서 보내는 아이템 최대개수 설정값
        static let listCountLimit = 10
        /// 서버에서 보내는 이미지 사이즈
        static var serverImageSize = 0
        
        /// 좌표위도
        static var myLat:Double = 0
        /// 좌표경도
        static var myLng:Double = 0
        
        /// 회원탈퇴 동작 유무
        static var signOut = false
        
        /// dynymicLink, kakaoLink
        static var dynamicLink : String?
        
        //Message
        static var CHAT_COLLECTION = CHAT_NAME_PROD
        static let CHAT_NAME_DEV = "adoptPetChattingRooms"
        static let CHAT_NAME_PROD = "adoptPetChattingRooms_prod"
        static let MSG_COLLECTION = "threads"
        static let MSG_INFO = "새로운 알람이 도착하였습니다."
        static let MSG_INPUT = "새로운 메세지가 도착하였습니다."
        
        /// 내 주변에서 어떤 탭을 선택했는지 확인하기
        static var tabName = "pet"
        
    }
    
}




//MARK: - 앱 공통
/// 앱에서 사용하는 값 모음 class
public class AppCommonValue {
    static let shared = AppCommonValue()
    
    let placeholderImage = UIImage(named: "icoPlaceholderImage")
    let petPlaceholderImage = UIImage(named: "icoPlaceholderImage1") //동물
    let shopPlaceholderImage = UIImage(named: "icoPlaceholderImage2") //매장
    let hospitalPlaceholderImage = UIImage(named: "icoPlaceholderImage3") //병원
}





//MARK: - 앱 색상
public class AppCustomColor {
    static let shared = AppCustomColor()
    
    //MARK: white
    /// 249, 248, 253
    let white249248253 = UIColor(displayP3Red: 249/255, green: 248/255, blue: 253/255, alpha: 1)
    /// 246, 248, 251
    let white246248251 = UIColor(displayP3Red: 246/255, green: 248/255, blue: 251/255, alpha: 1)
    /// 250,
    let white250 = UIColor(displayP3Red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    //MARK: bottomLineColor
    /// 223, 223, 223
    let bottomLineColor = UIColor(displayP3Red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
    
    //MARK: black
    /// 25, 25, 25
    let black25 = UIColor(displayP3Red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    /// 34, 34, 34
    let black34 = UIColor(displayP3Red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
    /// 33, 37, 41
    let black333741 = UIColor(displayP3Red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
    /// 48, 47, 58
    let black484758 = UIColor(displayP3Red: 48/255, green: 47/255, blue: 58/255, alpha: 1)
    
    //MARK: green
    /// 36, 200, 91
    let green3620091 = UIColor(displayP3Red: 36/255, green: 200/255, blue: 91/255, alpha: 1)
    /// 211, 244, 222
    let green211244222 = UIColor(displayP3Red: 211/255, green: 244/255, blue: 222/255, alpha: 1)
    /// 221 255 187
    let green221255187 = UIColor(displayP3Red: 221/255, green: 255/255, blue: 187/255, alpha: 1)
    
    //MARK: gray
    /// 88, 88, 88
    let gray88 = UIColor(displayP3Red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
    /// #9E9E9E 102, 102, 102
    let gray102 = UIColor(displayP3Red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    /// 112, 112, 112
    let gray112 = UIColor(displayP3Red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    /// 128, 128, 128
    let gray128 = UIColor(displayP3Red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    /// 151, 151, 151
    let gray151 = UIColor(displayP3Red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
    /// 131, 131, 131
    let gray131 = UIColor(displayP3Red: 131/255, green: 131/255, blue: 131/255, alpha: 1)
    /// #9E9E9E 158, 158, 158
    let gray158 = UIColor(displayP3Red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
    /// 163, 174, 190
    let gray163174190 = UIColor(displayP3Red: 163/255, green: 174/255, blue: 190/255, alpha: 1)
    /// #AEAEAE 174, 174, 174
    let gray174 = UIColor(displayP3Red: 174/255, green: 174/255, blue: 174/255, alpha: 1)
    /// 205, 213, 223
    let gray205213223 = UIColor(displayP3Red: 205/255, green: 213/255, blue: 223/255, alpha: 1)
    /// 223, 223, 223
    let gray223 = UIColor(displayP3Red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
    /// 231, 231, 231
    let gray231 = UIColor(displayP3Red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
    /// 245, 245, 245
    let gray245 = UIColor(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    
    //MARK: blue
    /// #0389FF 3, 137, 255
    let blue3137255 = UIColor(displayP3Red: 3/255, green: 137/255, blue: 255/255, alpha: 1)
    /// 64, 9, 175
    let blue649175 = UIColor(displayP3Red: 64/255, green: 9/255, blue: 175/255, alpha: 1)
    ///  228, 242, 255
    let blue228242255 = UIColor(displayP3Red: 228/255, green: 242/255, blue: 255/255, alpha: 1)
    
    //MARK: orange
    /// #FB4D00 251, 77, 0
    let orange251770 = UIColor(displayP3Red: 251/255, green: 77/255, blue: 0/255, alpha: 1)
    
    //MARK: purple
    /// #723CED 114, 60, 237
    let purple11460237 = UIColor(displayP3Red: 114/255, green: 60/255, blue: 237/255, alpha: 1)
    /// 120, 111, 220
    let purple120111220 = UIColor(displayP3Red: 120/255, green: 111/255, blue: 220/255, alpha: 1)
    /// 121, 64, 240
    let purple12164240 = UIColor(displayP3Red: 121/255, green: 64/255, blue: 240/255, alpha: 1)
    /// 122, 72, 237
    let purple12272237 = UIColor(displayP3Red: 122/255, green: 72/255, blue: 237/255, alpha: 1)
    /// #9954FF 153, 84, 255
    let purple15384255 = UIColor(displayP3Red: 153/255, green: 84/255, blue: 255/255, alpha: 1)
    /// #B395F6 179, 149, 246
    let purple179149246 = UIColor(displayP3Red: 179/255, green: 149/255, blue: 246/255, alpha: 1)
    /// 227, 216, 252
    let purple227216252 = UIColor(displayP3Red: 227/255, green: 216/255, blue: 252/255, alpha: 1)
    /// 237, 233, 252
    let purple237233252 = UIColor(displayP3Red: 237/255, green: 233/255, blue: 252/255, alpha: 1)
}




//MARK: - enum 모음
enum Kind {
    case pet
    case shop
    case clinic
}

enum petSpecies: String {
    case dog = "DOG"
    case cat = "CAT"
}


