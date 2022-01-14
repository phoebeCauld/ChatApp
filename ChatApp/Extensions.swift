//
//  Extensions.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 06.01.2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(with url: String?) {
        guard let urlString = url else { return }
        let url = URL(string: urlString)
        self.sd_setImage(with: url)
    }
}

extension Date {
    func timeAgoSince(_ date: Date, from currentDate: Date = Date(), numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())

        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)h ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1h ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)m ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1m ago"
            } else {
                return "A min ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec ago"
        } else {
            return "Just now"
        }
    }
}


extension Double {
    func convertToTimeString() -> String {
        var stringTime = ""
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        let formatter = DateFormatter()
        if calendar.isDateInToday(date) {
            stringTime = ""
            formatter.timeStyle = .short
        } else if calendar.isDateInYesterday(date) {
            stringTime = "yesterday at"
            formatter.timeStyle = .short
        } else {
            formatter.timeStyle = .short
        }
        let stringDate = formatter.string(from: date)
        return stringTime + stringDate
    }
}
