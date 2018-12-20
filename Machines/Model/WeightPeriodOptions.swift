//
//  WeightPeriodOptions.swift
//  Machines
//
//  Created by Esslam Emad on 15/12/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct WightPeriodOptions: Codable {
    var weightID: Int!
    var weightName: String!
    var periods: [Period]!
    
    enum CodingKeys: String, CodingKey{
        case weightID = "weight_id"
        case weightName = "weight_name"
        case periods = "times"
    }
}
