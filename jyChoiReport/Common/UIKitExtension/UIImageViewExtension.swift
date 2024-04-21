//
//  UIImageViewExtension.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import UIKit

extension UIImageView {
    
    /// 이미지 서버에서 로딩
    /// - Parameters:
    ///   - imgUrl: 이미지 URL
    ///   - placeHolderImg: 이미지가 존재하지 않을때 디폴트 이미지
    func loadImageFromUrl(_ imgUrl: String, placeHolderImg: UIImage? = nil) {
        
        guard let url = URL(string: imgUrl) else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            var imgData: Data?
            if let data = UserDefaults.standard.object(forKey: "imgCache:\(imgUrl)") as? Data {
                imgData = data
            } else {
                
                imgData = try? Data(contentsOf: url)
            }
        
            DispatchQueue.main.async {[weak self] in
                
                if var imgData = imgData, var img = UIImage(data: imgData) {
                    
                    if let width = self?.frame.size.width {
                        
                        let rate = img.size.height / img.size.width
                        img = img.resizedImage(CGSize(width: width, height: width * rate))
                    }
                    
                    self?.image = img
                    
                    imgData = img.pngData() ?? img.jpegData(compressionQuality: 1.0) ?? imgData
                } else if let placeHolderImg = placeHolderImg {
                    
                    self?.image = placeHolderImg
                }
                
                if let imgData = imgData {
                    
                    UserDefaults.standard.setValue(imgData, forKey: "imgCache:\(imgUrl)")
                    UserDefaults.standard.synchronize()
                }
            }
            
        }
    }
    
}

extension UIImage {
    
    /// 이미지 리사이징
    ///
    /// - Parameters:
    ///   - inRect: 이미지 크기
    ///   - opaque: 투명 여부
    /// - Returns: 리사이징된 이미지
    public func resizedImage(_ inRect:CGSize, opaque:Bool = false) -> UIImage {
        
        let scale = UIScreen.main.scale;
        
        UIGraphicsBeginImageContextWithOptions(inRect, opaque, scale);
        
        if !opaque {
            
            UIGraphicsGetCurrentContext()?.interpolationQuality = .none
        }
        
        self.draw(in: CGRect(x:0, y:0, width:inRect.width, height:inRect.height));
        
//        return UIGraphicsGetImageFromCurrentImageContext()!
        if let newImg = UIGraphicsGetImageFromCurrentImageContext() {
            
            UIGraphicsEndImageContext()
            return newImg
        } else {
            return self
        }
    }
}
