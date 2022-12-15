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
    case customError
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
        case .customError:
            return "Custom Error"
        }
    }
}
