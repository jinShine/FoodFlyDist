//
//  FFDService.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation
import Alamofire

class FFDService: Alamofire.SessionManager {
    private static let manager: FFDService = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        return FFDService(configuration: configuration)
    }()
}

extension FFDService: FFDServiceType {
    func pingCheck(completion: @escaping (_ result: Bool,_ pinger: SwiftyPing?) -> ()) {
        let host = API.pingCheck.baseURL.absoluteString.components(separatedBy: ":")[1]
        print("HOST", host)
        let pinger = SwiftyPing(host: host,
                                configuration: PingConfiguration(interval: 0.5, with: 5),
                                queue: DispatchQueue.global())
        if pinger == nil {
            completion(false, nil)
        } else {
            completion(true, pinger)
        }
    }
    
    func fileUpload(fileData: Data, completion: @escaping (UploadRequest) -> ()) {
        let api = API.fileUpload(fileData)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in api.parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
//            multipartFormData.append(fileData, withName: "appfile", mimeType: "application/octet-stream")
        }, with: api.urlRequest!) { (result) in
            switch result {
            case .success(request: let upload,_,_):
                completion(upload)
            case .failure(let error):
                print(error)
            }
        }
      
    }
    
}
