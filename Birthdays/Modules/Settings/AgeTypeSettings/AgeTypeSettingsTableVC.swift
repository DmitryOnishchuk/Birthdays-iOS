//
//  AgeTableViewController.swift
//  Birthdays
//
//  Created by Dima on 09.01.2021.
//

import UIKit

class AgeTypeSettingsTableVC: UITableViewController {

    // MARK: - Outlets
    @IBOutlet private weak var ageTabelView: UITableView!
    @IBOutlet private weak var upcomingLabel: UILabel!
    @IBOutlet private weak var currentLabel: UILabel!
    @IBOutlet private weak var upcomingTableViewCell: UITableViewCell!
    @IBOutlet private weak var currentTableViewCell: UITableViewCell!

    // MARK: - Variables
    @Inject private var userDefaultsManager: UserDefaultsManager
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SETTINGS_CONTACT_AGE_TYPE", comment: "")
        upcomingLabel.text = NSLocalizedString("SETTINGS_CONTACT_AGE_TYPE_UPCOMING", comment: "")
        currentLabel.text = NSLocalizedString("SETTINGS_CONTACT_AGE_TYPE_CURRENT", comment: "")
        //self.ageTabelView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0);
        setAgeCheckmark()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            userDefaultsManager.ageType = AgeSettingsEnum.upcoming.rawValue
            setAgeCheckmark()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            break
        case [0,1]:
            userDefaultsManager.ageType = AgeSettingsEnum.current.rawValue
            setAgeCheckmark()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            break
        default: break
        }
    }


    func setAgeCheckmark(){

        upcomingTableViewCell.accessoryType = .none
        currentTableViewCell.accessoryType = .none
        
       // let ud = SettingsFunctions.getAgeTypeByUserDefaults()
        let ud = AgeSettingsEnum(rawValue: userDefaultsManager.ageType) ?? .upcoming
        switch ud {
        case AgeSettingsEnum.upcoming:
            upcomingTableViewCell.accessoryType = .checkmark
            break
        case AgeSettingsEnum.current:
            currentTableViewCell.accessoryType = .checkmark
            break
        }
    }
}
