//
//  CommonParam.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation
import Alamofire

/// 파라매터 공통
protocol CommonParam {
    
    var defaultCommonParam: Parameters {get}
}

extension CommonParam {
    
    var defaultCommonParam: Parameters {
        
        var param = Parameters()
        
        param["apiKey"] = ApiConstants.apiKey
        
        return param
    }
}
