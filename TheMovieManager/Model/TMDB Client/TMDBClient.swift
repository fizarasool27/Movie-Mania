//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Fiza Rasool on 05/7/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "dfac9f2ea704be997c9d081abd59cd5e"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case login
        case createSessionId
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            do {
                 let decoder = JSONDecoder()
                 let responseObject =  try decoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestToken
                completionHandler(true, nil)
            }
            catch {
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    class func getRequestToken(completionHandler: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { (data, response, error) in
            guard let data = data  else {
               completionHandler(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestToken
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    class func createSessionId(completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PostSession(requestToken: Auth.requestToken)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(SessionResponse.self, from: data)
                Auth.sessionId = responseObject.sessionId
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(MovieResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
}
