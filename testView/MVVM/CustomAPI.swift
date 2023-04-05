//
//  CustomAPI.swift
//  testView
//
//  Created by myPuppy on 2023/03/17.
//
/*
 서버통신하고 결과값을 내보낸다.
 */
import Foundation

class CustomAPI {
    
    func fetchNow(onCompleted:@escaping (ServerModel) ->Void){
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
            guard let data = data else { return }
            guard let model = try? JSONDecoder().decode(ServerModel.self, from: data) else { return }
            
            onCompleted(model)
            
        }.resume()
    }
    
    
}
