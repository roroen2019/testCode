//
//  ApiCaller.swift
//  testView
//
//  Created by myPuppy on 2023/05/02.
//

import Foundation
import Combine

class APICaller {
    static let shared = APICaller()
    // feture타입의 퍼블리셔를 리턴
    func fetchCompanies() -> Future<[String], Error>{
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promixe(.success(["Apple", "Google", "Microsoft", "Facebook"]))
            }
        }
    }
    
}
