//
//  DateExtension.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import Foundation

extension Date {
    
    /// 문자열과 포맷으로 Date 생성
    public init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = .current
        
        if let date = formatter.date(from: string) {
            self = date
        } else {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "ko_kr")
            RFC3339DateFormatter.dateFormat = format
            RFC3339DateFormatter.timeZone = .current
            
            if let date = RFC3339DateFormatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        }
    }
    
    /// Date 를 포맷에 해당하는 문자열로 반환한다
    ///
    /// - Parameter format: date변환 포맷
    /// - Returns: date 문자열
    public func toString(format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko")
        
        return formatter.string(from: self)
    }
}
