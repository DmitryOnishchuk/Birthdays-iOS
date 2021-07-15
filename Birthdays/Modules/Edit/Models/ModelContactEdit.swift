import Foundation
import UIKit

class ModelContactEdit{
    
    static var shared = ModelContactEdit()
    
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
    
    func sortByName(){
        if contacts.count > 1 {
            contacts =   contacts.sorted(by: { $0.name < $1.name  })
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
    }
}
