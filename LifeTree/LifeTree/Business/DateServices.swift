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

    func timeDistanceFromDate(date: Date, timeUnit: TimeUnit) -> Int {
        
        var timeInterval = Int(date.timeIntervalSinceNow) // given in seconds
        
        switch timeUnit {
        case .week:
            timeInterval = Int(timeInterval/(60 * 60 * 24 * 7))
        case .day:
            timeInterval = Int(timeInterval/(60 * 60 * 24))
        case .hour:
            timeInterval = Int(timeInterval/(60 * 60 * 24))
        case .minute:
            timeInterval = Int(timeInterval/60)
        default:
            timeInterval = Int(timeInterval)
        }
         
        return timeInterval
    }
    
    func sumTimeInterval(time: Int, inUnitsOf unit: TimeUnit, toDate date: Date) -> Date? {
        
        var endDate = Date()
        
        if unit == .week  {
            endDate = Calendar.current.date(byAdding: .day, value: 7*time, to: date)!
        } else {
            let calendarComponent = self.timeUnitToCalendarComponent(timeUnit: unit)
            endDate = Calendar.current.date(byAdding: calendarComponent, value: time, to: date)!
        }
        
        return endDate
    }
    
    func timeUnitToCalendarComponent(timeUnit: TimeUnit) -> Calendar.Component {
        var dateComponent = Calendar.Component.day
        
        switch timeUnit {
        case .day:
            dateComponent = Calendar.Component.day
        case .hour:
            dateComponent = Calendar.Component.hour
        case .minute:
            dateComponent = Calendar.Component.minute
        default:
            dateComponent = Calendar.Component.second
        }
        
        return dateComponent
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
