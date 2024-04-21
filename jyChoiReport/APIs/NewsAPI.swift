//
//  NewsAPI.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation
import Combine
import Alamofire


/// 뉴스 요청 api
class NewsAPI: CommonParam {
    
    let api = APIClient()
    
    /// 뉴스 요청 메소드
    /// - Returns: Data 타입 리턴
    func requestNewsFromAlamofire() -> AnyPublisher<Data, NSError> {
        
        var param = self.defaultCommonParam
        
        param["country"] = "kr"
        param["apiKey"]  = ApiConstants.apiKey
        
        return self.api.requestData(url: .headline, param: param, method: .get)
    }
    
    func requestNewsFromUrlSession() -> AnyPublisher<Data, NSError> {
        
        var param = self.defaultCommonParam
        
        param["country"] = "kr"
        param["apiKey"]  = ApiConstants.apiKey
        
        return self.api.urlSessionRequest(url: .headline, method: .get, param: param)
    }
}
