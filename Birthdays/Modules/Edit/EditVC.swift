import UIKit
import ContactsUI
import NVActivityIndicatorView

final class EditVC: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var activityIndicatorEdit: NVActivityIndicatorView!
    private let cellID = "ContactEditTableViewCell"
    private var activityIndicator = UIActivityIndicatorView()
    private var refreshControl = UIRefreshControl()
    private var search = UISearchController()
    private var datePickerBirthday: UIDatePicker?
    private var dummyTextField: UITextField?
    private var currentContact:Contact?
    private var birthdayPickerView: BirthdayPickerView!
    private var emptyListEditLabel: UILabel!
    
    private var newContact:Contact?
    private var newContactBirthdayPickerView: BirthdayPickerView!
    private var newContactAlertBirthday: UIAlertController!
    private var nextActionName: UIAlertAction!
    private var nextActionBirthday: UIAlertAction!
    
    private var contacts = [Contact]()
    private var contactsFiltered = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateBirthdaysEdit()
    }
    
    func onLoad(){
        self.title = "EDIT_TITLE".localized
        
        //self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        editTableView.refreshControl = refreshControl
        editTableView.tableFooterView = UIView(frame: CGRect.zero)
        editTableView.sectionFooterHeight = 0.0
        
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController=search
        refreshControl.addTarget(self, action: #selector(updateBirthdaysEdit), for: .valueChanged)
        
        emptyListEditLabel = UILabel(frame: CGRect(x: 0,
                                                   y: -100,
                                                   width: self.editTableView.bounds.size.width,
                                                   height: self.editTableView.bounds.size.height))
        emptyListEditLabel.text = "EDIT_IS_EMPTY_MESSAGE".localized
        emptyListEditLabel.textAlignment = .center
        emptyListEditLabel.numberOfLines = 0
        emptyListEditLabel.font = .systemFont(ofSize: 16)
        emptyListEditLabel.textColor = UIColor(red: 50/255, green: 54/255, blue: 67/255, alpha: 1)
        
        activityIndicatorEdit.type = .circleStrokeSpin
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(resumeFromBackgroundEdit), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(resumeFromBackgroundEdit), name:UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    deinit {
        print("EditVC deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func resumeFromBackgroundEdit(_ notification: Notification) {
        self.updateBirthdaysEdit()
    }
    
    @objc func updateBirthdaysEdit(){
        print("updateBirthdaysEdit")
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
            
            DispatchQueue.main.sync {
                self.activityIndicatorEdit.startAnimating()
            }
            
            updateModelContactEdit()
            
            DispatchQueue.main.async {
                if self.isSearch(){
                    self.filterContacts(text: self.search.searchBar.text!)
                }
                
                self.editTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicatorEdit.stopAnimating()
                self.activityIndicator.stopAnimating()
                self.checkEmptyLabel()
            }
        }else{
            ContactFunctions.showSettingsAlert()
        }
    }
    
    func updateModelContactEdit(){
        addAll(items: ContactFunctions.getListOfContactsEdit())
        sortByName()
    }
    
    func addAll(items: [Contact]){
        contacts.removeAll()
        contacts.append(contentsOf: items)
    }
    
    func sortByName(){
        if contacts.count > 1 {
            contacts = contacts.sorted(by: { $0.name < $1.name  })
        }
    }
    
    func filterContacts(text:String){
        contactsFiltered.removeAll()
        contactsFiltered = contacts.filter({ (contact) -> Bool in
            return contact.name.lowercased().contains(text.lowercased())
        })
    }
    
    func createActivityIndicator(){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.style = .large
        view.addSubview(activityIndicator)
    }
    
    func checkEmptyLabel(){
        editTableView.backgroundView = contacts.isEmpty ? emptyListEditLabel : nil
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
        
        
        let cons:NSLayoutConstraint = NSLayoutConstraint(item: newContactAlertBirthday.view, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: newContactBirthdayPickerView, attribute: .height, multiplier: 1.00, constant: 130)
        
        newContactAlertBirthday.view.addConstraint(cons)
        
        let cons2:NSLayoutConstraint = NSLayoutConstraint(item: newContactAlertBirthday.view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: newContactBirthdayPickerView, attribute: .width, multiplier: 1.00, constant: 20)
        
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
            self.showToast(message: msg)
            
            
            self.updateBirthdaysEdit()
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

extension EditVC: UITabBarDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return contactsFiltered.count
        }
        return contacts.count
    }
    
    //func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //    return tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ContactEditTableViewCell
        
        var contact:Contact
        if isSearch(){
            contact = contactsFiltered[indexPath.row]
        }else{
            contact = contacts[indexPath.row]
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
        
        var contact:Contact
        if isSearch(){
            contact = contactsFiltered[indexPath.row]
        }else{
            contact = contacts[indexPath.row]
        }
        
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
                self.showToast(message: "UPDATED".localized)
                updateBirthdaysEdit()
                NotificationsFunctions.updateNotificationPool()
            }else{
                self.showToast(message: "FAIL".localized)
            }
        }
    }
    
    @objc func deleteDatePicker(){
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "EDIT_DELETE_BIRTHDAY".localized, message: currentContact?.name, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized, style: .default, handler: { [self] action in
            if action.style == .default{
                deleteCurrentContactBirthday()
                NotificationsFunctions.updateNotificationPool()
            }
        })
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: { action in })
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteCurrentContactBirthday(){
        if ContactFunctions.deleteBirthdayByContactID(currentContact!.id) {
            self.showToast(message: "DELETED".localized)
            updateBirthdaysEdit()
        }else{
            self.showToast(message: "FAIL".localized)
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
        filterContacts(text: text)
        editTableView.reloadData()
    }
}

extension EditVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchContacts(searchController.searchBar.text!)
    }
}
