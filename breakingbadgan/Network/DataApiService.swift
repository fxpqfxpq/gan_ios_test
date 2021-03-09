//
//  DataApiService.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 16.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation
import Moya

enum DataApiService {
    case getCharacters(charactersRequest: ServerRequest<CharactersRequest>)
}

extension DataApiService: TargetType {
    
    var parameters: [String: Any]? {
        let parameters = [String: Any]()
        
        return parameters
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data(capacity:0)
    }
    
    var task: Task {
        switch self {
        case .getCharacters(let charactersRequest):
            return getTaskFor(request: charactersRequest)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Content-type": "application/json",
                "Accept-Encoding": "gzip"]
        }
    }
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: Consts.baseUrl)!
        }
    }
   
    var path: String {
        switch self {
        case .getCharacters(_):
            return "characters"
        }
    }
    
    var validationType: ValidationType {
        switch self {
        case .getCharacters(_):
            return .successAndRedirectCodes
        }
    }
    
    private func getTaskFor<T>(request: ServerRequest<T>) -> Task {
        let encoder = JSONEncoder()
        
        switch self {
        case .getCharacters(_):
            return Task.requestPlain
        default:
            do {
                let encoded = try encoder.encode(request)
                return Task.requestData(encoded)
            } catch {
                return Task.requestParameters(parameters: parameters!, encoding: URLEncoding.default)
            }
        }
    }
}
