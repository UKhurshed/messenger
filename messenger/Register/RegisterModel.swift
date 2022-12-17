//
//  RegisterModel.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import Foundation

typealias RegisterRequest = Register.ByEmailAndPassword.Request
typealias RegisterResponse = Register.ByEmailAndPassword.Response
typealias RegisterViewModel = Register.ByEmailAndPassword.ViewModel

enum Register {
    
    enum ByEmailAndPassword {
        struct Request {
            let firstName: String
            let lastName: String
            let email: String
            let password: String
        }
        
        struct Response {
//            let user: User
        }
        
        struct ViewModel {
            let email: String
        }
    }
}
