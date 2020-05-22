//
//  DateServices.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 22/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class DateServices {
    
    func getTimeSinceLastEntry(lastDate: Date) -> String {
        
        let periodInSeconds = lastDate.distance(to: Date())
        let periodInMinutes = Int(periodInSeconds / 60)
        
        // Minutes
        if periodInMinutes < 60 {
            if periodInMinutes == 1 {
                return "há \(periodInMinutes) minuto"
            } else {
                return "há \(periodInMinutes) minutos"
            }
        }
        // Hours
        else {
            let periodInHours = Int(periodInMinutes / 60)
            if periodInHours < 24 {
                if periodInHours == 1 {
                    return "há \(periodInHours) hora"
                } else {
                    return "há \(periodInHours) horas"
                }
            }
            // Days
            else {
                let periodInDays = Int(periodInHours / 24)
                if periodInDays < 7 {
                    if periodInDays == 1 {
                        return "há \(periodInDays) dia"
                    } else {
                        return "há \(periodInDays) dias"
                    }
                }
                // Weeks
                else {
                    let periodInWeeks = Int(periodInDays / 7)
                    if periodInWeeks == 1 {
                        return "há \(periodInWeeks) semana"
                    } else {
                        return "há \(periodInWeeks) semanas"
                    }
                }
            }
        }
    }
    
    func subtractDays(days: Int, date: Date) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -days, to: date)
    }

    func daysSinceDate(date: Date) -> Int {
        let timeInterval: Double = date.timeIntervalSinceNow
        return Int(-timeInterval/(60.0*60.0*24.0)) // timeInterval is given in seconds
    }
    
    func daysUntillDate(date: Date) -> Int {
        let timeInterval: Double = date.timeIntervalSinceNow
        return Int(timeInterval/(60.0*60.0*24.0)) // timeInterval is given in seconds
    }
    
    func stringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: dateString)
    }

    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
