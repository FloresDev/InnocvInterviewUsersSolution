//
//  UserServices.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 6/11/22.
//

import Foundation
import PromiseKit

struct UserServices {
    
    static func getUsers() -> Promise<[User]> {
        return API.getUsers
            .response()
            .map {
                return try JSONDecoder().decode([User].self, from: $0.data) }
    }
    
    static func deleteUser(id: Int) -> Promise<Void> {
        return API.deleteUser(id: id)
            .response()
            .asVoid()
    }
    
    static func modifyUser(name: String, birthDate: String, id: Int) -> Promise<Void> {
        return API.modifyUser(name: name, birthDate: birthDate, id: id)
            .response()
            .asVoid()
    }
    
    static func postUser(name: String, birthDate: String) -> Promise<Void> {
        return API.postUser(name: name, birthDate: birthDate)
            .response()
            .asVoid()
    }
}
