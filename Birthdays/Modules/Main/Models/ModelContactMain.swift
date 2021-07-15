import Foundation
import UIKit

class ModelContactMain{
    
    static var shared = ModelContactMain()
    
    var contacts = [Contact]()
    var contactsFiltered = [Contact]()
 
    func addAll(items: [Contact]){
        contacts.removeAll()
        contacts.append(contentsOf: items)
    }
    
    func clearAll(){
        contacts.removeAll()
        contactsFiltered.removeAll()
    }
    
    func sortByBirthday(){
        if contacts.count > 1 {
            contacts =   contacts.sorted(by: { $0.daysToBirthday < $1.daysToBirthday })
        }
    }
    
    func filterContacts(text:String){
        contactsFiltered.removeAll()
        contactsFiltered = contacts.filter({ (contact) -> Bool in
            return contact.name.lowercased().contains(text.lowercased())
        })
    }
    
   private init() {
        setup()
    }
    
    func setup(){
        //ContactFunctions.updateModelContactMain()
        //let date = Date()
        //let calendar = Calendar.current
        //let contact1 = Contact(id: "0", name: "Юрий", birthday: date, birthdayNear: date, daysToBirthday:1,futureAge:20, image: UIImage(named: "avatar")!)
        //let contact2 = Contact(id: "1", name: "Евгений", birthday: date, birthdayNear: date, daysToBirthday:1,futureAge:20, image: UIImage(named: "avatar")!)
        
        //contacts.append(contact1)
        //contacts.append(contact2)
    }
}
