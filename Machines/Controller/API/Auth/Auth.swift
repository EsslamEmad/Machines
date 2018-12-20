//
//  Auth.swift
//  Machines
//
//  Created by Esslam Emad on 24/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

import Foundation
import DefaultsKit
import PromiseKit


class Auth {
    
    static let auth = Auth()
    
    var isLanguageSet: Bool?{
        get {
            return Defaults().get(for: Key<Bool>("langSet")) ?? false
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<Bool>("langSet"))
                
            }     }
    }
    var language: String?{
        get {
            return Defaults().get(for: Key<String>("Language"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<String>("Language"))
            }
        }
    }
    
    
    var user: User? {
        get {
            return Defaults().get(for: Key<User>("user"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<User>("user"))
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var categories: [Category]? {
        get {
            return Defaults().get(for: Key<[Category]>("categories"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<[Category]>("categories"))
            } else {
                UserDefaults.standard.set(nil, forKey: "categories")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
   
     var fcmToken: String! {
     get{
     return Defaults().get(for: Key<String>("Token"))
     }
     set {
     if let value = newValue {
     Defaults().set(value, for: Key<String>("Token"))
     }
     }
     }
    
    private init() {
    }
    
    
    func updateToken(){
     if user != nil {
     if user!.token != fcmToken{
     user!.token = fcmToken
     firstly{
     return API.CallApi(APIRequests.updateToken(token: fcmToken))
     } .done {
     self.user = try! JSONDecoder().decode(User.self, from: $0)
     print("Token updated")
     }.catch { error in
     print("Unable to update token")
     }
     }
     }
     }
     
    func getCategories() {
        firstly{
            return API.CallApi(APIRequests.getCategories)
            }.done {
                self.categories = try! JSONDecoder().decode([Category].self, from: $0)
            }.catch { error in
                
        }
    }
    
}

