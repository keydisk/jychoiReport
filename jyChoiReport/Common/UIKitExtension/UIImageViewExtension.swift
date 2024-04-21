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
                if let imgData = imgData {
                    
                    UserDefaults.standard.setValue(imgData, forKey: "imgCache:\(imgUrl)")
                    UserDefaults.standard.synchronize()
                }
            }
        
            DispatchQueue.main.async {[weak self] in
                
                if let imgData = imgData {
                    
//                    print("viewSize : \(self!.frame.size)")
                    self?.image = UIImage(data: imgData)
//                    print("imageSize : \(self!.image!.size)")
                } else if let placeHolderImg = placeHolderImg {
                    
                    self?.image = placeHolderImg
                }
            }
            
        }
    }
    
}
