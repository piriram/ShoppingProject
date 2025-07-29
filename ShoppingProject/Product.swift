//
//  Product.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: 네이버 API 모델
import Foundation

struct ProductTotal: Decodable {
    let total: Int
    let items: [Product]
}

struct Product: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    var isLiked:Bool = false
    private enum CodingKeys: String, CodingKey {// isLiked를 디코딩 대상에서 제외
        case title, link, image, lprice, mallName
    }
}
