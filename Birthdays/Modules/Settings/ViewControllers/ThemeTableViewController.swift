import UIKit

class ThemeTableViewController: UITableViewController {
    
    @IBOutlet var themeTableView: UITableView!
    @IBOutlet weak var systemTableViewCell: UITableViewCell!
    @IBOutlet weak var lightTableViewCell: UITableViewCell!
    @IBOutlet weak var darkTableViewCell: UITableViewCell!
    
    @IBOutlet weak var systemDefaultLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var darkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SETTINGS_THEME".localized
        systemDefaultLabel.text = "SETTINGS_THEME_SYSTEM_DEFAULT".localized
        lightLabel.text = "SETTINGS_THEME_LIGHT".localized
        darkLabel.text = "SETTINGS_THEME_DARK".localized
        setThemeCheckmark()
        self.themeTableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0);
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            SettingsFunctions.setThemeByUserDefaults(.unspecified)
            SettingsFunctions.changeThemeByUserDefaults()
            setThemeCheckmark()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            break
        case [0,1]:
            SettingsFunctions.setThemeByUserDefaults(.light)
            SettingsFunctions.changeThemeByUserDefaults()
            setThemeCheckmark()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            break
        case [0,2]:
            SettingsFunctions.setThemeByUserDefaults(.dark)
            SettingsFunctions.changeThemeByUserDefaults()
            setThemeCheckmark()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            break
        default: break
        } 
    }
    
    func setThemeCheckmark(){
        systemTableViewCell.accessoryType = .none
        lightTableViewCell.accessoryType = .none
        darkTableViewCell.accessoryType = .none
        
        let ud = SettingsFunctions.getThemeByUserDefaults()
        switch ud {
        case 0:
            systemTableViewCell.accessoryType = .checkmark
            break
        case 1:
            lightTableViewCell.accessoryType = .checkmark
            break
        case 2:
            darkTableViewCell.accessoryType = .checkmark
            break
        default:
            darkTableViewCell.accessoryType = .checkmark
            break
        }
    }
    
}
