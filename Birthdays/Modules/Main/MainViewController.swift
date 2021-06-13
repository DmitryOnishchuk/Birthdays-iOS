import UIKit
import ContactsUI

class MainViewController: UIViewController, CNContactViewControllerDelegate, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "ContactMainTableViewCell"
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    var search = UISearchController()
    
    @IBAction func buttonAct(_ sender: UIButton) {
        NotificationsFunctions.updateNotificationPool()
    }
    @IBAction func settingsButtonAction(_ sender: UIBarButtonItem) {
        let mainSettingsVC = MainSettingsModuleBuilder().create()
        self.navigationController?.pushViewController(mainSettingsVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsFunctions.changeThemeByUserDefaults()
        //self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
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
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
    }
}


extension MainViewController: UITabBarDelegate, UITableViewDataSource{

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
        
        cell.nameLabelView.text = contact.name
        cell.birthdayLabelView.text = DateFunctions.dateToHumanString(contact.birthday!)
        cell.daysToBirthdayLabelView.text = DateFunctions.formatDaysToBirthday(days: contact.daysToBirthday, shortName: false)
        
        if let futureAge = contact.futureAge{
            
            let currengAge = (SettingsFunctions.getAgeByUserDefaults() == AgeSettingsEnum.current)
            if currengAge {
                cell.ageStringLabelView.text = "MAIN_AGE".localized
                cell.ageLabelView.text = DateFunctions.getAgeString(age: contact.getCurrentAge())
            }else{
                cell.ageStringLabelView.text = "MAIN_TURNS".localized
                cell.ageLabelView.text = DateFunctions.getAgeString(age: futureAge)
            }
            
            if (futureAge <= 0) {
                cell.ageStringLabelView.text = ""
            } else if (contact.daysToBirthday == 0) {
                cell.ageStringLabelView.text = "MAIN_AGE".localized
            }
            
            
        }else{
            cell.ageLabelView.text = ""
            cell.ageStringLabelView.text = ""
        }
        
        cell.photoImageView.image = contact.photo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = ModelContactMain.shared.contacts[indexPath.row]
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
        AppDelegate.shared.sendNotifications(title: "Title", body: "Body")
    }
    
}
extension MainViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchContacts(searchController.searchBar.text!)
    }
}
