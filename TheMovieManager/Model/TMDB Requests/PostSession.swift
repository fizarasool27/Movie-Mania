//
//  PostSession.swift
//  TheMovieManager
//
//  Created by Fiza Rasool on 05/7/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}


