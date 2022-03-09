//
// AppError
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Foundation

enum AppError: Error {
    case noAppFolder
    case fileNotFound
    case dataIsNotString
    case noPermission
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noAppFolder: return R.S.errorNoAppFolder
            case .fileNotFound: return R.S.errorFileNotFound
            case .dataIsNotString: return R.S.errorDataIsNotString
            case .noPermission: return R.S.errorNoPermission
        }
    }
}
