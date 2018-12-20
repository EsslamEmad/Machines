//
//  Equipment.swift
//  Machines
//
//  Created by Esslam Emad on 24/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Equipment: Codable{
    var id: Int!
    var price: Double!
    var title: String!
    var content: String!
    var workingHours: Double!
    var state: String!
    var capacity: Double!
    var speed: Double!
    var weight: Double!
    var autoLift: Int!
    var remoteControl: Int!
    var overWeight: Int!
    var bearWeight: Int!
    var speedDesc: Int!
    var buyOrRent: Int!
    var photos: [String]!
    var categoryID: Int!
    
    enum CodingKeys: String, CodingKey {
        case id
        case price
        case title
        case content
        case workingHours = "hours_work"
        case state = "gener_state"
        case capacity = "lift_capac"
        case speed
        case weight
        case autoLift = "raise_to"
        case remoteControl = "remote_control"
        case overWeight = "over_weight"
        case bearWeight = "bear_weight"
        case speedDesc = "speed_desc"
        case buyOrRent = "buy_rent"
        case photos
        case categoryID = "rent_cat"
    }
}
