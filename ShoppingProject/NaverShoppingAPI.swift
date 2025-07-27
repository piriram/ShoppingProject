//
//  NaverShoppingAPI.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: 네트워크 레이어
import Foundation
import Alamofire

final class NaverShoppingAPI {
    
    static let shared = NaverShoppingAPI()
    static var products: [Product] = [] // 지금은 사용안함
    private let url = "https://openapi.naver.com/v1/search/shop.json"
    
    private let headers: HTTPHeaders = [
        "X-Naver-Client-Id": "9067hsreYemCvhVNChzB",
        "X-Naver-Client-Secret": "jyGHE4Z7ck"
    ]
    
    private init() {}
    
    func fetchProducts(query:String,display:Int,sort:String,completion: @escaping (Result<ProductTotal, Error>) -> Void) {
        // TODO: Sort 추가하기
        let parameters: [String: String] = [
            "query": query,
            "display": "\(display)",
            "sort": "\(sort)"
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProductTotal.self) { response in
            switch response.result {
            case .success(let data):
                dump(data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}

