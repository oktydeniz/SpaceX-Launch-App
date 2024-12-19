//
//  DateUtil.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

extension Date {
   
    func formattedLocalDate(format: String = "yyyy-MM-dd - HH:mm", localeIdentifier: String = "tr_TR") -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: localeIdentifier)
        
        return formatter.string(from: self)
    }
    
    static func fromISO8601String(_ isoString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: isoString)
    }
}
