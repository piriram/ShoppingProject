//
//  NaverShoppingAPI.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: 네트워크 레이어
// 싱글톤 패턴의 이점?
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
    func fetchAllQueryProducts(query: String, display: Int, sort: String, start: Int,completion: @escaping (Result<ProductTotal, Error>) -> Void){
        fetchAllQueryProducts(query: query, display: display, sort: sort, start: start, filter: "", exclude: "", completion: completion)
    }
    func fetchAllQueryProducts(query: String, display: Int, sort: String,start: Int,filter:String,exclude:String,completion: @escaping (Result<ProductTotal, Error>) -> Void) {
       
        let parameters: [String: String] = [
            "query": query,
            "display": "\(display)",
            "sort": "\(sort)",
            "start": "\(start)",
            "filter": filter,
            "exclude": exclude
        ]
        print("start:\(start)")
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProductTotal.self) { response in
            if let statusCode = response.response?.statusCode,
               let data = response.data,
               statusCode >= 400 {
                if let errorResponse = try? JSONDecoder().decode(NaverAPIErrorResponse.self, from: data){
                    let error = NaverAPIError.fromCode(errorResponse.errorCode)
                    completion(.failure(error))
                    return
                }
            }
            switch response.result {
            case .success(let data):
//                dump(data)
                
                completion(.success(data))
            case .failure(let error):
                if let urlError = error.underlyingError as? URLError,
                   urlError.code == .notConnectedToInternet {
                    completion(.failure(NaverAPIError.networkDisconnected))
                }
                else{
                    completion(.failure(NaverAPIError.requestFailed(message: error.localizedDescription)))
                }
                
            }
        }
    }
    
  
    
}

extension NaverShoppingAPI{
    // MARK: 함수 오버로딩으로 사용해봄
    // 1. sort 기본값 제공
    func fetchProducts(query: String, display: Int, completion: @escaping (Result<ProductTotal, Error>) -> Void) {
        fetchProducts(query: query, display: display, sort: "sim", completion: completion)
    }
    
    // 2. display 기본값도 제공
    func fetchProducts(query: String, completion: @escaping (Result<ProductTotal, Error>) -> Void) {
        fetchProducts(query: query, display: 30, sort: "sim", completion: completion)
    }
    
    // 3. 실제 로직 처리하는 함수 (기존 함수)
    func fetchProducts(query: String, display: Int, sort: String, completion: @escaping (Result<ProductTotal, Error>) -> Void) {
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
