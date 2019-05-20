//
//  API.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation
import Alamofire


enum API {
    case pingCheck
    case fileUpload(Data)
}

extension API : TargetType {

    var baseURL: URL {
        #if DEBUG
        return URL(string: "http://45.76.220.229:8888")!
        #else
        #endif
    }

    var path: String {
        switch self {
        case .pingCheck:
            return ""
        case .fileUpload:
            return "/api/v1/appfile/upload"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .pingCheck:
            return .get
        case .fileUpload:
            return .post
        }
        
        
    }
    
    public var parameter: Parameters {
        switch self {
        case .pingCheck, .fileUpload:
            return [:]
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .pingCheck, .fileUpload:
            return ["Content-Type" : "application/x-www-form-urlencoded"]
        }
    }

}

extension API: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .pingCheck, .fileUpload:
            let url = self.baseURL.appendingPathComponent(self.path)
            var urlRequest = try URLRequest(url: url, method: self.method, headers: self.header)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameter)
            print("Router .\(self) URL : ", urlRequest)
            return urlRequest
        }
    }
}
