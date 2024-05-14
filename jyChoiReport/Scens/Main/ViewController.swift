//
//  ViewController.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import UIKit
import Combine

import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    /// 뉴스 관련 비지니스 로직을 처리하는 뷰모델
    let viewModel = NewsViewModel()
    
    let disposeBag = DisposeBag()
    var cancelableList = Set<AnyCancellable>()
    
    /// 뉴스항목을 표시할 컬렉션뷰
    var collectionView: UICollectionView!
    
    /// UI 그리기
    func setupView() {
        
        let layoutView = ColumnFlowLayout()
        layoutView.sectionInsetReference = .fromContentInset
        layoutView.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layoutView.minimumInteritemSpacing = 10
        layoutView.minimumLineSpacing = 10
        layoutView.sectionInset = .zero
        layoutView.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutView)
        
        self.collectionView.register(ArticleElementCell.self, forCellWithReuseIdentifier: "ArticleElementCell")
        self.collectionView.register(ArticleElementCell.self, forCellWithReuseIdentifier: "LandscapeArticleElementCell")
        
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints({m in
            
            m.edges.equalToSuperview()
        })
        
        /// 세로로 당겼을때 화면 리프래시
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self, action: #selector(refreshControl), for: .valueChanged)
    }
    
    private func dataBiding() {
        
        self.viewModel.newsRequetError.bind(onNext: {[weak self] error in
            
            self?.collectionView.refreshControl?.endRefreshing()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.newsList.asDriver(onErrorJustReturn: nil).filter({list -> Bool in
            list != nil
        }).map({[weak self] list in
            
            self?.collectionView.refreshControl?.endRefreshing()
            return list ?? []
        }).drive(self.collectionView.rx.items) { collectionView, row, model in
            
            var cell: ArticleElementCell!
            if UIDevice.current.orientation.isLandscape {
                
                cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "LandscapeArticleElementCell", for: IndexPath(row: row, section: 0)) as! ArticleElementCell)
            } else {
                
                cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleElementCell", for: IndexPath(row: row, section: 0)) as! ArticleElementCell)
            }
            
            cell.setDatasource(model: model)
            
            return cell
            
        }.disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(PrintArticle.self)
            .bind(to: self.viewModel.selectNews)
        .disposed(by: self.disposeBag)
        
        self.viewModel.moveNewsDetail.receive(on: DispatchQueue.main).sink(receiveValue: {[weak self] model in
            
            let newsDetailView = DetailNewsViewController(model.title, url: model.newsUrl)
            self?.navigationController?.pushViewController(newsDetailView, animated: true)
        }).store(in: &cancelableList)
        
//        self.viewModel.requestNewsList()
    }
    
    @objc func refreshControl() {
        
        self.viewModel.requestNewsList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "뉴스 메인"
        
        self.setupView()
        self.dataBiding()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView.reloadData()
    }
    
    
}
