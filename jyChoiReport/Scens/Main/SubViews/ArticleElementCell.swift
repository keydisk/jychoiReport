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
    var box: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupViews()
    }
    
    private func setupViews() {
        
        self.box = UIView()
        self.articleImg    = UIImageView()
        self.title         = UILabel()
        self.publishedDate = UILabel()
        
        self.articleImg.clipsToBounds = true
        self.articleImg.layer.cornerRadius = 4
//        self.articleImg.layer.borderWidth  = 1
//        self.articleImg.layer.borderColor  = UIColor.black.cgColor
        self.articleImg.contentMode = .scaleAspectFit
        
        self.box.backgroundColor = .white
        self.box.layer.cornerRadius = 4
        self.box.layer.borderWidth  = 1
        self.box.layer.borderColor  = UIColor.lightGray.cgColor
        
        let font = UIFont.systemFont(ofSize: 18)
        self.title.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
        self.publishedDate.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        self.title.textColor = .black
        self.publishedDate.textColor = .black
        
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        self.publishedDate.textAlignment = .left
        self.publishedDate.numberOfLines = 0
        
        self.box.addSubview(self.articleImg)
        self.box.addSubview(self.title)
        self.box.addSubview(self.publishedDate)
        
        self.articleImg.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.articleImg.snp.makeConstraints({m in
            m.leading.equalTo(16)
            m.top.equalTo(10)
            m.width.equalToSuperview().multipliedBy(0.25)
            m.bottom.equalTo(-10).priority(.medium)
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
            m.bottom.equalTo(-10)
        })
        
        self.contentView.addSubview(self.box)
        
        self.box.snp.makeConstraints({m in
            
            m.edges.equalToSuperview().priority(.medium)
            m.width.equalTo(UIScreen.main.bounds.width)
        })
        
        if UIDevice.current.orientation.isLandscape {
            
            self.box.snp.remakeConstraints({m in
                
                m.edges.equalToSuperview().priority(.medium)
                m.width.equalTo((UIScreen.main.bounds.width - 20) / 3 )
            })
            
        } else {
            
            self.box.snp.remakeConstraints({m in
                
                m.edges.equalToSuperview().priority(.medium)
                m.width.equalTo(UIScreen.main.bounds.width)
            })
        }
    }
    
    func setDatasource(model: PrintArticle) {
        
        let selectedOrNotSelectedColor: UIColor = model.didView ? .red : .black
        
        if let imgUrl = model.urlToImage {
            
            self.articleImg.loadImageFromUrl(imgUrl, placeHolderImg: UIImage(systemName: "newspaper"))
        } else {
            
            self.articleImg.image = UIImage(systemName: "newspaper")
            self.articleImg.tintColor = .black
            self.articleImg.layer.borderColor = selectedOrNotSelectedColor.cgColor
        }
        
        self.title.text = model.title
        self.publishedDate.text = "기자작성일 : \(model.printPublishedAt ?? "")"
        
        self.title.textColor         = selectedOrNotSelectedColor
    }

}

