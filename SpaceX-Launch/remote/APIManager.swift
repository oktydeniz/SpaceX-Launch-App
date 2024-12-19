//
//  APIManager.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Alamofire
import Combine

import Foundation

class APIManager {
    static let shared = APIManager()
    private init(){}
    
    func fetch<T: Decodable>(_ endpoint:APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        return Future { promise in
            AF.request(endpoint.url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                    
                }
        }.eraseToAnyPublisher()
    }
}
