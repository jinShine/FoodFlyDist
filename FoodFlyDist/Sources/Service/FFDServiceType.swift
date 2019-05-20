//
//  ServiceType.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Alamofire

protocol FFDServiceType {
    func pingCheck(completion: @escaping (_ result: Bool,_ pinger: SwiftyPing?) -> ())
    func fileUpload(fileData: Data, completion: @escaping (UploadRequest) -> ())
}
