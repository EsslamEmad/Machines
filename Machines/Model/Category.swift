//
//  getCategory.swift
//  Machines
//
//  Created by Esslam Emad on 12/11/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Category: Codable {
    var id: Int!
    var name: String!
    var formType: Int!
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case formType = "form_type"
    }
}

