//
//  LoginModel.swift
//  messenger
//
//  Created by Khurshed Umarov on 15.12.2022.
//

import UIKit
import FirebaseAuth

typealias LoginRequest = Login.ByEmailAndPassword.Request
typealias LoginResponse = Login.ByEmailAndPassword.Response
typealias LoginViewModel = Login.ByEmailAndPassword.ViewModel

enum Login {
    
    enum ByEmailAndPassword {
        struct Request {
            let email: String
            let password: String
        }
        
        struct Response {
            let user: User
        }
        
        struct ViewModel {
            let email: String
        }
    }
}
