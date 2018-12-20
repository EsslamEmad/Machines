//
//  Page.swift
//  Machines
//
//  Created by Esslam Emad on 24/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Page: Codable{
    var id: Int!
    var title: String!
    var content: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case content
    }
}
