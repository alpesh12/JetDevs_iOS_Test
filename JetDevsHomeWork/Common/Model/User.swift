//
//  User.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 11/01/24.
//

import Foundation
import Alamofire

struct UserDataResponse: Codable {
    
    let result: Int
    let errorMessage: String
    let data: UserDataContainer
    
    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
        case data
    }
}

struct UserDataContainer: Codable {
    
    let user: User
}

struct User: Codable {
    
    let userId: Int
    let userName: String
    let userProfileURL: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userProfileURL = "user_profile_url"
        case createdAt = "created_at"
    }
}
