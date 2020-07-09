//
//  Date+Extensions.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 24/03/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation

extension Date {
    func timeAgo(numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        switch (year, month, weekOfMonth, day, hour, minute, second) {
        case (let year, _, _, _, _, _, _) where year >= 5: return "\(year) лет назад"
        case (let year, _, _, _, _, _, _) where year >= 2 && year < 5: return "\(year) года назад"
        case (let year, _, _, _, _, _, _) where year == 1 && numericDates: return "1 год назад"
        case (let year, _, _, _, _, _, _) where year == 1 && !numericDates: return "Год назад"
        case (_, let month, _, _, _, _, _) where month >= 5: return "\(month) месяцев назад"
        case (_, let month, _, _, _, _, _) where month >= 2 && month < 5: return "\(month) месяца назад"
        case (_, let month, _, _, _, _, _) where month == 1 && numericDates: return "1 месяц назад"
        case (_, let month, _, _, _, _, _) where month == 1 && !numericDates: return "Месяц назад"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth) недели назад"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && numericDates: return "1 неделю назад"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && !numericDates: return "Неделю назад"
        case (_, _, _, let day, _, _, _) where day >= 5: return "\(day) дней назад"
        case (_, _, _, let day, _, _, _) where day >= 2 && day < 5: return "\(day) дня назад"
        case (_, _, _, let day, _, _, _) where day == 1 && numericDates: return "1 день назад"
        case (_, _, _, let day, _, _, _) where day == 1 && !numericDates: return "Вчера"
        case (_, _, _, _, let hour, _, _) where hour >= 5: return "\(hour) часов назад"
        case (_, _, _, _, let hour, _, _) where hour >= 2 && hour < 5: return "\(hour) часа назад"
        case (_, _, _, _, let hour, _, _) where hour == 1 && numericDates: return "1 час назад"
        case (_, _, _, _, let hour, _, _) where hour == 1 && !numericDates: return "Час назад"
        case (_, _, _, _, _, let minute, _) where minute >= 56: return "\(minute) минут назад"
        case (_, _, _, _, _, let minute, _) where minute >= 52 && minute < 55: return "\(minute) минуты назад"
        case (_, _, _, _, _, let minute, _) where minute >= 51 && minute < 52: return "\(minute) минуту назад"
        case (_, _, _, _, _, let minute, _) where minute >= 46 && minute < 51: return "\(minute) минут назад"
        case (_, _, _, _, _, let minute, _) where minute >= 42 && minute < 45: return "\(minute) минуты назад"
        case (_, _, _, _, _, let minute, _) where minute >= 41 && minute < 42: return "\(minute) минуту назад"
        case (_, _, _, _, _, let minute, _) where minute >= 36 && minute < 41: return "\(minute) минут назад"
        case (_, _, _, _, _, let minute, _) where minute >= 32 && minute < 35: return "\(minute) минуты назад"
        case (_, _, _, _, _, let minute, _) where minute >= 31 && minute < 32: return "\(minute) минуту назад"
        case (_, _, _, _, _, let minute, _) where minute >= 26 && minute < 31: return "\(minute) минут назад"
        case (_, _, _, _, _, let minute, _) where minute >= 22 && minute < 25: return "\(minute) минуты назад"
        case (_, _, _, _, _, let minute, _) where minute >= 21 && minute < 22: return "\(minute) минуту назад"
        case (_, _, _, _, _, let minute, _) where minute >= 5 && minute < 21: return "\(minute) минут назад"
        case (_, _, _, _, _, let minute, _) where minute >= 2 && minute < 5: return "\(minute) минуты назад"
        case (_, _, _, _, _, let minute, _) where minute == 1 && numericDates: return "1 минуту назад"
        case (_, _, _, _, _, let minute, _) where minute == 1 && !numericDates: return "Минуту назад"
        case (_, _, _, _, _, _, let second) where second >= 5: return "\(second) секунд назад"
        default: return "Сейчас"
        }
    }
}
