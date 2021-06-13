import Foundation
import UIKit

class Contact: NSObject{
    
    var id: String
    var name: String
    var birthday: Date?
    var birthdayNear: Date?
    var daysToBirthday: Int
    var futureAge: Int?
    var photo: UIImage
    
    func getCurrentAge()->Int{
        var res = futureAge
        if daysToBirthday != 0 {
            res = res! - 1
        }
        return res!
    }
    
    init(id:String,
         name:String,
         birthday:Date?,
         birthdayNear:Date?,
         daysToBirthday:Int,
         futureAge: Int,
         photo: UIImage){
        self.id = id
        self.name = name
        self.birthday = birthday
        self.birthdayNear = birthdayNear
        self.daysToBirthday = daysToBirthday
        self.futureAge = futureAge
        self.photo = photo
    }
}
