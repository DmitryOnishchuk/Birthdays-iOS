import UIKit

class MainSettingsTableVC: UITableViewController {
    
    @IBOutlet var settingsTabelView: UITableView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
  //  @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var notificationEnableLabel: UILabel!
    @IBOutlet weak var remindersLabel: UILabel!
    @IBOutlet weak var helpTranslateLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

    @IBOutlet weak var currentLanguageLabel: UILabel!
    @IBOutlet weak var currentThemeLabel: UILabel!
    @IBOutlet weak var currentAgeLabel: UILabel!
    @IBOutlet weak var notificationEnableSwitch: UISwitch!
    
    @IBOutlet weak var remindersTableViewCell: UITableViewCell!
    let userDefaultsManager = UserDefaultsManager.shared
    
  //  @IBOutlet weak var currentNotificationTimeLabel: UILabel!
    
   // private var datePickerNotificationTime: UIDatePicker?
   // private var dummyTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(self.settingsTabelView.sectionHeaderHeight)
        //self.settingsTabelView.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0);
        notificationEnableSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad()
    }
    
    func onLoad(){
        self.title = "SETTINGS_SETTINGS".localized
        languageLabel.text = "SETTINGS_LANGUAGE".localized
        themeLabel.text = "SETTINGS_THEME".localized
        ageLabel.text = "SETTINGS_CONTACT_AGE_TYPE".localized
        notificationEnableLabel.text = "ENABLE".localized
        remindersLabel.text = "SETTINGS_NOTIFICATION_REMINDERS".localized
      //  notificationTimeLabel.text = "SETTINGS_NOTIFICATION_TIME_REMIND".localized
        helpTranslateLabel.text = "SETTINGS_ABOUT_HELP_TRANSLATE".localized
        feedbackLabel.text = "SETTINGS_ABOUT_FEEDBACK".localized
        shareLabel.text = "SETTINGS_ABOUT_SHARE".localized
        aboutLabel.text = "SETTINGS_ABOUT_ABOUT".localized
        
        setCurrentLanguageLabel()
        setCurrentThemeLabel()
        setCurrentAgeLabel()
        setStatusNotificationEnableSwitch()
        //setCurrentNotificationTimeLabel()
        setVersionInfo()
        
    }
    
    func setVersionInfo(){
        versionLabel.text = "SETTINGS_ABOUT_VERSION".localized + " " + Utils.getAppVersion()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        // Язык
        case [0, 0]:
            let languageSettingsVC = LanguageSettingsModuleBuilder().create()
            self.navigationController?.pushViewController(languageSettingsVC, animated: true)
        // Тема
        case [0, 1]:
            if #available(iOS 13.0, *) {
                let themeSettingsVC = ThemeSettingsModuleBuilder().create()
                self.navigationController?.pushViewController(themeSettingsVC, animated: true)
            } else {
                // Fallback on earlier versions
            }
        // Возраст контакта
        case [0, 2]:
            let ageTypeSettingsVC = AgeTypeSettingsModuleBuilder().create()
            self.navigationController?.pushViewController(ageTypeSettingsVC, animated: true)
        // Уведомления вкл/выкл
        case [1, 0]:
            break
        // Уведомления
        case [1, 1]:
            print("remindersTableViewCell.isUserInteractionEnabled " + String(remindersTableViewCell.isUserInteractionEnabled))
            if remindersTableViewCell.isUserInteractionEnabled {
                let notificationSettingsVC = NotificationSettingsModuleBuilder().create()
                self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
            }
        // Помощь в переводе
        case [2, 0]:
            openTranslateLink()
        // Обратная связь
        case [2, 1]:
            openEmail()
        case [2, 2]:
            share()
        default: break
        }
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        switch(section) {
        case 0: return "SETTINGS_TITLE_MAIN".localized
        case 1: return "SETTINGS_NOTIFICATION_TITLE".localized
        case 2: return "SETTINGS_ABOUT_APPLICATION_TITLE".localized
        default :return ""
            
        }
    }
    
    func openTranslateLink(){
        Utils.openURLLink(link: URLs.translateURL)
    }
    
    func openEmail(){
        Utils.openEmail(email: URLs.feedbackEmail)
    }
    
    func share(){
        let textToShare = [ Utils.getAppName() + " " + URLs.appStoreURL]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setCurrentThemeLabel(){
        let ud = userDefaultsManager.currentThemeID
        switch ud {
        case 0:
            currentThemeLabel.text = "SETTINGS_THEME_SYSTEM_DEFAULT".localized
            break
        case 1:
            currentThemeLabel.text = "SETTINGS_THEME_LIGHT".localized
            break
        case 2:
            currentThemeLabel.text = "SETTINGS_THEME_DARK".localized
            break
        default:
            currentThemeLabel.text = "SETTINGS_THEME_SYSTEM_DEFAULT".localized
            break
        }
    }
    
    func setCurrentLanguageLabel(){
        switch userDefaultsManager.currentLanguage {
        case "en":
            currentLanguageLabel.text = "ENGLISH".localized
        case "de":
            currentLanguageLabel.text = "GERMANY".localized
        case "ru":
            currentLanguageLabel.text = "RUSSIAN".localized
        case "pl":
            currentLanguageLabel.text = "POLISH".localized
        case "uk":
            currentLanguageLabel.text = "UKRAINIAN".localized
        default:
            currentLanguageLabel.text = "ENGLISH".localized
        }
    }
    
    func setCurrentAgeLabel(){
        let ageSetting = AgeSettingsEnum(rawValue: userDefaultsManager.ageType) ?? .upcoming
        switch ageSetting {
        case AgeSettingsEnum.upcoming:
            currentAgeLabel.text = "SETTINGS_CONTACT_AGE_TYPE_UPCOMING".localized
        case AgeSettingsEnum.current:
            currentAgeLabel.text = "SETTINGS_CONTACT_AGE_TYPE_CURRENT".localized
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        userDefaultsManager.notificationEnabled = mySwitch.isOn
        remindersTableViewCell.enable(on: mySwitch.isOn)
    }
    
    func setStatusNotificationEnableSwitch(){
        notificationEnableSwitch.setOn(userDefaultsManager.notificationEnabled, animated: true)
        notificationEnableSwitch.sendActions(for: .valueChanged)
        remindersTableViewCell.enable(on: userDefaultsManager.notificationEnabled)
    }
    

    
//    func setCurrentNotificationTimeLabel(){
//        let notificationTimeString = userDefaultsManager.notificationTime
//        currentNotificationTimeLabel.text = notificationTimeString
//    }
    
    //    func changeNotificationTime(){
    //        dummyTextField = UITextField()
    //        datePickerNotificationTime = UIDatePicker()
    //        if #available(iOS 13.4, *) {
    //            datePickerNotificationTime?.preferredDatePickerStyle = .wheels
    //        }
    //
    //
    //        view.addSubview(dummyTextField!)
    //        dummyTextField?.inputView = datePickerNotificationTime
    //        datePickerNotificationTime?.datePickerMode = .time
    //
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "HH:mm"
    //        let date = dateFormatter.date(from: UserDefaultsManager.shared.notificationTime)
    //        datePickerNotificationTime!.date = date!
    //
    //
    //        let localeID = Locale.preferredLanguages.first
    //        datePickerNotificationTime?.locale = Locale(identifier: localeID!)
    //        let toolbar = UIToolbar();
    //        toolbar.sizeToFit()
    //        let doneButton = UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(donedatePicker))
    //        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //        let cancelButton = UIBarButtonItem(title: "CANCEL".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
    //
    //        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
    //
    //        dummyTextField!.inputAccessoryView = toolbar
    //        dummyTextField!.becomeFirstResponder()
    //    }
    
    //    @objc func donedatePicker(){
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "HH:mm"
    //
    //        let time = formatter.string(from: datePickerNotificationTime!.date)
    //        UserDefaultsManager.shared.notificationTime = time
    //        setCurrentNotificationTimeLabel()
    //
    //        self.view.endEditing(true)
    //    }
    
    //    @objc func cancelDatePicker(){
    //        self.view.endEditing(true)
    //    }
}
