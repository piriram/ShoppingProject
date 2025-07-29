//
//  SortType.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
//MARK: 정렬 타입을 enum으로 정리
import Foundation
enum SortType: String, CaseIterable {
    case sim
    case date
    case dsc
    case asc 

    var title: String {
        switch self {
        case .sim: return "정확도"
        case .date: return "날짜순"
        case .dsc: return "가격높은순"
        case .asc: return "가격낮은순"
        }
    }
}
