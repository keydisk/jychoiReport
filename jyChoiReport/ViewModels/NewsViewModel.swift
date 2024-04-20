//
//  NewsViewModel.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation
import Combine
import RxSwift
import RxCocoa

/// 뉴스 뷰 모델
class NewsViewModel {
    
    let api = NewsAPI()
    
    let newsList = BehaviorRelay<[Article]?>(value: nil)
    
    init() {
        
    }
    
    var requestNewsListCancelable: AnyCancellable?
    /// 뉴스 리스트 조회
    func requestNewsList() {
        
        self.requestNewsListCancelable?.cancel()
        
        self.requestNewsListCancelable = self.api.requestNewsFromAlamofire().sink(receiveCompletion: {complete in
            
            switch complete {
            case .finished:
                break
            case .failure(let error):
                break
            }
        }, receiveValue: {[unowned self] data in
            
            guard let list = try? JSONDecoder().decode(NewsModel.self, from: data) else {
                
                return
            }
            
            self.newsList.accept(list.articles)
        })
    }
}
