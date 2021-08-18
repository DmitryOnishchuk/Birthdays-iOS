import Foundation
import UIKit

class NotificationsFunctions {
    
    
    class func updateNotificationPool(){
        
        print("updateNotificationPool")
        
        let userDefaults = UserDefaultsManager.shared
        
        removeAllNotifications()
        
        if userDefaults.notificationEnabled {
            let contacts = ContactFunctions.getListOfContactsWithBirthday()
            let events = SettingsFunctions.getAllTimeEvents()
            
            
            for contact in contacts {
                let age = contact.futureAge
                
                var ageString = ""
                if age != nil {
                    ageString = DateFunctions.formatAge(age!)
                }
                if (ageString != "") {
                    ageString = " (" + ageString + ")"
                    
                }
                for timeEvent in events {
                    if let date = getDateNotification(date: contact.birthdayNear!, timeEvent: timeEvent){

                        let notificationId = contact.id + "_" + String(timeEvent.day) + "_birthday"
                        let title = contact.name
                        let text = "COMMON_BIRTHDAY".localized + " " + DateFunctions.formatDaysToBirthdayNotification(timeEvent: timeEvent) + ageString
                        
                        createNotification(notificationId: notificationId, title: title, body: text, time: date)
                        userDefaults.lastNotificationPoolUpdateDateTime = Date()
                    }
                }
            }
        }
        
    }
    
    class func getDateNotification(date: Date, timeEvent: TimeEvent) -> DateComponents?{
        
        if timeEvent.day != -1 {
            let calendar = Calendar.current
            calendar.dateComponents([.year, .month, .day], from: date)
            
            let dayToNotify = Calendar.current.date(byAdding: .day, value: -timeEvent.day, to: date)
            
            let fullTimeArr = timeEvent.time.components(separatedBy:":")
            let hour: Int = Int(fullTimeArr[0])!
            let minute: Int = Int(fullTimeArr[1])!
            
            let dateToNotify = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dayToNotify!)
            let res = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateToNotify!)
            
            //print(res)
            
            return res
        }else{
            return nil
        }
    }
    
    class func createNotification(notificationId:String, title: String, body: String, time: DateComponents){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        //let notificationId = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    class func removeAllNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
