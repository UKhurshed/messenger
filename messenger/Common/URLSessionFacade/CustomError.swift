//
//  CustomError.swift
//  messenger
//
//  Created by Khurshed Umarov on 15.12.2022.
//

import Foundation

enum CustomError: Error {
    case jsonParseError
    case urlRequestNull
    case nullData
    case urlCallError
    case networkSessionError
    case freedReference
    case serviceWasNil
    case userNotExistsFromDisk
    case getConversationsFromFirebaseError
    case failedToFetch
    case getConversationsFromDatabaseError
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .jsonParseError:
            return R.string.localizable.jsonParseError()
        case .urlRequestNull:
            return R.string.localizable.urlConvertIsNull()
        case .nullData:
            return R.string.localizable.dataFromDataTaskIsNull()
        case .urlCallError:
            return R.string.localizable.thereIsNoInternetConnection()
        case .networkSessionError:
            return R.string.localizable.networkSessionError()
        case .freedReference:
            return R.string.localizable.freedReference()
        case .serviceWasNil:
            return R.string.localizable.serviceWasNil()
        case .userNotExistsFromDisk:
            return R.string.localizable.userIsntExist()
        case .getConversationsFromFirebaseError:
            return R.string.localizable.getConversationFirebaseError()
        case .failedToFetch:
            return R.string.localizable.failedToFetch()
        case .getConversationsFromDatabaseError:
            return R.string.localizable.getConversationFromDB()
        }
    }
}
