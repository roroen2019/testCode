//
//  OneAPI.swift
//  testView
//
//  Created by myPuppy on 2023/04/11.
//
/*
 OneViewController에서 사용하는 api 모음
 */
import Foundation
import Alamofire


class OneAPI {
    
    // 데이터 요청
    func fetchData(completion:@escaping(MainHomeData?)->Void){
        let url = "http://3.39.189.51:8080/api/mobile/screen/home"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil).response { response in
            // 헤더 확인
            let header = response.response
//                myLogPrint("리퀘스트 확인:\(response.request)")
            let statusCode = header?.statusCode ?? 0
            
            switch response.result {
            case .success(let data):
                do{
                    // data를 뿌리기 쉽게 모델타입으로 디코딩한다
                    let getDecodingData = try JSONDecoder().decode(MainHomeData.self, from: data!)

                    completion(getDecodingData)
                    

                }catch{
                    print("디코딩 에러")
                    
                }
                
                break
            case .failure(_):
                completion(nil)
                break
            }
        }
    }
}
