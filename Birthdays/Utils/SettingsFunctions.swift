import Foundation
import UIKit

enum AgeSettingsEnum:String {
    case upcoming
    case current
}


class SettingsFunctions {
    
    class func changeLanguageOfApp(language:String){
        
        if getCurrentLanguage() != language {
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.setLanguage(language)
            //AppDelegate.shared.loadWindows()
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
    
    class func getCurrentLanguage()->String{
        let lng = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? ""
        let lngArr = lng.components(separatedBy: "-")
        var res = lngArr[0]
        
        if res.isEmpty {
            res = Locale.current.languageCode!
        }
        return res
    }
    
    
    class func changeThemeByUserDefaults(){
        var theme:UIUserInterfaceStyle
        switch getThemeByUserDefaults() {
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
    
    class func getThemeByUserDefaults() -> Int{
        return UserDefaults.standard.integer(forKey: GlobalConstants.themeKeyUserDefaults)
    }
    
    class func getAgeByUserDefaults() -> AgeSettingsEnum{
        guard let res = UserDefaults.standard.value(forKey: GlobalConstants.ageKeyUserDefaults) as? String else {
            return AgeSettingsEnum.upcoming
        }
        return AgeSettingsEnum(rawValue: res)!
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
        UserDefaults.standard.set(save, forKey: GlobalConstants.themeKeyUserDefaults)
    }
    
    class func setAgeByUserDefaults(age: AgeSettingsEnum){
        UserDefaults.standard.set(age.rawValue, forKey: GlobalConstants.ageKeyUserDefaults)
    }
    
    class func getNotificationTimeByUserDefaults()->String{
        guard let res = UserDefaults.standard.value(forKey: GlobalConstants.notificationTimeKeyUserDefaults) as? String else {
            return "10:00"
        }
        return res
    }
    
    class func setNotificationTimeByUserDefaults(_ time: String){
        UserDefaults.standard.set(time, forKey: GlobalConstants.notificationTimeKeyUserDefaults)
    }
    
    class func getNotificationTimeEventByUserDefaults(id: Int) -> TimeEvent {
        
        var defaultValue = TimeEvent(day: -1, time: "10:00")
        var key = GlobalConstants.notificationTimeEventKeyUserDefaults0
        
        switch id {
        case 0:
            key = GlobalConstants.notificationTimeEventKeyUserDefaults0
            defaultValue =  TimeEvent(day: 0, time: "10:00")
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
