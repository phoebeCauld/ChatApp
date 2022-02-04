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
    func timeAgoSince(_ date: Date, from currentDate: Date = Date()) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        switch components.year! >= 2 {
        case true:
            return "\(components.year!) years ago"
        case false where components.year! >= 1:
            return "Last year"
        case false where components.month! >= 2:
            return "\(components.month!) months ago"
        case false where components.month! >= 1:
            return "Last month"
        case false where components.weekOfYear! >= 2:
            return "\(components.weekOfYear!) weeks ago"
        case false where components.weekOfYear! >= 1:
            return "1 week ago"
        case false where components.day! >= 2:
            return "\(components.day!) days ago"
        case false where components.day! >= 1:
            return "Yesterday"
        case false where components.hour! >= 2:
            return "\(components.hour!)h ago"
        case false where components.hour! >= 1:
            return "1h ago"
        case false where components.minute! >= 2:
            return "\(components.minute!)m ago"
        case false where components.minute! >= 1:
            return "1m ago"
        case false where components.second! >= 3:
            return "\(components.second!) sec ago"
        case false:
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
        
        switch calendar.isDateInToday(date) {
        case true:
            stringTime = ""
            formatter.timeStyle = .short
        case false where calendar.isDateInYesterday(date):
            stringTime = "yesterday at"
            formatter.timeStyle = .short
        case false:
            formatter.timeStyle = .short
        }
        let stringDate = formatter.string(from: date)
        return stringTime + stringDate
    }
}
