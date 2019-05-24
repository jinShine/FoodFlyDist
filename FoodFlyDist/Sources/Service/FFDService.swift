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
        let removePort = API.pingCheck.baseURL.absoluteString.components(separatedBy: ":")[1]
        let host = removePort.components(separatedBy: "//")[1]
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
    
    func fileUpload(flatform: String,
                    registrant: String,
                    version: String,
                    uploadServer: String,
                    appType: String,
                    revisionHistory: String,
                    fileData: Data,
                    completion: @escaping (UploadRequest) -> ()) {
        
        let api = API.fileUpload

        Alamofire.upload(multipartFormData: { multipartform in
            multipartform.append(flatform.data(using: .utf8)!, withName: "flatform_type")
            multipartform.append(version.data(using: .utf8)!, withName: "version")
            multipartform.append(revisionHistory.data(using: .utf8)!, withName: "revision_history")
            multipartform.append(registrant.data(using: .utf8)!, withName: "registrant")
            multipartform.append(appType.data(using: .utf8)!, withName: "app_type")
            multipartform.append(uploadServer.data(using: .utf8)!, withName: "app_environment")
            multipartform.append(fileData, withName: "appfile", fileName: "rider.ipa", mimeType: "application/octet-stream")
        }, with: api.urlRequest!) { result in
            switch result {
            case .success(request: let upload, _, _):
                upload.responseString(completionHandler: { response in
                    print("RESPONSE JSON", response)
                })
                completion(upload)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func revisionHistory(flatform: String, completion: @escaping ([HistoryModel]) -> ()) {
        Alamofire.request(API.revisionHistory(flatform).urlRequest!)
            .validate(statusCode: 200..<400)
            .responseData { response in
                switch response.result {
                case .success(let value):
                    do {
                        let result = try JSONDecoder().decode([HistoryModel].self, from: value)
                        print(result)
                        completion(result)
                    } catch {
                        print("revisionHistory Decoder Error")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
