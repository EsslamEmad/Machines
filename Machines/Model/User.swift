//
//  User.swift
//  Machines
//
//  Created by Esslam Emad on 24/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int!
    var name: String!
    var email: String!
    var phone: String!
    var password: String!
    var photo: String!
    var token: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case email
        case phone
        case password
        case photo
        case token
        
    }
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
