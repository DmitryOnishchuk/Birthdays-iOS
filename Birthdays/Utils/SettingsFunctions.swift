import Foundation
import UIKit

enum AgeSettingsEnum:String {
    case upcoming
    case current
}


class SettingsFunctions {
    
    class func changeLanguageOfApp(language:String){
        
        if Storage.shared.currentLanguage != language {
            Storage.shared.currentLanguage = language
            AppDelegate.shared.loadView()
        }
    }

    class func changeThemeByUserDefaults(){
        var theme:UIUserInterfaceStyle
        switch Storage.shared.currentThemeID {
        case 0:
            theme = .unspecified
        case 1:
            theme = .light
        case 2:
            theme = .dark
        default:
            theme = .unspecified
        }
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme
        }
    }
    
    class func setThemeByUserDefaults(_ theme: UIUserInterfaceStyle){
        var save:Int = 0
        switch theme {
        case .unspecified:
            save = 0
        case .light:
            save = 1
        case .dark:
            save = 2
        default:
            save = 0
        }
        
        Storage.shared.currentThemeID = save
    }
    
    class func getNotificationTimeEventByUserDefaults(id: Int) -> TimeEvent {
        
        var defaultValue = TimeEvent(day: -1, time: "10:00")
        var key = GlobalConstants.notificationTimeEventKeyUserDefaults0
        
        switch id {
        case 0:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults0
            defaultValue = TimeEvent(day: 0, time: "10:00")
        case 1:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults1
            defaultValue = TimeEvent(day: 3, time: "10:00")
        case 2:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults2
            defaultValue = TimeEvent(day: -1, time: "10:00")
        default:
            break
        }
        
        guard let resUD = UserDefaults.standard.value(forKey: key) as? String else {
            return defaultValue
        }
        
        let fullTimeEventArr = resUD.components(separatedBy: ",")
        let day: Int = Int(fullTimeEventArr[0])!
        let time: String = fullTimeEventArr[1]
        
        let res = TimeEvent(day: day, time: time)
        
        return res
    }
    
    class func setNotificationTimeEventByUserDefaults(id: Int, timeEvent: TimeEvent){
        
        var key = GlobalConstants.notificationTimeEventKeyUserDefaults0
        
        switch id {
        case 0:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults0
        case 1:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults1
        case 2:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults2
        default:
            break
        }
        
        let save = String(timeEvent.day) + "," + timeEvent.time
        UserDefaults.standard.set(save, forKey: key)
    }
    
}
