//
//  UIKit+JetDevs.swift
//  JetDevsHomeWork
//
//  Created by Avruti on 11/01/24.
//

import Foundation

extension String {
    
    var dayDifference: Int {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let createdAt = dateFormatter.date(from: self) ?? Date()
        let date1 = calendar.startOfDay(for: createdAt)
        var date2 = calendar.startOfDay(for: Date())
        let days = calendar.dateComponents([.day], from: date1, to: date2).day
        return (days ?? 0)
    }
}
