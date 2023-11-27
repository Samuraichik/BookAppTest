//
//  BookModel.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation

// MARK: - Book Model
struct Book: AnyModel, Identifiable, Hashable {
    let id: Int
    let name: String
    let author: String
    let summary: String
    let genre: String
    let coverURL: String
    let views: String
    let likes: String
    let quotes: String

    enum CodingKeys: String, CodingKey {
        case id, name, author, summary, genre
        case coverURL = "cover_url"
        case views, likes, quotes
    }
}
