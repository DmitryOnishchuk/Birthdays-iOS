import UIKit

class LanguageSettingsTableVC: UITableViewController {
    
    @Inject private var userDefaultsManager: UserDefaultsManager
    
    @IBOutlet weak var englishTableViewCell: UITableViewCell!
    @IBOutlet weak var deutschTableViewCell: UITableViewCell!
    @IBOutlet weak var russianTableViewCell: UITableViewCell!
    @IBOutlet weak var polandTableViewCell: UITableViewCell!
    @IBOutlet weak var ukrainianTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SETTINGS_LANGUAGE".localized
        setLanguageCheckmark()
    }
    
    deinit {
        print("LanguageSettingsTableVC deinit")
    }
    
    func setLanguageCheckmark(){
        switch userDefaultsManager.currentLanguage {
        case "en":
            englishTableViewCell.accessoryType = .checkmark
            break
        case "de":
            deutschTableViewCell.accessoryType = .checkmark
        case "ru":
            russianTableViewCell.accessoryType = .checkmark
        case "pl":
            polandTableViewCell.accessoryType = .checkmark
        case "uk":
            ukrainianTableViewCell.accessoryType = .checkmark
        default:
            englishTableViewCell.accessoryType = .checkmark
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            changeLanguage(language: "en")
        case 1:
            break
        case 2:
            changeLanguage(language: "ru")
        case 3:
            break
        case 4:
            break
        default: break
        }
    }
    
    func changeLanguage(language: String){
        if userDefaultsManager.currentLanguage != language {
            SettingsFunctions.changeLanguageOfApp(language: language)
        }else{
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
}
