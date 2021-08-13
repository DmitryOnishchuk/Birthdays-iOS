import Foundation
import UIKit

struct TimeEvent{
    var day: Int
    var time: String
    
    var text: String{
        get{
            return getTextByDay() + " " + "EVENT_PICKER_AT".localized + " " + time
        }
    }
    
    func getTextByDay() -> String {
        var text = "EVENT_PICKER_TURN_OFF".localized
        switch day {
        case -1:
            text = "EVENT_PICKER_TURN_OFF".localized
            break
        case 0:
            text = "EVENT_PICKER_IN_BIRTHDAY".localized
            break
        case 1:
            text = "EVENT_PICKER_1_DAY_BEFORE".localized
            break
        case 2:
            text = "EVENT_PICKER_2_DAY_BEFORE".localized
            break
        case 3:
            text = "EVENT_PICKER_3_DAY_BEFORE".localized
            break
        case 4:
            text = "EVENT_PICKER_4_DAY_BEFORE".localized
            break
        case 5:
            text = "EVENT_PICKER_5_DAY_BEFORE".localized
            break
        case 6:
            text = "EVENT_PICKER_6_DAY_BEFORE".localized
            break
        case 7:
            text = "EVENT_PICKER_7_DAY_BEFORE".localized
            break
        case 8:
            text = "EVENT_PICKER_8_DAY_BEFORE".localized
            break
        default:
            text = "EVENT_PICKER_TURN_OFF".localized
        }
        return text
        
    }
}
