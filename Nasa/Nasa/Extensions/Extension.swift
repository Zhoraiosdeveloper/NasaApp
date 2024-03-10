//
//  Extension.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 10/03/2024.
//

import SwiftUI

extension Date {
    func DateToString() -> String
    {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: self)
    }
}


extension Notification.Name {
    static let updateView = Notification.Name("UpdateView")
    
}
