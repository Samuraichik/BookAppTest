//
//  RootModel.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation

// MARK: - Root Model
struct RootModel: AnyModel {
    let books: [Book]
    let topBannerSlides: [TopBannerSlide]
    let youWillLikeSection: [Int]

    enum CodingKeys: String, CodingKey {
        case books
        case topBannerSlides = "top_banner_slides"
        case youWillLikeSection = "you_will_like_section"
    }
    
    init() {
        books = []
        topBannerSlides = []
        youWillLikeSection = []
    }
}
