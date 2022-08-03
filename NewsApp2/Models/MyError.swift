//
//  MyError.swift
//  NewsApp2
//
//  Created by Света Шибаева on 03.08.2022.
//

import Foundation

enum MyError: LocalizedError {
    case urlError
    case unknownError
    case parseError
    
    var errorDescription: String {
        switch self {
        case .urlError:
            return "URL error"
        case .unknownError:
            return "Unknown error"
        case .parseError:
            return "Parse error"
        }
    }
}
