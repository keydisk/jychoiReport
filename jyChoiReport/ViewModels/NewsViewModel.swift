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
import Network

/// 뉴스 뷰 모델
class NewsViewModel {
    
    /// 통신 모니터링
    private let networkMonitor: NWPathMonitor
    /// 네트웍 연결 여부
    var isNetworkConnection = true
    
    private let api = NewsAPI()
    public let newsList = BehaviorRelay<[PrintArticle]?>(value: nil)
    
    public let moveNewsDetail = PassthroughSubject<PrintArticle, Never>()
    
    init() {
        
        self.networkMonitor = NWPathMonitor()
        
        self.startNetworkMonitoring()
    }
    
    private func startNetworkMonitoring() {
        
        self.networkMonitor.start(queue: DispatchQueue.global())
        self.networkMonitor.pathUpdateHandler = {[unowned self] path in
            
            self.isNetworkConnection = path.status == .satisfied
            print("self.isNetworkConnection : \(self.isNetworkConnection)")
        }
    }
    
    private func stopMonitoring() {
        
        self.networkMonitor.cancel()
    }
    
    private func convertArticleModel(_ newsModel: NewsModel) -> [PrintArticle] {
        newsModel.articles.map({model in
            var rtnModel = PrintArticle(article: model, didView: false)
            
            rtnModel.didView = MoveApp.getData(model: model)?.first != nil
            
            return rtnModel
        })
    }
    
    /// 뉴스 상세로 이동
    func moveNewsDetail(_ model: PrintArticle) {
        
        if MoveApp.getData(model: model.article)?.first == nil {
            
            let data = MoveApp()
            
            data.checkID = model.newsUrl
            data.urlNews = URL(string: model.newsUrl)
            
            MoveApp.saveData()
        }
        
        self.moveNewsDetail.send(model)
        
        self.newsList.accept(
            
            self.newsList.value?.map({tmpModel -> PrintArticle in
                var tmpModel = tmpModel
                
                if tmpModel.newsUrl == model.newsUrl {
                    tmpModel.didView = true
                }
                
                return tmpModel
            })
        )
    }
    
    var requestNewsListCancelable: AnyCancellable?
    /// 뉴스 리스트 조회
    func requestNewsList() {
        
        #if DEBUG
        let callCnt = (UserDefaults.standard.object(forKey: "callApi") as? NSNumber)?.intValue ?? 1
        print("api callCnt : \(callCnt)")
        self.isNetworkConnection = false
        #endif
        guard self.isNetworkConnection else {
            
            guard let newsModel = NewsModel.localSavedNewsModel else {
                
                return
            }
            
            self.newsList.accept(self.convertArticleModel(newsModel) )
            return
        }
        
        self.requestNewsListCancelable?.cancel()
        self.requestNewsListCancelable = self.api.requestNewsFromAlamofire().sink(receiveCompletion: {complete in
            
            switch complete {
            case .finished:
                break
            case .failure(let error):
                break
            }
        }, receiveValue: {[unowned self] data in

            #if DEBUG
            let callCnt = (UserDefaults.standard.object(forKey: "callApi") as? NSNumber)?.intValue ?? 1
            
            print("callCnt : \(callCnt)")
            UserDefaults.standard.setValue(NSNumber(value: callCnt + 1), forKey: "callApi")
            UserDefaults.standard.synchronize()
            #endif
            do  {
                let newsModel = try JSONDecoder().decode(NewsModel.self, from: data)
                
                /// 정상적인 경우 데이터를 저장
                NewsModel.saveNewsModel(data)
                
                #if DEBUG
                print("newsModel.articles : \(newsModel.articles)")
                #endif
                self.newsList.accept(self.convertArticleModel(newsModel) )
            } catch let error {
                print("error : \(error)")
            }
        })
    }
}
