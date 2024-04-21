//
//  ArticleElementCell.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import UIKit
import SnapKit
import RxSwift

/// 기사 항목 셀
class ArticleElementCell: UICollectionViewCell {
    
    var articleImg: UIImageView!
    var title: UILabel!
    var publishedDate: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupViews()
    }
    
    private func setupViews() {
        
        self.articleImg    = UIImageView()
        self.title         = UILabel()
        self.publishedDate = UILabel()
        
        self.articleImg.clipsToBounds = true
        self.articleImg.layer.cornerRadius = 4
        self.articleImg.layer.borderWidth  = 1
        self.articleImg.layer.borderColor  = UIColor.black.cgColor
        self.articleImg.contentMode = .scaleAspectFit
        
        self.contentView.backgroundColor = .white
        
        let font = UIFont.systemFont(ofSize: 18)
        self.title.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
        self.publishedDate.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        self.title.textColor = .black
        self.publishedDate.textColor = .black
        
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        self.publishedDate.textAlignment = .left
        
        self.contentView.addSubview(self.articleImg)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.publishedDate)
        
        self.articleImg.snp.makeConstraints({m in
            m.leading.equalTo(16)
            m.top.equalTo(10)
            m.width.equalToSuperview().multipliedBy(0.25)
            m.bottom.equalTo(10)
        })
        
        self.title.snp.makeConstraints({m in
            
            m.leading.equalTo(self.articleImg.snp.trailing).offset(10)
            m.trailing.equalToSuperview().inset(16)
            m.top.equalTo(10)
        })
        
        self.publishedDate.snp.makeConstraints({m in
            
            m.leading.equalTo(self.title)
            m.top.equalTo(self.title.snp.bottom).offset(6)
            m.trailing.equalToSuperview().inset(16)
            m.bottom.equalTo(10)
        })
        
    }
    
    func setDatasource(model: PrintArticle) {
        
        var selectedOrNotSelectedColor: UIColor = .black
        
        if let imgUrl = model.urlToImage {
            
            self.articleImg.loadImageFromUrl(imgUrl, placeHolderImg: UIImage(systemName: "newspaper"))
        } else {
            
            self.articleImg.image = UIImage(systemName: "newspaper")
            self.articleImg.tintColor = .black
            self.articleImg.layer.borderColor = selectedOrNotSelectedColor.cgColor
        }
        
        self.title.text = model.title
        self.publishedDate.text = "기자작성일 : \(model.printPublishedAt ?? "")"
        
        if model.didView {
            selectedOrNotSelectedColor = .red
        }
        
        self.articleImg.tintColor    = selectedOrNotSelectedColor
        self.title.textColor         = selectedOrNotSelectedColor
        self.publishedDate.textColor = selectedOrNotSelectedColor
    }
    
}

