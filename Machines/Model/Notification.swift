//
//  Notification.swift
//  Machines
//
//  Created by Esslam Emad on 3/11/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct APINotification: Codable {
    var notification: String!
    
    enum CodingKeys: String, CodingKey {
        case notification
    }
}
