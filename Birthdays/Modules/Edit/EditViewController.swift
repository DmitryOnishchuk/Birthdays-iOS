import UIKit
import ContactsUI

class EditViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let cellID = "ContactEditTableViewCell"
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    var search = UISearchController()
    var datePickerBirthday: UIDatePicker?
    var dummyTextField: UITextField?
    var currentContact:Contact?
    var birthdayPickerView: BirthdayPickerView!
    
    var newContact:Contact?
    var newContactBirthdayPickerView: BirthdayPickerView!
    var newContactAlertBirthday: UIAlertController!
    var nextActionName: UIAlertAction!
    var nextActionBirthday: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController=search
        //self.navigationItem.titleView?.isHidden = true
        //self.navigationItem.hidesSearchBarWhenScrolling = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //createActivityIndicator()
        self.updateTable()
    }
    
    @objc func updateTable(){
        //if !refreshControl.isRefreshing {
        //    activityIndicator.startAnimating()
        //    ModelContactEdit.shared.clearAll()
        //    self.tableView.reloadData()
        // }
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            ContactFunctions.requestAccess(completionHandler: self.start(accessGranted:))
        }
    }
    
    func start(accessGranted:Bool){
        if accessGranted {
            ContactFunctions.updateModelContactEdit()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }else{
            ContactFunctions.showSettingsAlert()
        }
    }
    
    func createActivityIndicator(){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.style = .large
        view.addSubview(activityIndicator)
    }
    
    @IBAction func addContact(_ sender: Any) {
        newContact = Contact(id: "new", name: "nil", birthday: nil, birthdayNear: nil, daysToBirthday: -1, futureAge: -1, photo: UIImage())
        setNameDialog()
    }
    
    
    func setNameDialog(){
        let alert = UIAlertController(title:"EDIT_NEW_CONTACT_TITLE".localized, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "EDIT_NAME".localized
            textField.delegate = self
            textField.clearButtonMode = .whileEditing
            textField.addTarget(self, action: #selector(self.textFieldDidChangeName(_:)), for: .editingChanged)
        }
        
        nextActionName = UIAlertAction(title: "NEXT".localized, style: .default, handler: { saveAction -> Void in
            let textField = alert.textFields![0] as UITextField
            self.newContact!.name = textField.text!
            self.setBirthdayDialog()
        })
        nextActionName.isEnabled = false
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: {
                                    (action : UIAlertAction!) -> Void in })
        
        
        alert.addAction(cancel)
        alert.addAction(nextActionName)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setBirthdayDialog(){
        
        let containerFrame = CGRect(x:10, y: 70, width: 270, height: 200)
        
        newContactBirthdayPickerView = BirthdayPickerView(frame: containerFrame)
        newContactBirthdayPickerView.delegate = newContactBirthdayPickerView
        newContactBirthdayPickerView.dataSource = newContactBirthdayPickerView
        
        newContactAlertBirthday = UIAlertController(title:"EDIT_SELECT_BIRTHDAY".localized, message: "", preferredStyle: .alert)
        
        
        let cons:NSLayoutConstraint = NSLayoutConstraint(item: newContactAlertBirthday.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: newContactBirthdayPickerView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.00, constant: 130)
        
        newContactAlertBirthday.view.addConstraint(cons)
        
        let cons2:NSLayoutConstraint = NSLayoutConstraint(item: newContactAlertBirthday.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: newContactBirthdayPickerView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.00, constant: 20)
        
        newContactAlertBirthday.view.addConstraint(cons2)
        
        
        newContactAlertBirthday.view.addSubview(newContactBirthdayPickerView)
        
        //        newContactAlertBirthday.addTextField {(textField : UITextField!) in
        //            textField.placeholder = "EDIT_SELECT_BIRTHDAY".localized
        //            textField.delegate = self
        //            textField.inputView = self.newContactBirthdayPickerView
        //
        //            textField.addTarget(self, action: #selector(self.textFieldDidChangeBirthday(_:)), for: .editingChanged)
        //
        //
        //            let toolbar = UIToolbar();
        //            toolbar.sizeToFit()
        //            let doneButton = UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(self.doneAlertDatePicker))
        //            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //            toolbar.setItems([spaceButton,doneButton], animated: true)
        //            textField!.inputAccessoryView = toolbar
        //            textField!.becomeFirstResponder()
        //        }
        
        nextActionBirthday = UIAlertAction(title: "NEXT".localized, style: .default, handler: { saveAction -> Void in
            self.newContact!.birthday = self.newContactBirthdayPickerView.date
            let resAdd = ContactFunctions.createContact(self.newContact!)
            let msg = (resAdd) ? self.newContact!.name + " " + "EDIT_ADDED".localized : "FAIL".localized
            self.showToast(message: msg, font: .systemFont(ofSize: 12.0))
            
            
            self.updateTable()
        })
        //nextActionBirthday.isEnabled = false
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: {
                                    (action : UIAlertAction!) -> Void in })
        
        
        newContactAlertBirthday.addAction(cancel)
        newContactAlertBirthday.addAction(nextActionBirthday)
        
        
        self.present(newContactAlertBirthday, animated: true, completion: nil)
        
    }
    @objc func textFieldDidChangeName(_ textField: UITextField) {
        nextActionName.isEnabled = textField.text?.count ?? 0 > 0
    }
    //@objc func textFieldDidChangeBirthday(_ textField: UITextField) {
    //    nextActionBirthday.isEnabled = textField.text?.count ?? 0 > 0
    //}
    
    @objc func doneAlertDatePicker(){
        newContactAlertBirthday.view.endEditing(true)
        newContactAlertBirthday.textFields?.first?.text = newContactBirthdayPickerView.text
        nextActionBirthday.isEnabled = newContactAlertBirthday.textFields?.first?.text?.count ?? 0 > 0
    }
    
}

extension EditViewController: UITabBarDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return ModelContactEdit.shared.contactsFiltered.count
        }
        return ModelContactEdit.shared.contacts.count
    }
    
    //func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //    return tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ContactEditTableViewCell
        
        var contact:Contact
        if isSearch(){
            contact = ModelContactEdit.shared.contactsFiltered[indexPath.row]
        }else{
            contact = ModelContactEdit.shared.contacts[indexPath.row]
        }
        
        cell.nameLabel.text = contact.name
        
        var birthdayString = ""
        if contact.birthday != nil {
            birthdayString = DateFunctions.dateToHumanString(contact.birthday!)
        }
        
        cell.birthdayLabel.text = birthdayString
        cell.photoImageView.image = contact.photo
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath)
        
        let contact = ModelContactEdit.shared.contacts[indexPath.row]
        currentContact = contact
        dummyTextField = UITextField()
        birthdayPickerView = BirthdayPickerView()
        birthdayPickerView.delegate = birthdayPickerView
        birthdayPickerView.dataSource = birthdayPickerView
        
        view.addSubview(dummyTextField!)
        dummyTextField?.inputView = birthdayPickerView
        let contactBirthday = ContactFunctions.getBirthdayDateByContactID(contact.id)
        birthdayPickerView.date = contactBirthday ?? Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(doneDatePicker))
        let centerLabel = ToolBarTitleItem(text: contact.name, font: .systemFont(ofSize: 16), color: .darkText)
        let removeButton = UIBarButtonItem(title: "DELETE".localized, style: .plain, target: nil, action: #selector(deleteDatePicker))
        let cancelButton = UIBarButtonItem(title: "CANCEL".localized, style: .plain, target: self, action:
                                            #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        if contactBirthday == nil {
            toolbar.setItems([cancelButton, spaceButton,centerLabel, spaceButton,doneButton], animated: true)
        }else{
            toolbar.setItems([cancelButton, spaceButton,removeButton, spaceButton,doneButton], animated: true)
        }
        
        dummyTextField!.inputAccessoryView = toolbar
        dummyTextField!.becomeFirstResponder()
    }
    
    
    
    
    
    
    
    
    @objc func doneDatePicker(){
        self.view.endEditing(true)
        if birthdayPickerView.date != currentContact?.birthday {
            if ContactFunctions.updateBirthdayByContactID(currentContact!.id, birthdayPickerView.date) {
                self.showToast(message: "UPDATED".localized, font: .systemFont(ofSize: 12.0))
                updateTable()
            }else{
                self.showToast(message: "FAIL".localized, font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    @objc func deleteDatePicker(){
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "EDIT_DELETE_BIRTHDAY".localized, message: currentContact?.name, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized, style: .default, handler: { [self] action in
            if action.style == .default{
                deleteCurrentContactBirthday()
            }
        })
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: { action in })
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteCurrentContactBirthday(){
        if ContactFunctions.deleteBirthdayByContactID(currentContact!.id) {
            self.showToast(message: "DELETED".localized, font: .systemFont(ofSize: 12.0))
            updateTable()
        }else{
            self.showToast(message: "FAIL".localized, font: .systemFont(ofSize: 12.0))
        }
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func searchBarIsEmpty() -> Bool{
        return search.searchBar.text?.isEmpty ?? true
    }
    func isSearch() -> Bool {
        return search.isActive && !searchBarIsEmpty()
        
    }
    
    func filterSearchContacts(_ text:String){
        ModelContactEdit.shared.filterContacts(text: text)
        tableView.reloadData()
    }
}

extension EditViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchContacts(searchController.searchBar.text!)
    }
}
