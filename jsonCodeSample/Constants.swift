//
//  Constants.swift
//  jsonCodeSample
//
//  Created by Othmar Gispert on 2/1/17.
//  Copyright © 2017 Othmar Gispert. All rights reserved.
//

import Foundation

let BIN_URL = "http://httpbin.org/post"

extension Date {
    
    static let iso8601Formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
    }()
    
    var iso8601: String {
    
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    
    var dateFromISO8601: Date? {
        
        return Date.iso8601Formatter.date(from: self)
    }
}
