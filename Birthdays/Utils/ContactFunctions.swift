import Foundation
import ContactsUI

class ContactFunctions {
    class func getListOfContactsWithBirthday() -> [Contact]{
        
        var res = [Contact]()
        
        let contactStore = CNContactStore()
        //var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactBirthdayKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                
                //contacts.append(contact)
                if let birthday = contact.birthday{
                    if let birthdayDate = birthday.date {
                        //print(DateFunctions.dateToHumanString(date: birthdayDate))
                        
                        let id = contact.identifier
                        let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "UNKNOWN"
                        
                        let birthdayNear = DateFunctions.getBirthdayNearNew(dateComponent: birthday)
                        let daysToBirthday = DateFunctions.getDifferenceDays(firstDate: Date(), secondDate: birthdayNear)
                        let futureAge = DateFunctions.getAge(birthdayDate: birthdayDate, birthdayNear: birthdayNear)
                        
                        var photo = UIImage(named: "avatar")
                        if contact.imageDataAvailable {
                            photo = UIImage(data: contact.thumbnailImageData!)!
                        }
                        
                        let contact = Contact(id: id,
                                              name: fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                                              birthday: birthdayDate,
                                              birthdayNear: birthdayNear,
                                              daysToBirthday: daysToBirthday,
                                              futureAge: futureAge,
                                              photo: photo!)
                        res.append(contact)
                    }
                }
                
            }
            //print(contacts)
        } catch {
            print("unable to fetch contacts")
        }
        return res
    }
    
    class func getListOfContactsEdit() -> [Contact]{
        
        var res = [Contact]()
        
        let contactStore = CNContactStore()
        //var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactBirthdayKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                
                //contacts.append(contact)
                
                
                //print(DateFunctions.dateToHumanString(date: birthdayDate))
                
                let id = contact.identifier
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "UNKNOWN"
                
                var photo = UIImage(named: "avatar")
                if contact.imageDataAvailable {
                    photo = UIImage(data: contact.thumbnailImageData!)!
                }
                let contact = Contact(id: id,
                                      name: fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                                      birthday: contact.birthday?.date,
                                      birthdayNear: nil,
                                      daysToBirthday: -1,
                                      futureAge: -1,
                                      photo: photo!)
                res.append(contact)
                
                
                
            }
            //print(contacts)
        } catch {
            print("unable to fetch contacts")
        }
        return res
    }
    
    static func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            completionHandler(false)
        case .restricted, .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                completionHandler(granted)
            }
        }
    }
    
    static func showSettingsAlert() {
        let alert = UIAlertController(title: nil, message: "ACCESS_ALERT_MESSAGE".localized, preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: "ACCESS_OPEN_SETTINGS".localized, style: .default) { action in
                //completionHandler(false)
                UIApplication.shared.open(settings)
            })
        }
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel) { action in
            //completionHandler(false)
        })
        
        DispatchQueue.main.async {
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                topController.present(alert, animated: true)
            }
        }
    }
    
    static func getContactFromID(_ contactID: String) -> CNContact? {
        let predicate = CNContact.predicateForContacts(withIdentifiers: [contactID])
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey]
        
        var contacts = [CNContact]()
        let contactsStore = CNContactStore()
        
        do {
            contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
            if contacts.count == 0 {
                return nil
            }
        }
        catch {
            print("Unable to fetch contacts.")
            return nil
        }
        
        return contacts[0]
    }
    
    static func getContactFromIDfirEditing(_ contactID: String) -> CNContact? {
        let contactStore = CNContactStore()
        var mc = CNContact()
        do {
            mc = try contactStore.unifiedContact(withIdentifier: contactID, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        }
        catch {
            return nil
        }
        
        return mc
    }
    
    static func getBirthdayDateByContactID(_ contactID: String) -> Date? {
        let contact = getContactFromIDfirEditing(contactID)
        if (contact != nil) {
            
            return contact?.birthday?.date
            
        }
        return nil
    }
    
    static func updateBirthdayByContactID(_ contactID: String, _ newBirthday: Date) -> Bool{
        do {
            let store = CNContactStore()
            let myContact = getContactFromIDfirEditing(contactID)
            
            if myContact != nil {
                let mc = myContact!.mutableCopy() as! CNMutableContact
                mc.birthday = Calendar.current.dateComponents([.year, .month, .day], from: newBirthday)
                let req = CNSaveRequest()
                req.update(mc)
                try store.execute(req)
                return true
            }
        }catch let err{
            print(err)
            return false
        }
        return false
    }
    
    static func deleteBirthdayByContactID(_ contactID: String) -> Bool{
        do {
            let store = CNContactStore()
            let myContact = getContactFromIDfirEditing(contactID)
            
            if myContact != nil {
                let mc = myContact!.mutableCopy() as! CNMutableContact
                mc.birthday = nil
                let req = CNSaveRequest()
                req.update(mc)
                try store.execute(req)
                return true
            }
        }catch let err{
            print(err)
            return false
        }
        return false
    }
    
    static func createContact(_ contact: Contact) -> Bool{
        do {
            let store = CNContactStore()
            
            let newContact = CNMutableContact()
            newContact.givenName = contact.name
            let components = Calendar.current.dateComponents([.day, .month, .year], from: contact.birthday!)
            newContact.birthday = components
            
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier: nil)
            try store.execute(saveRequest)
            return true
        }catch let err{
            print(err)
            return false
        }
    }    
}
