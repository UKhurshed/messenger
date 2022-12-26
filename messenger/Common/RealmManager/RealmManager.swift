//
//  RealmManager.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    var realm = try! Realm()
}
