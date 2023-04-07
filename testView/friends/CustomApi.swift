//
//  APIrequest.swift
//  friend
//
//  Created by myPuppy on 2022/11/28.
//

import Foundation
import Alamofire

enum apiRoute : String{
    case apiMobile = "/api/mobile"
    case auth = "/api/mobile/auth"
    case wp = "/wp"
    case wpAuth = "/wp/auth"
    case apiApp = "/api/app"
}


enum MethodType {
    case get
    case post
    case put //수정
    case delete
    case patch //부분적인 수정
    case upload
    case download
    
}

enum selectEncoding {
    case queryString
    /// 파라미터에 배열이 있을경우 사용
    case noBrackets
    case httpBody
    case jsonString
}

enum resultType{
    case value //통신성공, 결과값이 리턴되었을경우
    /// - Parameters:
    ///   - a: 유효하지 않은 JWT AccessToken. (액세스 토큰으로 반환한 키가 근본적으로 잘못되었음 = 정상 로직상 일어날 일 없음)
    ///   - b: 만료된 JWT RefreshToken.
    ///   - c: 존재하지 않는 유저 (API 요청시 JWT 토큰을 전달한 경우, 해당 토큰의 주인이 누군지를 파악하려고 DB 정보를 가져왔지만 그 시점, 다른 곳에서 회원 탈퇴를 해서 null 이 반환될 때)
    case apiError //서버쪽 api에러
    case httpError //통신코드가 비정상적일경우 출력
}



final class CustomApi {
    static let shared = CustomApi()
    
    private var baseUrl: String {
        switch AppConfig.defaultValue.isTest {
        case true:
            return AppConfig.defaultValue.serviceURL
        case false:
            return AppConfig.defaultValue.testURL
        }
    }
    
    
    /// AlamoFire 통신 라이브러리를 이용한 메소드, `프렌즈 서버 연동 api`.
    /// - Parameters:
    ///   - addUrl:        url의 `엔드포인트 url`를 입력.
    ///   - method:        통신 방식 설정(get, post, put, delete 등).
    ///   - parameters:    서버에 보낼 값을 `키`, `밸류` 형태로 넣는다.
    ///   - encoding:      인코딩 방식을 설정 기본 인코딩방식은 jsonstring으로 설정.
    ///   - completion:    통신 결과값을 리턴한다.
    func getResponseData(route: apiRoute, addUrl:String, method:MethodType, parameters: [String:Any]?, encoding:selectEncoding = .jsonString, data: [DataModel]? = nil, completion: @escaping (resultType, Any, Int) -> Void){
        
        // url 설정
        let url = baseUrl + route.rawValue + addUrl
        // 헤더 설정
        let accessToken = UserDefaults.standard.string(forKey: UserDefaultKey.headerToken.rawValue) ?? ""
//        myLogPrint("url:\(addUrl) -- header: \(accessToken)")
        
        var token = ""
        var headers : HTTPHeaders?
        if accessToken != "" {
            token = "Bearer " + accessToken
            headers = ["Authorization" : token]
        }else{
            
        }
        
//        myLogPrint("헤더 토큰:\(headers)")
//        let headers: HTTPHeaders = [
//            "Authorization" : token
//        ]
        
        // 인코딩 타입 설정
        var encodingType: ParameterEncoding!
        
        switch encoding{
        case .queryString:
            encodingType = URLEncoding(destination: .queryString)
        case .httpBody:
            encodingType = URLEncoding.httpBody
        case .jsonString:
            encodingType = JSONEncoding.default
        case .noBrackets:
            encodingType = URLEncoding(arrayEncoding: .noBrackets)
        }
        
        
//        myLogPrint("전체 url확인:\(url)")
        switch method {
        case .get: //MARK: - get
            
            AF.request(url, method: .get, parameters: parameters, encoding: encodingType, headers: headers).response { response in
                // 헤더 확인
                let header = response.response
//                myLogPrint("리퀘스트 확인:\(response.request)")
                let statusCode = header?.statusCode ?? 0
                self.statusCodeInfo(code: statusCode, url: url)
                switch response.result {
                case .success(let data):
                    if self.checkHeaderValue(value: header!) {
                        // api-error-code가 없을때 동작
                        completion(.value, data as Any, statusCode)
                    }else{
                        let errorCode = self.checkApiErrorCode(value: header!)
                        completion(.apiError, errorCode, statusCode)
                    }
                    
                    break
                case .failure(let error):
                    completion(.httpError, error, statusCode)
                    break
                }
            }
            
        case .post: //MARK: - post
            
            AF.request(url, method: .post, parameters: parameters, encoding: encodingType, headers: headers).response { response in
                // 헤더 확인
                let header = response.response
//                myLogPrint("리스폰스:\(header)")
                let statusCode = header?.statusCode ?? 0
                self.statusCodeInfo(code: statusCode, url: url)
                switch response.result {
                case .success(let data):
                    if self.checkHeaderValue(value: header!) {
                        // api-error-code가 없을때 동작
                        completion(.value, data as Any, statusCode)
                    }else{
                        let errorCode = self.checkApiErrorCode(value: header!)
                        completion(.apiError, errorCode, statusCode)
                    }
                    
                    break
                case .failure(let error):
                    completion(.httpError, error, statusCode)
                    break
                }
            }
            
            
            
        case .put: //MARK: - put
            AF.request(url, method: .put, parameters: parameters, encoding: encodingType, headers: headers).response { response in
                // 헤더 확인
                let header = response.response
                
                let statusCode = header?.statusCode ?? 0
                self.statusCodeInfo(code: statusCode, url: url)
                switch response.result {
                case .success(let data):
                    if self.checkHeaderValue(value: header!) {
                        // api-error-code가 없을때 동작
                        completion(.value, data as Any, statusCode)
                    }else{
                        let errorCode = self.checkApiErrorCode(value: header!)
                        completion(.apiError, errorCode, statusCode)
                    }
                    
                    break
                case .failure(let error):
                    completion(.httpError, error, statusCode)
                    break
                }
            }
            
            
            
        case .delete: //MARK: - delete
            AF.request(url, method: .delete, parameters: parameters, encoding: encodingType, headers: headers).response { response in
                // 헤더 확인
                let header = response.response
                
                let statusCode = header?.statusCode ?? 0
                self.statusCodeInfo(code: statusCode, url: url)
                switch response.result {
                case .success(let data):
                    if self.checkHeaderValue(value: header!) {
                        // api-error-code가 없을때 동작
                        completion(.value, data as Any, statusCode)
                    }else{
                        let errorCode = self.checkApiErrorCode(value: header!)
                        completion(.apiError, errorCode, statusCode)
                    }
                    
                    break
                case .failure(let error):
                    completion(.httpError, error, statusCode)
                    break
                }
            }
            
        case .patch: //MARK: - patch
            AF.request(url, method: .patch, parameters: parameters, encoding: encodingType, headers: headers).response { response in
                // 헤더 확인
                let header = response.response
//                myLogPrint("리퀘스트:\(response.request)")
                let statusCode = header?.statusCode ?? 0
                self.statusCodeInfo(code: statusCode, url: url)
                switch response.result {
                case .success(let data):
                    if self.checkHeaderValue(value: header!) {
                        // api-error-code가 없을때 동작
                        completion(.value, data as Any, statusCode)
                    }else{
                        let errorCode = self.checkApiErrorCode(value: header!)
                        completion(.apiError, errorCode, statusCode)
                    }
                    
                    break
                case .failure(let error):
                    completion(.httpError, error, statusCode)
                    break
                }
            }
            
        case .upload: //MARK: - upload
            
            // 데이터 있는지 확인
            guard var uploadData = data else { return }
            
            // 서버 이미지 용량 최대치(기본이 2mb)
            // 1mb = 1 * 1000000
            let serverSize = AppConfig.defaultValue.serverImageSize * 1000000
            let size = serverSize == 0 ? (2 * 1000000) : serverSize
            let countSize = size / uploadData.count
            // 이미지 한개당 사이즈 설정하기
            let limitSize = countSize
            myLogPrint("이미지 개별 사이즈:\(limitSize)")
            // 데이터의 타입을 확인한다 (file, image)
            //let type = uploadData[0].dataName
            
            // 이미지 배열 개수만큼 반복문 돌려서 품질 변경하기
            for i in 0..<uploadData.count{
                // 이미지의 품질변경(지금은 원본 그대로)
                let convertImage = uploadData[i].data as! UIImage //data를 이미지로 변경
                
                guard let imageData = convertImage.jpegData(compressionQuality: 1) else { //품질변경범위 0~1
                    print("@@@@ Could not get JPEG representation of UIImage")
                    return
                }
                
//                    print("데이터 크기 확인: \(imageData.count)")
                // 이미지 데이터 사이즈가 6mb가 넘어갈경우 한번 줄인다
                if imageData.count >= limitSize{
                    guard let imageData2 = convertImage.jpegData(compressionQuality: 0.99) else { //품질변경범위 0~1
                        print("@@@@ 두번째 이미지 데이터 품질 변경 안됨")
                        return
                    }
                    
                    // 만약 사이즈를 줄였는데 6mb가 넘어가면 더 줄인다
                    if imageData2.count >= limitSize{
                        guard let imageData3 = convertImage.jpegData(compressionQuality: 0.5) else { //품질변경범위 0~1
                            print("@@@@ 세번째 이미지 데이터 품질 변경 안됨")
                            return
                        }
                        
                        // 3번째 줄인 데이터를 넣는다
                        uploadData[i].data = imageData3
                    }else{
                        // 2번째 줄인 데이터를 넣는다
                        uploadData[i].data = imageData2
                    }
                    
                }else{
                    // 기존 배열안의 값을 변경한다
                    uploadData[i].data = imageData
                }
            }
            
            
            
            AF.upload(multipartFormData: { multipartFormData in
                
                // 파라미터 값이 있는지 확인하기, 값이 있으면 추가.
                if parameters != nil{
                    // 문자열 데이터 추가
                    for (key, value) in parameters! {
                        if let stringValue = value as? String,
                           let data = stringValue.data(using: .utf8) {
//                            let test = String(decoding: data, as: UTF8.self)
//                            myLogPrint("String - key:\(key), value:\(test)")
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                    // 정수형 데이터 추가
                    for (key, value) in parameters! {
                        if let intValue = value as? Int {
                            let data = Data("\(intValue)".utf8)
                            myLogPrint("int - key:\(key), value:\(intValue)")
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                }
                
                for i in uploadData{
                    // withName:key값이다
                    // any타입을 데이터 타입으로 변환
                    let image = i.data as! Data
                    multipartFormData.append(image, withName: i.dataKey, fileName: "\(i.dataName).jpg", mimeType: "image/jpeg")
                }
                
            }, to: url, headers: headers)
            .response { response in
                // 헤더 확인
                let header = response.response
//                myLogPrint("업로드 헤더 확인:\(header)")
                let statusCode = header?.statusCode ?? 0
                self.statusCodeInfo(code: statusCode, url: url)
                switch response.result {
                case .success(let data):
                    if self.checkHeaderValue(value: header!) {
                        // api-error-code가 없을때 동작
                        completion(.value, data as Any, statusCode)
                    }else{
                        let errorCode = self.checkApiErrorCode(value: header!)
                        completion(.apiError, errorCode, statusCode)
                    }
                    
                    break
                case .failure(let error):
                    completion(.httpError, error, statusCode)
                    break
                }
            }
        case .download: //MARK: - download
            
            let fileName = parameters?["name"] as! String
            
            let destination: DownloadRequest.Destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] //경로
                let fileUrl = documentsURL.appendingPathComponent("\(fileName)") //파일
                
                // .removePreviousFile - 지정된 경우 대상 URL에서 이전 파일을 제거합니다.
                // .createIntermediateDirectories - 지정된 경우 대상 URL에 대한 중간 디렉터리를 만듭니다.
                return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            // 입력된 url을 사용한다.
            // 루트까지 포함된 url사용 안함
            myLogPrint("다운로드 url 확인:\(addUrl)")
            AF.download(addUrl, encoding: URLEncoding.default, headers: nil, to: destination)
                .downloadProgress { progress in
                    print("@@@@ Download Progress: \(progress.fractionCompleted)")
                }.response { response in
                    debugPrint(response)
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    if response.error == nil, let filePath = response.fileURL?.path {
                        completion(.value, filePath, statusCode)
                    }else{
                        completion(.httpError, "다운로드 실패", statusCode)
                    }
            }
        }
    }
    
    
    
    
    
    //MARK: - 헤더값 추출하기
    /// true: 정상, False: 비정상
    private func checkHeaderValue(value:Any) -> Bool{
        myLogPrint("헤더값 추출하기 메소드 동작")
        
        // 헤더값 추출하기
        if let responseHeader = value as? HTTPURLResponse {
            myLogPrint("헤더 리스폰스 확인")
            // 헤더의 Authorization 저장
            if let accessToken = responseHeader.allHeaderFields["Authorization"] as? String {
//                myLogPrint("Authorization 확인:\(accessToken)")
                // accessToken 저장
                UserDefaults.standard.set(accessToken, forKey: UserDefaultKey.headerToken.rawValue)
                
             }
            
            // 헤더의 api-error-code값 확인
            if let errorCode = responseHeader.allHeaderFields["api-error-code"] as? String {
                myLogPrint("api-error-code 확인하기:\(errorCode)")
                return false
            }
        }
        
        return true
    }

    //MARK: 에러코드 추출하기
    private func checkApiErrorCode(value:Any) -> String{
        // 헤더값 추출하기
        if let responseHeader = value as? HTTPURLResponse {
            myLogPrint("헤더 리스폰스 확인")
            
            // 헤더의 api-error-code값 확인
            if let errorCode = responseHeader.allHeaderFields["api-error-code"] as? String {
                myLogPrint("🤬 api-error-code 확인하기:\(errorCode)")
                return errorCode
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    
    
    //MARK: - 도로명 주소 api
    /// 도로명 주소 요청형 메소드
    ///  - Parameters:
    ///   - page:     데이터 페이징 너버
    ///   - address:  실제 주소지
    func getAddressAPI(page:Int, address:String, completion: @escaping (resultType, Any, Int) -> Void){
        
        let confirmKey = "주소API" //주소제공 검색 API
        
        var parameters = Dictionary<String,Any>()
        parameters["confmKey"] = confirmKey
        parameters["currentPage"] = page
        parameters["countPerPage"] = 10
        parameters["keyword"] = address
        parameters["resultType"] = "json"
        
        
        let url = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString).response
        { response in
            
            let statusCode = response.response?.statusCode ?? 0
            
            switch response.result {
            case .success(let data):
                completion(.value, data as Any, statusCode)
                break
            case .failure(let error):
                completion(.httpError, error, statusCode)
                break
            }
        }
    }
    
    
    //MARK: 스테이터스 코드 설명 확인하기
    private func statusCodeInfo(code:Int, url:String){

        switch code {
        case 200:
            myLogPrint("\(url) : 200 - 요청이 성공했습니다. [성공]의 결과 의미는 HTTP 메서드에 따라 다릅니다.")
        case 201:
            myLogPrint("\(url) : 201 - 요청이 성공했고 결과적으로 새 리소스가 생성되었습니다. 이것은 일반적으로 POST요청 또는 일부 PUT요청 후에 전송되는 응답입니다.")
        case 400:
            myLogPrint("\(url) : 400 - 서버는 클라이언트 오류로 인식되는 것으로 인해 요청을 처리할 수 없거나 처리하지 않을 것입니다(예: 잘못된 요청 구문, 잘못된 요청 메시지 프레이밍 또는 사기성 요청 라우팅).")
        case 401:
            myLogPrint("\(url) : 401 - HTTP 표준은 [인증되지 않음]을 지정하지만 의미상 이 응답은 [인증되지 않음]을 의미합니다. 즉, 클라이언트는 요청된 응답을 얻기 위해 자신을 인증해야 합니다.")
        default:
            myLogPrint("\(url) : \(code) - 잘 안오는 코드가 왔음")
        }
    }

    
    
}
