//
//  ApiError.swift
//  NewsApp2
//
//  Created by Света Шибаева on 05.08.2022.
//

import Foundation

struct ApiError: Decodable {
    let code: String
    let message: String
}
