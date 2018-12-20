//
//  RentForm.swift
//  Machines
//
//  Created by Esslam Emad on 15/12/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct RentForm: Codable {
    var userID: Int!
    var equipID: Int!
    var weightID: Int!
    var periodID: Int!
    var tour: Int!
    var from: String!
    var to: String!
    var details: String!
    var companyName: String!
    var location: String!
    var phone: String!
    var email: String!
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case equipID = "equip_id"
        case weightID = "weight_id"
        case periodID = "time_id"
        case tour
        case from = "order_from"
        case to = "order_to"
        case details = "order_details"
        case companyName = "company_name"
        case location
        case phone
        case email
    }
}
