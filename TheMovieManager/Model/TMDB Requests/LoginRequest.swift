//
//  Login.swift
//  TheMovieManager
//  Created by Fiza Rasool on 05/7/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}

