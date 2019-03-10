//
//  APIRequests.swift
//  Machines
//
//  Created by Esslam Emad on 24/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation
import Moya

enum APIRequests {
    
    
    case login(email: String, password: String)
    case editUser(variables: User)
    case register(user: User)
    case forgotPassword(email: String)
    case updateToken(token: String)
    case contactUs(name: String, email: String, message: String)
    case getPages
    case getPage(id: Int)
    case upload(image: UIImage?, file: URL?)
    case addOrder(equipID: Int, company: String, email: String, phone: String, name: String)
    case addToWishlist(equipID: Int)
    case getWishlist
    case removeFromWishlist(equipID: Int!)
    case getEquips
    case getEquip(id: Int!)
    case getBuyEquips
    case getRentEquips
    case search(search: String)
    case getUserBuys
    case getUserRents
    case getNotifications
    case getCategories
    case getEquipsByCategory(id: Int)
    case getRentOptions(categoryID: Int)
    case rentEquip(rentForm: RentForm)
    
}


extension APIRequests: TargetType{
    var baseURL: URL{
        switch Auth.auth.language{
        case "en":
            return URL(string: "https://www.arabicmachinery.net/en/mobile")!
        default:
            return URL(string: "https://www.arabicmachinery.net/ar/mobile")!
        }
        
    }
    var path: String{
        switch self{
        case .register:
            return "register"
        case .login:
            return "login"
        case .editUser:
            return "editUser"
        case .forgotPassword:
            return "forgotPassword"
        case .updateToken:
            return "updateToken"
            
        case .contactUs:
            return "contactUs"
        case .getPages:
            return "pages"
        case .getPage(id: let id):
            return "pages/\(id)"
        case .upload:
            return "upload"
        case .addOrder:
            return "addOrder"
        case .addToWishlist:
            return "addToWhishlist"
        case .removeFromWishlist(equipID: let id):
            return "removeWishlist/\(String(id!))/\(String(Auth.auth.user!.id))"
        case .getWishlist:
            return "getWhishlist/\(String(Auth.auth.user!.id))"
        case .getEquips:
            return "getAllEquip"
        case .getEquip(id: let id):
            return "getAllEquip/\(String(id!))"
        case .getBuyEquips:
            return "getBuyEquip"
        case .getRentEquips:
            return "getRentEquip"
        case .getUserBuys:
            return "userBuy/\(String(Auth.auth.user!.id))"
        case .getUserRents:
            return "userRent/\(String( Auth.auth.user!.id))"
        case .search:
            return "search"
        case .getNotifications:
            return "getNotifications"
        case .getCategories:
            return "getCatRent"
        case .getEquipsByCategory(id: let id):
            return "getEquipByCat/\(id)"
        case.getRentOptions(categoryID: let catID):
            return "getRentOptions/\(catID)"
        case .rentEquip:
            return "rentForm"
        }
    }
    
    
    var method: Moya.Method{
        switch self{
        case .upload, .contactUs,  .updateToken, .forgotPassword, .editUser, .login, .register, .search, .addOrder, .addToWishlist, .rentEquip:
            return .post
            
        default:
            return .get
        }
    }
    
    
    
    var task: Task{
        switch self{
            
        case .register(user: let user1):
            return .requestJSONEncodable(user1)
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case.editUser(variables: let dict):
            var dic = dict.dictionary
            dic["user_id"] = Auth.auth.user!.id
            return.requestParameters(parameters: dic, encoding: JSONEncoding.default)
        //return .requestJSONEncodable(dict)
        case .forgotPassword(email: let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .updateToken(token: let token):
            return .requestParameters(parameters: ["user_id": Auth.auth.user!.id, "token": token], encoding: JSONEncoding.default)
        
        case .contactUs(name: let name, email: let email , message: let message):
            return .requestParameters(parameters: ["name": name, "email": email, "message": message], encoding: JSONEncoding.default)
        case .upload(image: let image,file: let url):
            if let image = image{
                let data = image.jpegData(compressionQuality: 0.75)!
                let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                let multipartData = [imageData]
                return .uploadMultipart(multipartData)
            }
            else if let data = NSData(contentsOfFile: url!.path){
                
                let fileData = MultipartFormData(provider: .data(data as Data), name: "image", fileName: "record.m4a", mimeType: "audio/m4a")
                let multipartData = [fileData]
                return .uploadMultipart(multipartData)
            }
            
            return .requestPlain
        case .addOrder(equipID: let equipID, company: let company, email: let email, phone: let phone, name: let name):
            return .requestParameters(parameters: ["equipment_id": equipID, "phone": phone, "email": email, "company_name": company, "res_person": name], encoding: JSONEncoding.default)
        case .addToWishlist(equipID: let id):
            return .requestParameters(parameters: ["user_id": Auth.auth.user!.id, "equip_id": id], encoding: JSONEncoding.default)
        case .search(search: let search):
            return .requestParameters(parameters: ["search": search], encoding: JSONEncoding.default)
        case .rentEquip(rentForm: let form):
            return .requestJSONEncodable(form)
        default:
            return .requestPlain
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                "client": "b2107226d0689927ab83f100c4554c74f6d5d2ce",
                "secret": "89f36847d06f492d748c691a18a5cb25581d2909"]
    }
}
