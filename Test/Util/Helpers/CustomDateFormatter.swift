//
//  CustomDateFormatter.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import Foundation

enum StringDateType: String {
    case monthYear                  = "MM/yy"
    case fullDayMonthYearDotes      = "dd.MM.yyyy"
    case fullDayMonthYearSlashes    = "dd/MM/yyyy"
    case hour                       = "HH:mm"
    case mounth                     = "MMMM"
    case mounthInt                  = "MM"
    case year                       = "yyyy"
    case monthDayHour               = "MMMM dd',' hh:mm"
    case programmatically           = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case dayMonthYear               = "dd MMM yyyy"
    case fullWithWeekDays           = "MMM dd, EEEE"
    case fullMonthDay               = "MMMM dd"
    case fullMonthDayYear           = "MMMM dd, yyyy"
    case weakDay                    = "EEEE"
    case timezone                   = "O"
    
    
}

class DateConverter {
    
    static let sharedInstance = DateConverter()
    
    private init() { }
    
    
    // MARK: - Public Methods
    
    func string(from dateString: String?, withFormat format: StringDateType) -> String? {
        guard let date = date(from: dateString) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        // dateFormatter.locale = Locale(identifier: LocalizationManager.sharedInstance.currentLanguage.rawValue)
        
        return dateFormatter.string(from: date).capitalized
    }
    func string(from date: Date?, withFormat format: StringDateType) -> String? {
        guard let date = date else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        // dateFormatter.locale = Locale(identifier: LocalizationManager.sharedInstance.currentLanguage.rawValue)
        
        return dateFormatter.string(from: date)
    }
    
    
    func date(from string: String?, format: StringDateType? = .programmatically) -> Date? {
        guard let string = string else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format?.rawValue
        
        // dateFormatter.locale = Locale(identifier: LocalizationManager.sharedInstance.currentLanguage.rawValue)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let date = dateFormatter.date(from: string)
        
        return date
    }
}

