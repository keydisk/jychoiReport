//
//  NewsModel.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation

// MARK: - NewsModel
struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author, title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
