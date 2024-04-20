//
//  NewsViewModel.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation
import Combine

/// 뉴스 뷰 모델
class NewsViewModel {
    
    let api = NewsAPI()
    
    init() {
        
    }
    
    /// 뉴스 리스트 조회
    func requestNewsList() {
        
        _ = self.api.requestNewsFromAlamofire().sink(receiveCompletion: {complete in
            
            switch complete {
            case .finished:
                break
            case .failure(let error):
                break
            }
        }, receiveValue: {data in
            
            
        })
    }
}
