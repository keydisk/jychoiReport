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
    
    let viewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    var cancelableList = Set<AnyCancellable>()
    
    var collectionView: UICollectionView!
    
    
    func setupView() {
        
        let layoutView = UICollectionViewFlowLayout()
        
        layoutView.minimumInteritemSpacing = 8
        layoutView.scrollDirection = .vertical // 스크롤 방향 설정
        layoutView.itemSize = .zero
//        layoutView.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutView)
        
        self.collectionView.delegate = self
        
        self.collectionView.register(ArticleElementCell.self, forCellWithReuseIdentifier: "ArticleElementCell")
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints({m in
            
            m.edges.equalToSuperview()
        })
        
        self.viewModel.newsList.asDriver(onErrorJustReturn: nil).filter({list -> Bool in
            list != nil
        }).map({list in
            list ?? []
        }).drive(self.collectionView.rx.items) { collectionView, row, model in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleElementCell", for: IndexPath(row: row, section: 0)) as! ArticleElementCell
            
            cell.setDatasource(model: model)
            
            return cell
        }.disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(PrintArticle.self)
            .subscribe(onNext: self.viewModel.moveNewsDetail)
        .disposed(by: self.disposeBag)
        
        self.viewModel.moveNewsDetail.receive(on: DispatchQueue.main).sink(receiveValue: {[weak self] model in
            
            self?.moveNewsDetail(model)
        }).store(in: &cancelableList)
        
        self.viewModel.requestNewsList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupView()
        
        self.title = "뉴스 메인"
    }
    
    private func moveNewsDetail(_ selectedModel: PrintArticle) {
        
        let newsDetailView = DetailNewsViewController(selectedModel.title, url: selectedModel.newsUrl)
        self.navigationController?.pushViewController(newsDetailView, animated: true)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView.layoutIfNeeded()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !UIDevice.current.orientation.isLandscape {
            
            return CGSize(width: collectionView.bounds.size.width, height: 90)
        } else {
            
            return CGSize(width: (collectionView.bounds.size.width - 16) / 3, height: 90)
        }
        
        
    }
}
