//
//  DetailNewsViewController.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/21/24.
//

import UIKit
import SnapKit

/// 뉴스 상세
class DetailNewsViewController: UIViewController {
    
    let webView: CustomWKWebView
    let model: PrintArticle
    
    init(_ model: PrintArticle) {
        
        self.model   = model
        self.webView = CustomWKWebView(isNavigationGestrue: true)
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = model.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.view.addSubview(self.webView)
        
        self.webView.snp.makeConstraints({m in
            
            m.edges.equalToSuperview()
        })
        
        self.webView.requestUrl(requestUrl: self.model.newsUrl)
        
        self.webView.webviewDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.navigationController?.navigationBar.tintColor = .darkGray
    }
}

extension DetailNewsViewController: CustomWKWebViewDelegate {
    
    func isHttpRequestUrl(callUrl: URL?) -> Bool {
        
        return true
    }
    
    func loadingFinish() {
        
        guard (self.webView.title?.isEmpty ?? true) == false else {
            
            return
        }
        
        self.title = self.webView.title
    }
}
