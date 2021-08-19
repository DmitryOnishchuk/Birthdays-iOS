import UIKit
import ContactsUI

class MainVC: UIViewController, CNContactViewControllerDelegate, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "ContactMainTableViewCell"
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    var search = UISearchController()
    
    let userDefaultsManager = UserDefaultsManager.shared
    
    @IBAction func buttonAct(_ sender: UIButton) {
        NotificationsFunctions.updateNotificationPool()
    }
    @IBAction func settingsButtonAction(_ sender: UIBarButtonItem) {
        let mainSettingsVC = MainSettingsModuleBuilder().create()
        self.navigationController?.pushViewController(mainSettingsVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            SettingsFunctions.changeThemeByUserDefaults()
        }
        //self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.sectionFooterHeight = 0.0
        
        
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController=search
        //self.navigationItem.titleView?.isHidden = true
        //self.navigationItem.hidesSearchBarWhenScrolling = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        
        if userDefaultsManager.isFirstStart{
            userDefaultsManager.isFirstStart = false
            NotificationsFunctions.updateNotificationPool()
        }else{
            let last = userDefaultsManager.lastNotificationPoolUpdateDateTime
            
            // Обновляем пул уведомления каждый год
            if DateFunctions.getDifferenceDays(firstDate: last, secondDate: Date()) >= 364 {
                NotificationsFunctions.updateNotificationPool()
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //createActivityIndicator()
        self.updateTable()
    }
    
    @objc func updateTable(){
        //if !refreshControl.isRefreshing {
         //   activityIndicator.startAnimating()
            //ModelContactMain.shared.clearAll()
            //self.tableView.reloadData()
        //}
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {           
            ContactFunctions.requestAccess(completionHandler: self.start(accessGranted:))
        }
    }
    
    func start(accessGranted:Bool){
        if accessGranted {
            ContactFunctions.updateModelContactMain()
            
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
}


extension MainVC: UITabBarDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return ModelContactMain.shared.contactsFiltered.count
        }
        return ModelContactMain.shared.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ContactMainTableViewCell
        
        //var contact = Contact(id: "", name: "", birthday: Date(), birthdayNear: nil, daysToBirthday: -1, futureAge: -1, photo: UIImage())
        var contact:Contact
        if isSearch(){
            contact = ModelContactMain.shared.contactsFiltered[indexPath.row]
        }else{
            contact = ModelContactMain.shared.contacts[indexPath.row]
        }
        
        cell.nameLabel.text = contact.name
        cell.birthdayLabel.text = DateFunctions.dateToHumanString(contact.birthday!)
        cell.daysToBirthdayLabel.text = DateFunctions.formatDaysToBirthday(days: contact.daysToBirthday, shortName: false)
        
        cell.daysToBirthdayLabel.layer.masksToBounds = true
        cell.daysToBirthdayLabel.layer.cornerRadius = 8
        
        if contact.daysToBirthday != 0 && contact.daysToBirthday != 1 {
            cell.daysToBirthdayLabel.leftInset = 0
            cell.daysToBirthdayLabel.rightInset = 0
            cell.daysToBirthdayLabel.textColor = UIColor.lightGray
            cell.daysToBirthdayLabel.layer.backgroundColor = UIColor.clear.cgColor
        }else{
            cell.daysToBirthdayLabel.leftInset = 8
            cell.daysToBirthdayLabel.rightInset = 8
            cell.daysToBirthdayLabel.textColor = UIColor.white
            cell.daysToBirthdayLabel.layer.backgroundColor = Colors.myAccentColor?.cgColor
        }
        
        if let futureAge = contact.futureAge{
            
            let cs = AgeSettingsEnum(rawValue: UserDefaultsManager.shared.ageType) ?? .upcoming
            let currengAge = (cs == AgeSettingsEnum.current)
            if currengAge {
                cell.ageStringLabel.text = "MAIN_AGE".localized
                cell.ageLabel.text = DateFunctions.getAgeString(age: contact.getCurrentAge())
            }else{
                cell.ageStringLabel.text = "MAIN_TURNS".localized
                cell.ageLabel.text = DateFunctions.getAgeString(age: futureAge)
            }
            
            if (futureAge <= 0) {
                cell.ageStringLabel.text = ""
            } else if (contact.daysToBirthday == 0) {
                cell.ageStringLabel.text = "MAIN_AGE".localized
            }
            
            
        }else{
            cell.ageLabel.text = ""
            cell.ageStringLabel.text = ""
        }
        
        cell.photoImage.image = contact.photo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var contact:Contact
        if isSearch(){
            contact = ModelContactMain.shared.contactsFiltered[indexPath.row]
        }else{
            contact = ModelContactMain.shared.contacts[indexPath.row]
        }
        
        let vc = CNContactViewController(for: ContactFunctions.getContactFromIDfirEditing(contact.id)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarIsEmpty() -> Bool{
        return search.searchBar.text?.isEmpty ?? true
    }
    func isSearch() -> Bool {
        return search.isActive && !searchBarIsEmpty()
    }
    
    func filterSearchContacts(_ text:String){
        ModelContactMain.shared.filterContacts(text: text)
        tableView.reloadData()
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
       // AppDelegate.shared.sendNotifications(title: "Title", body: "Body")
    }
    
}
extension MainVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchContacts(searchController.searchBar.text!)
    }
}
