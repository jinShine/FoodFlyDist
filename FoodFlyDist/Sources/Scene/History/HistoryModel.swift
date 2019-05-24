//
//  HistoryModel.swift
//  FoodFlyDist
//
//  Created by 승진김 on 24/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

//{
//    "id": 35,
//    "flatform_type": "ios",
//    "version": "1.0.0",
//    "file_path": "uploads/evQG3ET-1558517739599.png",
//    "revision_history": "revision history area",
//    "app_type": "auto",
//    "app_environment": "development",
//    "registrant": "admin",
//    "created_at": "2019-05-22T09:35:39.000Z",
//    "updated_at": "2019-05-22T09:35:39.000Z"
//},

struct HistoryModel: Decodable {
    var version: String
    var revisionHistory: String
    var appType: String
    var environment: String
    var registrant: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case version, registrant
        case revisionHistory = "revision_history"
        case appType = "app_type"
        case environment = "app_environment"
        case updatedAt = "updated_at"
    }
}



