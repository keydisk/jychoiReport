//
//  NewsModel.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation

// MARK: - NewsModel

/// 뉴스 모델
struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
    
    /// 마지막에 저장된 뉴스 데이터 (없거나 저장된 데이터가 깨졌을 경우 nil을 리턴)
    static var localSavedNewsModel: NewsModel? {
        
        guard let data = UserDefaults.standard.object(forKey: "NewsModel") as? Data else {
            return nil
        }
        
        return try? JSONDecoder().decode(NewsModel.self, from: data)
    }
    
    /// 마지막 데이터 저장
    static func saveNewsModel(_ data: Data) {
        
        UserDefaults.standard.setValue(data, forKey: "NewsModel")
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    /// 화면에 표시할 날짜 정보
    var printPublishedAt: String? {
        
        let date = Date(fromString: self.publishedAt, format: "yyyy-MM-dd'T'HH:mm:ssZ")
        return date?.toString(format: "yyyy-MM-dd HH:mm:ss")
    }
}

struct PrintArticle {
    
    let article: Article
    var didView = false
    
    var title: String {
        article.title
    }
    
    var urlToImage: String? {
        article.urlToImage
    }
    
    var printPublishedAt: String? {
        article.printPublishedAt
    }
    
    var newsUrl: String {
        article.url
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
