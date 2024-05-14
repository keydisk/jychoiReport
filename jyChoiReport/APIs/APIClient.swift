//
//  APIClient.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation
import Combine

import Alamofire

/// 통신을 위한 클래스
class APIClient: NSObject {
    
    let NetworkTimeout: TimeInterval = 20
    
    let configuration: URLSessionConfiguration
    public weak var sessionTask:URLSessionDataTask?
    
    override init() {
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        sessionConfig.timeoutIntervalForRequest  = TimeInterval(self.NetworkTimeout)
        sessionConfig.timeoutIntervalForResource = TimeInterval(self.NetworkTimeout)
        sessionConfig.allowsCellularAccess = true
        sessionConfig.networkServiceType = .default
        
        self.configuration = sessionConfig
        
        super.init()
    }
    
    public func urlSessionRequest(url: NewsApiUrls, method: HTTPMethod, param: Parameters = [:], header:[String:String]? = nil, repeatCnt: Int = 0) -> AnyPublisher<Data, NSError> {
        
        let combine = PassthroughSubject<Data, NSError>()
        
        var localUrl = url.rawValue
        
        if method == .get, param.count > 0 {
            localUrl.append("?")
            param.forEach({key, value in
                localUrl.append("&\(key)=\(value)")
            })
            
        }
        
        if !localUrl.hasPrefix("http") {
            localUrl = ApiConstants.baseUrl.appending(localUrl)
        }
        
        var request = URLRequest(url: URL(string: localUrl)! )
        print("method.rawValue : \(method.rawValue)")
        switch method {
        case .post :
            request.httpMethod = "POST"
//            if sendData.count > 0 {
//                            
//                request.httpBody = sendData.data(using:String.Encoding.utf8)
//                request.setValue("\((request.httpBody!.count))" , forHTTPHeaderField:"Content-Length");
//            }
//            
            break
        case .get :
            request.httpMethod = "GET"
            break
        case .connect :
            request.httpMethod = "CONNECT"
            break
        case .delete :
            request.httpMethod = "DELETE"
            break
        case .head :
            request.httpMethod = "HEAD"
            break
        case .options :
            request.httpMethod = "OPTION"
            break
        case .patch :
            request.httpMethod = "PATCH"
            break
        case .put :
            request.httpMethod = "PUT"
            break
        case .trace :
            request.httpMethod = "TRACE"
            break
        default:
            break
        }
        
        if let header = header {
            for headerKey in header.keys {
                request.setValue(header[headerKey], forHTTPHeaderField: headerKey)
            }
            
            request.setValue("IOS", forHTTPHeaderField: "User-Platform")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let urlSession = URLSession(configuration: self.configuration, delegate: self, delegateQueue: OperationQueue.current)
        
        let sessionTask = urlSession.dataTask(with: request, completionHandler:{ data, response, error in
            
            #if DEBUG
            print("response url : \((response as? HTTPURLResponse)?.url?.absoluteString ?? "unknown url") statusCode : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
            #endif
            
            if let error = error as NSError? {
                
                combine.send(completion: .failure(error))
            } else {
                
                let tmpResponse = response as! HTTPURLResponse
                
                if tmpResponse.statusCode == 200, let data = data {
                    
                    combine.send(data)
                } else {
                    
                    let error = NSError(domain: "통신 에러", code: tmpResponse.statusCode)
                    combine.send(completion: .failure(error))
                }
                
                urlSession.invalidateAndCancel()
            }
            
        })
        
        sessionTask.resume()
        self.sessionTask = sessionTask
        
        return combine.eraseToAnyPublisher()
    }
    
    /// 통신 모듈 알라모파이어로 구현
    ///
    /// - Parameters:
    ///   - url: url path 부분
    ///   - data: 보낼 데이터
    ///   - param: key value 타입의 데이터
    ///   - method: 데이터 전송 타입 ex) get, post, put ....
    /// - Returns: PassThrought타입의 데이터
    func requestData(url: NewsApiUrls, data: String? = nil, param: Parameters = [:], header: HTTPHeaders? = nil, method: HTTPMethod) -> AnyPublisher<Data, NSError> {
        
        let combine = PassthroughSubject<Data, NSError>()
        
        let callUrl = url.rawValue.hasPrefix("http") ? url.rawValue : ApiConstants.baseUrl.appending(url.rawValue)
        var dataRequest: DataRequest!
        
        do {
            
            if method == .get {
                
                dataRequest = AF.request(callUrl, method: method, parameters: param, headers: header)
                
            } else {
                
                let session = Session(configuration: self.configuration)
                
                var request = try URLRequest(url: callUrl, method: method)
                request.httpBody = data?.data(using: .utf8)
                
                dataRequest = session.request(request)
            }
            
            #if DEBUG
            if CommonConstValue.showNetworkLog {
                print("url : \(url) param : \(param) ")
            }
            #endif
            
            dataRequest.validate(statusCode: 200..<300)
                .responseData(completionHandler: {responseData in
                
                guard let data = responseData.data else {
                    
                    if let error = responseData.error {
                        
#if DEBUG
                        if CommonConstValue.showNetworkLog {
                            print("error : \(error)")
                        }
                        #endif
                        combine.send(completion: .failure(error as NSError) )
                    } else {
                        
                        let error = NSError(domain: "", code: 999)
                        combine.send(completion: .failure(error as NSError) )
                    }
                    
                    combine.send(completion: .finished)
                    return
                }
                
                    #if DEBUG
//                    print("return data : \(String(data: data, encoding: .utf8) ?? "")")
                    #endif
                combine.send(data)
                combine.send(completion: .finished)
            })
        } catch let error {
            #if DEBUG
            if CommonConstValue.showNetworkLog {
                print("error : \(error)")
            }
            #endif
            combine.send(completion: .failure(error as NSError) )
        }
        
        return combine.eraseToAnyPublisher()
    }
}

extension APIClient: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        #if DEBUG
        if let error = error as NSError? {
            debugPrint("error : \(error )")
        }
        
        #endif
    }

    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(.useCredential, nil )
    }
    
}
