//
//  MessageResponse.swift
//  Machines
//
//  Created by Esslam Emad on 24/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct MessageResponse: Codable {
    var message: String!
    
    enum CodingKeys: String, CodingKey{
        case message
    }
}
