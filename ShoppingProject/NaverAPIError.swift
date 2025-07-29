//
//  NaverAPIError.swift
//  ShoppingProject
//
//  Created by piri kim on 7/30/25.
//

import Foundation
enum NaverAPIError: Error {
    case incorrectQuery         // SE01
    case invalidDisplayValue    // SE02
    case invalidStartValue      // SE03
    case invalidSortValue       // SE04
    case malformedEncoding      // SE06
    case invalidAPI             // SE05
    case systemError            // SE99
    case unknownError(code: String?)
    case networkDisconnected
    case requestFailed(message: String)
    
    var message: String {
        switch self {
        case .incorrectQuery:
            return "잘못된 쿼리 요청입니다. 검색어를 확인해주세요."
        case .invalidDisplayValue:
            return "display 값이 올바르지 않습니다. (1~100 사이)"
        case .invalidStartValue:
            return "start 값이 유효하지 않습니다. (1~1000 사이)"
        case .invalidSortValue:
            return "정렬 기준 값이 잘못되었습니다."
        case .malformedEncoding:
            return "검색어 인코딩이 잘못되었습니다."
        case .invalidAPI:
            return "존재하지 않는 검색 API입니다."
        case .systemError:
            return "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .unknownError(let code):
            return "알 수 없는 오류가 발생했습니다. (\(code ?? "알 수 없음"))"
        case .networkDisconnected:
            return "네트워크에 연결되어 있지 않습니다."
        case .requestFailed(let msg):
            return msg
        }
    }
}
struct NaverAPIErrorResponse: Decodable {
    let errorCode: String
    let message: String
}

extension NaverAPIError {
    static func fromCode(_ code: String) -> NaverAPIError {
        switch code {
        case "SE01": return .incorrectQuery
        case "SE02": return .invalidDisplayValue
        case "SE03": return .invalidStartValue
        case "SE04": return .invalidSortValue
        case "SE05": return .invalidAPI
        case "SE06": return .malformedEncoding
        case "SE99": return .systemError
        default: return .unknownError(code: code)
        }
    }
}
