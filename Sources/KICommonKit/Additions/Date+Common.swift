//
//  Date+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/04/26.
//

import Foundation

public extension Date {
    
    struct Singleton {
        static let currentCalendar: Calendar = Calendar.autoupdatingCurrent
    }
    
    static var staticCurrentCalendar: Calendar {
        return Singleton.currentCalendar
    }
    
    static func fromString(_ string: String?) -> Date? {
        guard let dateString = string else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.date(from: dateString)
    }
    
    static func fromString(_ string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static var yesterday: Date {
        var minusOneDayComponents = DateComponents()
        minusOneDayComponents.day = -1
        return (Date.staticCurrentCalendar as NSCalendar).date(byAdding: minusOneDayComponents, to: Date.today, options: NSCalendar.Options(rawValue: 0)) ?? Date.today
    }
    
    static var tomorrow: Date {
        var plusOneDayComponents = DateComponents()
        plusOneDayComponents.day = 1
        return (Date.staticCurrentCalendar as NSCalendar).date(byAdding: plusOneDayComponents, to: Date.today, options: NSCalendar.Options(rawValue: 0)) ?? Date.today
    }
    
    var ddMMyyyy: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    func yyyyMMddHHmmss(with timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    
    var yyyyMMdd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var yyyyMM: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyyMM"
        return formatter.string(from: self)
    }
    
    var yyyyMMddHHmm: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyyMMdd_HHmm"
        return formatter.string(from: self)
    }
    
    var yyyyMMddTHHmmssSSSZ: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: self)
    }
    
    var HHmm: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var monthText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    var dateWithOutTime: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.timeZone = TimeZone.autoupdatingCurrent
        components.hour = 00
        components.minute = 00
        components.second = 00
        return calendar.date(from: components) ?? self
    }
    
    var currentCalendarTodayDate: Date {
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let currentCalendar = Date.staticCurrentCalendar
        var gregorianComponents = (currentCalendar as NSCalendar).components(unitFlags, from: Date())
        gregorianComponents.timeZone = TimeZone.autoupdatingCurrent
        
        return gregorianCalendar.date(from: gregorianComponents) ?? self
    }
    
    var dayCount: Int {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.day]
        
        let todayDate = currentCalendarTodayDate
        let todayDateOutTime = todayDate.dateWithOutTime
        
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: todayDateOutTime, options: NSCalendar.Options(rawValue: 0))
        
        return components.day ?? -1
    }
    
    var aDayAfter: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 0
        components.day = 1
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    var aDayBefore: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 0
        components.day = -1
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    var anHourAfter: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 0
        components.day = 0
        components.year = 0
        components.hour = 1
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    var aMonthBefore: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = -1
        components.day = 0
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    var aMonthAfter: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 1
        components.day = 0
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    func afterMonths(_ months: Int) -> Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = months
        components.day = 0
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    var aSecondBefore: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 0
        components.day = 0
        components.year = 0
        components.second = -1
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    func isSameYear(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let comparingYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: self)
        return comparingYear == currentYear
    }
    
    func isSameMonth(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        let currentDateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let dateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if (currentDateComponents.month == dateComponents.month) && (currentDateComponents.year == dateComponents.year) {
            return true
        }
        
        return false
    }
    
    func isSameDay(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        let currentDateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let dateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if (currentDateComponents.day == dateComponents.day) && (currentDateComponents.month == dateComponents.month) && (currentDateComponents.year == dateComponents.year) {
            return true
        }
        
        return false
    }
    
    private func dateFormatter(fromTemplate template: String) -> DateFormatter? {
        guard let formatString = DateFormatter.dateFormat(
            fromTemplate: template,
            options: 0,
            locale: Locale.current
        ) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter
    }
    
    func string(fromTemplate template: String) -> String {
        return dateFormatter(fromTemplate: template)?.string(from: self) ?? ""
    }
    
    func string(fromTemplate template: String, timeZone: TimeZone) -> String {
        guard let dateFormatter = dateFormatter(fromTemplate: template) else { return "" }
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func monthDayDate(_ timeZone: TimeZone? = TimeZone.current) -> String {
        guard let dateFormatter = dateFormatter(fromTemplate: "dMMM") else { return "" }
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func yearMonthDayDate(_ timeZone: TimeZone? = TimeZone.current) -> String {
        guard let dateFormatter = dateFormatter(fromTemplate: "YYYYMMMMdd") else { return "" }
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    static let year1970: Date = {
        var components = DateComponents()
        components.year = 1970
        components.month = 1
        components.day = 1
        return Calendar(identifier: .gregorian).date(from: components)!
    }()
    
    static let today: Date = {
        let date = Date()
        var components = DateComponents()
        components.year = date.year
        components.month = date.month
        components.day = date.day
        return Calendar(identifier: .gregorian).date(from: components)!
    }()
    
    static let fromTime: String = {
        let date = Date()
        return date.fromTime
    }()
    
    static let fromDate: String = {
        let date = Date()
        return String(format:"%04d%02d%02d", date.year, date.month, date.day)
    }()
    
    var fromTime: String {
        String(format:"%04d%02d%02d000000", year, month, day)
    }
    
    var daysSince1970: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.day]), from: Date.year1970, to: self).day ?? 0
    }

    var daysSinceToday: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.day]), from: Date.today, to: self).day ?? 0
    }
    
    var accessibilityTime: String { // 2020년 12월 15일 1시 1분 1초
        return string(fromTemplate: "YYYYMMMMddHms")
    }
    
    var yearMonthDayDate: String {
        return string(fromTemplate: "YYYYMMMMdd")
    }
    
    var monthDayDate: String { // 1월 2일, Jan 2
        return string(fromTemplate: "dMMM")
    }
    
    var fullMonthDayDate: String { // 1월 2일, January 2
        return string(fromTemplate: "dMMMM")
    }

    var shortTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }

    var mediumTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }

    var short12Time: String { // 24시간제 설정에서 12시간제로 표시
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        var identifier = formatter.locale.identifier
        if !identifier.hasSuffix("_POSIX") {
            identifier += "_POSIX"
            formatter.locale = Locale(identifier: identifier)
        }
        
        var string = formatter.string(from: self)
        if !string.contains(formatter.amSymbol) && !string.contains(formatter.pmSymbol) {
            formatter.dateFormat = "a h:mm"
            string = formatter.string(from: self)
        }
        return string
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    static var year2001: Date? {
        var components = DateComponents()
        components.year = 2001
        components.month = 1
        components.day = 1
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        if let year2001 = gregorian.date(from: components) {
            let year: Date = year2001
            return year
        }
        return nil
    }
    
    static var firstKakaoTalkReleaseDate: Date? {
        var components = DateComponents()
        components.year = 2010
        components.month = 3
        components.day = 18
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        if let year2001 = gregorian.date(from: components) {
            let year: Date = year2001
            return year
        }
        return nil
    }
    
    func isSameDayForWatch(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        let currentDateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let dateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if (currentDateComponents.day == dateComponents.day) && (currentDateComponents.month == dateComponents.month) && (currentDateComponents.year == dateComponents.year) {
            return true
        }
        
        return false
    }
    
    func string(forDateFormat formatString: String?, timeZone: TimeZone? = nil) -> String? {
        var dateFormatter: DateFormatter?
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
        }
        dateFormatter?.dateFormat = formatString ?? ""
        dateFormatter?.timeZone = timeZone
        return dateFormatter?.string(from: self)
    }
    
    func stringForDateFormat(fromTemplate aTemplate: String?) -> String? {
        var dateFormatter: DateFormatter?
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
        }
        let formatString = DateFormatter.dateFormat(fromTemplate: aTemplate ?? "", options: 0, locale: NSLocale.current)
        dateFormatter?.dateFormat = formatString ?? ""
        return dateFormatter?.string(from: self)
    }
    
    var shortTimeForWatch: String {
        return self.shortTimeFormatter.string(from: self)
    }
    
    var monthDayDateForWatch: String {
        return self.monthDayDateFormatter.string(from: self)
    }
    
    var monthDayDateAndTime: String { // 6월 10일 오후 6:43
        return string(fromTemplate: "dMMM a h:mm")
    }
    
    var mediumDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var mediumDateAndTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    var mediumDateAndShortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var fullDate: String {
        return self.fullDateFormatter.string(from: self)
    }
    
    var fullDateAndTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        return dateFormatter.string(from: self)
    }
    
    var fullDateWithShortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var relativeShortDate: String {
        return self.relativeShortDateFormatter.string(from: self)
    }
    
    var isToday: Bool {
        return self.isSameDayForWatch(Date())
    }
    
    var isThisYear: Bool {
        return self.isSameYear(Date())
    }
    
    var isYesterday: Bool {
        let calendar = Date.staticCurrentCalendar
        if let yesterday = (calendar as NSCalendar).date(byAdding: self.minusOneDayComponents, to: Date(), options: NSCalendar.Options(rawValue: 0)) {
            return self.isSameDayForWatch(yesterday)
        } else {
            return false
        }
    }

    var isTomorrow: Bool {
        let calendar = Date.staticCurrentCalendar
        if let tomorrow = (calendar as NSCalendar).date(byAdding: self.oneDayComponents, to: Date(), options: NSCalendar.Options(rawValue: 0)) {
            return self.isSameDayForWatch(tomorrow)
        } else {
            return false
        }
    }

    var timeInWords: String {
        if self.isToday {
            return self.shortTimeForWatch
        } else if self.isYesterday {
            return self.relativeShortDate   // localized relative date only
        } else if self.isThisYear {
            return self.monthDayDateForWatch
        }
        
        return self.relativeShortDate
    }
    
    var daysSinceReferenceDate: NSInteger {
        if let year2001 = Date.year2001 {
            let diffrents = (Date.staticCurrentCalendar as NSCalendar).components(NSCalendar.Unit.day, from: year2001, to: self, options: NSCalendar.Options(rawValue: 0))
            return diffrents.day!
        }
        return 0
    }
    
    var deltaMinitesSinceNow: Int {
        let today = Date()
        let deltaSeconds = fabs(self.timeIntervalSince(today))
        let deltaMinutes = Int(deltaSeconds / 60.0)
        return deltaMinutes
    }
        
    fileprivate var fullDateFormatter: DateFormatter {
        struct Static {
            static var fullDateFormatter: DateFormatter?
        }
        
        if Static.fullDateFormatter == nil {
            Static.fullDateFormatter = DateFormatter()
            Static.fullDateFormatter?.locale = Locale.current
            Static.fullDateFormatter?.dateStyle = DateFormatter.Style.full
            Static.fullDateFormatter?.timeStyle = DateFormatter.Style.none
        }
        return Static.fullDateFormatter!
    }
    
    fileprivate var monthDayDateFormatter: DateFormatter {
        struct Static {
            static var monthDayDateFormatter: DateFormatter?
        }
        
        if Static.monthDayDateFormatter == nil {
            Static.monthDayDateFormatter = DateFormatter()
            Static.monthDayDateFormatter?.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale.current)
        }
        return Static.monthDayDateFormatter!
    }
    
    fileprivate var relativeShortDateFormatter: DateFormatter {
        struct Static {
            static var relativeShortDateFormatter: DateFormatter?
        }
        
        if Static.relativeShortDateFormatter == nil {
            Static.relativeShortDateFormatter = DateFormatter()
            Static.relativeShortDateFormatter?.locale = Locale.current
            Static.relativeShortDateFormatter?.doesRelativeDateFormatting = true
            Static.relativeShortDateFormatter?.timeStyle = DateFormatter.Style.none
            Static.relativeShortDateFormatter?.dateStyle = DateFormatter.Style.short
        }
        return Static.relativeShortDateFormatter!
    }
    
    fileprivate var shortTimeFormatter: DateFormatter {
        struct Static {
            static var shortTimeFormatter: DateFormatter?
        }
        
        if Static.shortTimeFormatter == nil {
            Static.shortTimeFormatter = DateFormatter()
            Static.shortTimeFormatter?.locale = Locale.current
            Static.shortTimeFormatter?.dateStyle = DateFormatter.Style.none
            Static.shortTimeFormatter?.timeStyle = DateFormatter.Style.short
        }
        return Static.shortTimeFormatter!
    }
    
    fileprivate var minusOneDayComponents: DateComponents {
        struct Static {
            static var minusOneDayComponents: DateComponents?
        }
        
        if Static.minusOneDayComponents == nil {
            Static.minusOneDayComponents = DateComponents()
            Static.minusOneDayComponents?.day = -1
        }
        return Static.minusOneDayComponents!
    }
    
    fileprivate var oneDayComponents: DateComponents {
        struct Static {
            static var oneDayComponents: DateComponents?
        }
        
        if Static.oneDayComponents == nil {
            Static.oneDayComponents = DateComponents()
            Static.oneDayComponents?.day = 1
        }
        return Static.oneDayComponents!
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
    private func clippedDate(withCalendarComponents compnents: Set<Calendar.Component>) -> Date {
        if let date = Calendar.current.date(from: Calendar.current.dateComponents(compnents, from: self)) {
            return date
        }
        
        return self
    }
    
    var clippedSecond: Date {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        return clippedDate(withCalendarComponents: components)
    }
    
    var beginningOfDay: Date {
        let components: Set<Calendar.Component> = [.year, .month, .day]
        return clippedDate(withCalendarComponents: components)
    }
    
    var beginningOfMonth: Date {
        return clippedDate(withCalendarComponents: [.year, .month])
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        guard let endOfDay = Calendar.current.date(byAdding: components, to: beginningOfDay)?.addingTimeInterval(-1) else { return self }
        return endOfDay
    }
    
    func numberOfMonthsToDate(_ toDate: Date) -> Int {
        let comp = Calendar.current.dateComponents([.year, .month], from: self)
        let comp2 = Calendar.current.dateComponents([.year, .month], from: toDate)
        
        let comp2year = comp2.year ?? 0
        let compyear = comp.year ?? 0
        let betweenYears: Int = comp2year - compyear
        
        let comp2month = comp2.month ?? 0
        let compmonth = comp.month ?? 0
        let betweenMonths: Int = comp2month - compmonth
        
        return (betweenYears * 12) + betweenMonths
    }
    
    func dateByAdding(offset: Int, forComponent component: Calendar.Component) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(offset, for: component)
        if let date = Calendar.current.date(byAdding: dateComponents, to: self) {
            return date
        }
        return self
    }
    
    func formattedString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
