import Foundation
import UIKit

class NotificationsFunctions {
    
    
    class func updateNotificationPool(){
        
        let contacts = ContactFunctions.getListOfContactsWithBirthday()
        
        for contact in contacts {
            //print(contact.birthday)
            //print(contact.birthdayNear)
            
            let notificationId = contact.id + "test"
            
            let date = getDateNotification(date: contact.birthdayNear!, timeEvent: TimeEvent(day: 0, time: "16:31"))
            createNotification(notificationId: notificationId, title: contact.name, body: "Birthday", time: date)
        }
        
    }
    
    class func createNotification(notificationId:String, title: String, body: String, time: DateComponents){
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        //let notificationId = UUID().uuidString
        let notificationRequest = UNNotificationRequest(identifier: notificationId, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    class func getDateNotification(date: Date, timeEvent: TimeEvent) -> DateComponents{
        
        let calendar = Calendar.current
        calendar.dateComponents([.year, .month, .day], from: date)
        
        let dayToNotify = Calendar.current.date(byAdding: .day, value: -timeEvent.day, to: date)
        
        let fullTimeArr = timeEvent.time.components(separatedBy:":")
        let hour: Int = Int(fullTimeArr[0])!
        let minute: Int = Int(fullTimeArr[1])!
        
        let dateToNotify = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dayToNotify!)
        let res = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateToNotify!)
        
        print(res)
        
        return res
        
        
    }
    
}
