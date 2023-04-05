//
//  SeverModel.swift
//  testView
//
//  Created by myPuppy on 2023/03/17.
//
/*
 서버에서 주는 데이터를 모델화.
 */
import Foundation

struct ServerModel: Codable {
    let currentDateTime:String?
}
