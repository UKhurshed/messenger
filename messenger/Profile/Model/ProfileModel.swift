//
//  ProfileModel.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import Foundation

enum ProfileModelType {
    case info, logout
}

struct ProfileModel {
    let profileModelType: ProfileModelType
    let title: String
    let handler: (() -> Void)?
}
