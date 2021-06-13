import Foundation
import UIKit

struct TimeEvent{
    var day: Int
    var time: String
    
    var text: String{
        get{
            return getTextByDay() + " в " + time
        }
    }
    
    func getTextByDay() -> String {
        var text = "Выкл."
        switch day {
        case -1:
            text =  "Выкл."
            break
        case 0:
            text =  "В сам ДР"
            break
        case 1:
            text =  "За 1 день"
            break
        case 2:
            text =  "За 2 дня"
            break
        case 3:
            text =  "За 3 дня"
            break
        case 4:
            text =  "За 4 дня"
            break
        case 5:
            text =  "За 5 дней"
            break
        case 6:
            text =  "За 6 дней"
            break
        case 7:
            text =  "За 7 дней"
            break
        case 8:
            text =  "За 8 дней"
            break
        default:
            text =  "Выкл."
        }
        return text
        
    }
}
