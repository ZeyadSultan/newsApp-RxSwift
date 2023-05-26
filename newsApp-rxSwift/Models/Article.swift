//
//  Article.swift
//  newsApp-rxSwift
//
//  Created by Zeyad on 26/05/2023.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]?
}

struct Article: Decodable {
    let title: String
    let description: String
}
