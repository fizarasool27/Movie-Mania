//
//  RequestTokenResponse.swift
//  TheMovieManager
//
//  Created by Fiza Rasool on 05/7/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import Foundation

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
