//
//  ProductAService.swift
//  4thAssignment
//
//  Created by Kinam on 4/17/24.
//

import Foundation

class ProductService {
    // RemoteProduct객체 또는 Error를 매개변수로 받는 함수 생성
    func fetchRemoteProduct(completion: @escaping (Result<RemoteProduct, Error>) -> Void) {
        // 1 ~ 100 사이의 랜덤한 Int 숫자를 가져옵니다.
        let productID = Int.random(in: 1 ... 100)
        
        // URLSession을 통해 RemoteProduct를 가져옵니다.
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    // 오류 발생시 completion 클로저를 통해 .failure 케이스를 전달
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        completion(.success(product))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}

