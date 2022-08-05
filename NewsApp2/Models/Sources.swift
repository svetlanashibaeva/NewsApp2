//
//  Sources.swift
//  NewsApp2
//
//  Created by Света Шибаева on 05.08.2022.
//

import Foundation

struct Sources: Decodable {
    let sources: [Source]
}

struct Source: Decodable {
    let id: String
    let name: String
}
