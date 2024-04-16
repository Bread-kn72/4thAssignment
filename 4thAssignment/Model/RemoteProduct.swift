//
//  RemoteProduct.swift
//  4thAssignment
//
//  Created by Kinam on 4/11/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}
