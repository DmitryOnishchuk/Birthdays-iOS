import Foundation
import UIKit

enum AgeSettingsEnum:String {
    case upcoming
    case current
}


class SettingsFunctions {
    
    class func changeLanguageOfApp(language:String){
        
        @Inject var userDefaultsManager: UserDefaultsManager
        
        if userDefaultsManager.currentLanguage != language {
            userDefaultsManager.currentLanguage = language
            AppDelegate.shared.loadView()
        }
    }

    @available(iOS 13.0, *)
    class func changeThemeByUserDefaults(){
        
        @Inject var userDefaultsManager: UserDefaultsManager
        
        var theme:UIUserInterfaceStyle
        switch userDefaultsManager.currentThemeID {
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
    
    @available(iOS 12.0, *)
    class func setThemeByUserDefaults(_ theme: UIUserInterfaceStyle){
        @Inject var userDefaultsManager: UserDefaultsManager
        
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
    
        userDefaultsManager.currentThemeID = save
    }
    
    class func getNotificationTimeEventByUserDefaults(id: Int) -> TimeEvent {
        
        var value = "0,10:00"
        @Inject var userDefaultsManager: UserDefaultsManager
        
        switch id {
        case 0:
            value = userDefaultsManager.notificationTimeEvent0
        case 1:
            value = userDefaultsManager.notificationTimeEvent1
        case 2:
            value = userDefaultsManager.notificationTimeEvent2
        default:
            break
        }
        
        let fullTimeEventArr = value.components(separatedBy: ",")
        let day: Int = Int(fullTimeEventArr[0])!
        let time: String = fullTimeEventArr[1]
        
        let res = TimeEvent(day: day, time: time)
        
        return res
    }
    
    class func setNotificationTimeEventByUserDefaults(id: Int, timeEvent: TimeEvent){
        
        @Inject var userDefaultsManager: UserDefaultsManager
        let save = String(timeEvent.day) + "," + timeEvent.time
        
        switch id {
        case 0:
            userDefaultsManager.notificationTimeEvent0 = save
        case 1:
            userDefaultsManager.notificationTimeEvent1 = save
        case 2:
            userDefaultsManager.notificationTimeEvent2 = save
        default:
            break
        }
    }
    
    class func getAllTimeEvents() -> [TimeEvent]{
        var res: [TimeEvent] = []
        
        for i in 0...2 {
            res.append(getNotificationTimeEventByUserDefaults(id: i))
        }
        return res
    }
    
}
