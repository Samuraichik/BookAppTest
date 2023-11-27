//
//  TopBannerModel.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation

// MARK: - TopBannerSlide Model

struct TopBannerSlide: AnyModel, Identifiable, Hashable {
    let id: Int
    let bookID: Int
    let cover: String

    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "book_id"
        case cover
    }
}
