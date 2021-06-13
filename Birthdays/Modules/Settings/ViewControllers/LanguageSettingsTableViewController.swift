import UIKit

class LanguageSettingsTableViewController: UITableViewController {
    
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
    
    func setLanguageCheckmark(){
        let langStr = SettingsFunctions.getCurrentLanguage()
        
        switch langStr {
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
            SettingsFunctions.changeLanguageOfApp(language: "en")
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        case 1:
            break
        case 2:
            SettingsFunctions.changeLanguageOfApp(language: "ru")
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        case 3:
            break
        case 4:
            break
        default: break
        }
    }
}
