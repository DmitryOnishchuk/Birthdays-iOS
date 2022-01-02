import Foundation
import UIKit

class NotificationsFunctions {
    
    
    class func updateNotificationPool(){
        
        print("updateNotificationPool")
        
        @Inject var userDefaultsManager: UserDefaultsManager
        
        removeAllNotifications()
        
        if userDefaultsManager.notificationEnabled {
            let contacts = ContactFunctions.getListOfContactsWithBirthday()
            let events = SettingsFunctions.getAllTimeEvents()
            
            
            for contact in contacts {
                for timeEvent in events {
                
                    if var date = getDateNotification(date: contact.birthdayNear!, timeEvent: timeEvent){

                        var age = contact.futureAge
                        
                        // Переносим дату на след год, если дата уведомление раньше текущей даты
                        var d = Calendar.current.date(from: date)
                        if d! < Date(){
                            var dateComponent = DateComponents()
                            dateComponent.year = 1
                            d = Calendar.current.date(byAdding: dateComponent, to: d!)
                            date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: d!)
                            
                            // Добавляем 1 год к возрасту контакту
                            if let a = age {
                                age = a + 1
                            }else{
                                age = 1
                            }
                        }
                        
                        var ageString = ""
                        if age != nil {
                            ageString = DateFunctions.formatAge(age!)
                        }
                        if (ageString != "") {
                            ageString = " (" + ageString + ")"
                            
                        }
                        
                        let notificationId = contact.id + "_" + String(timeEvent.day) + "_birthday"
                        let title = contact.name
                        let text = "COMMON_BIRTHDAY".localized + " " + DateFunctions.formatDaysToBirthdayNotification(timeEvent: timeEvent) + ageString
                        
                        createNotification(notificationId: notificationId, title: title, body: text, time: date)
                        userDefaultsManager.lastNotificationPoolUpdateDateTime = Date()
                    }
                }
            }
        }
        
    }
    
    class func getDateNotification(date: Date, timeEvent: TimeEvent) -> DateComponents?{
        
        if timeEvent.day != -1 {
            let dayToNotify = Calendar.current.date(byAdding: .day, value: -timeEvent.day, to: date)
            
            let fullTimeArr = timeEvent.time.components(separatedBy:":")
            let hour: Int = Int(fullTimeArr[0])!
            let minute: Int = Int(fullTimeArr[1])!
            
            // Устанавливаем время (часы, минуты, секунды)
            var dateToNotify = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dayToNotify!)
            let res = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateToNotify!)
            
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
