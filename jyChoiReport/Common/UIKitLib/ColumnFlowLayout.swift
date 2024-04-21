//
//  ColumnFlowLayout.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/21/24.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        var leftMargin = self.sectionInset.left
        var maxY       = CGFloat(-1.0)
        
        attributes?.forEach({ layoutAttribute in
            if let newFrame = layoutAttributesForItem(at: layoutAttribute.indexPath)?.frame {
                
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = self.sectionInset.left
                }
                
                
                layoutAttribute.frame.origin.x = leftMargin
                layoutAttribute.frame.size.width = newFrame.width
                
                leftMargin += layoutAttribute.frame.width + self.minimumInteritemSpacing
                maxY        = max(layoutAttribute.frame.maxY , maxY)
            }
        })
        
        return attributes
    }
    
}
