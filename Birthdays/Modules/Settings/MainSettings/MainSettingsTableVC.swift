import UIKit

final class MainSettingsTableVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var settingsTabelView: UITableView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var themeLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var notificationEnableLabel: UILabel!
    @IBOutlet private weak var remindersLabel: UILabel!
    @IBOutlet private weak var helpTranslateLabel: UILabel!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var shareLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    
    @IBOutlet private weak var currentLanguageLabel: UILabel!
    @IBOutlet private weak var currentThemeLabel: UILabel!
    @IBOutlet private weak var currentAgeLabel: UILabel!
    @IBOutlet private weak var notificationEnableSwitch: UISwitch!
    
    @IBOutlet private weak var remindersTableViewCell: UITableViewCell!
    
    // MARK: - Variables
    @Inject private var userDefaultsManager: UserDefaultsManager
    
    //  @IBOutlet weak var currentNotificationTimeLabel: UILabel!
    
    // private var datePickerNotificationTime: UIDatePicker?
    // private var dummyTextField: UITextField?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
        // print(self.settingsTabelView.sectionHeaderHeight)
        //self.settingsTabelView.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0);
    }
    
    deinit {
        print("MainSettingsTableVC deinit")
    }
    
    func onLoad(){
        notificationEnableSwitch.addTarget(self, action: #selector(notificationEnableSwitchChanged), for: .valueChanged)
        
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
}

// MARK: - Methods
extension MainSettingsTableVC {

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
        case [2, 3]:
            about()
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
        showToast(msg: URLs.feedbackEmail + " " + "SETTINGS_ABOUT_COPIED".localized)
        UIPasteboard.general.string = URLs.feedbackEmail
        Utils.openEmail(email: URLs.feedbackEmail)
    }
    
    func share(){
        showLoadingIndicator()
        
        let textToShare = [ Utils.getAppName() + " " + URLs.appStoreURL ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        //avoiding to crash on iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        hideLoadingIndicator()
        self.present(activityViewController, animated: true){
            print("TEST")
        }
    }
    
    func about(){
        let aboutVC = AboutModuleBuilder().create()
        present(aboutVC, animated: true, completion: nil)
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
    
    @objc func notificationEnableSwitchChanged(mySwitch: UISwitch) {
        notificationEnabledChanged(status: mySwitch.isOn)
        NotificationsFunctions.updateNotificationPool()
    }
    
    func setStatusNotificationEnableSwitch(){
        notificationEnableSwitch.setOn(userDefaultsManager.notificationEnabled, animated: true)
        notificationEnabledChanged(status:notificationEnableSwitch.isOn)
        remindersTableViewCell.enable(on: userDefaultsManager.notificationEnabled)
    }
    
    func notificationEnabledChanged(status:Bool){
        userDefaultsManager.notificationEnabled = status
        remindersTableViewCell.enable(on: status)
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
