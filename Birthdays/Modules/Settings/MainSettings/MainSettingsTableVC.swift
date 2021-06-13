import UIKit

class MainSettingsTableVC: UITableViewController {
    
    @IBOutlet var settingsTabelView: UITableView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    @IBOutlet weak var currentLanuageLabel: UILabel!
    @IBOutlet weak var currentThemeLabel: UILabel!
    @IBOutlet weak var currentAgeLabel: UILabel!
    @IBOutlet weak var currentNotificationTimeLabel: UILabel!
        
    private var datePickerNotificationTime: UIDatePicker?
    private var dummyTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(self.settingsTabelView.sectionHeaderHeight)
        self.settingsTabelView.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0);

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad()
    }
    
    func onLoad(){
        self.title = "SETTINGS_SETTINGS".localized
        languageLabel.text = "SETTINGS_LANGUAGE".localized
        themeLabel.text = "SETTINGS_THEME".localized
        ageLabel.text = "SETTINGS_CONTACT_AGE".localized
        notificationTimeLabel.text = "SETTINGS_NOTIFICATION_TIME_REMIND".localized
        
        setCurrentLanuageLabel()
        setCurrentThemeLabel()
        setCurrentAgeLabel()
        setCurrentNotificationTimeLabel()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1, 0]:
            changeNotificationTime()
        default: break
        }
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        switch(section) {
        case 0: return "SETTINGS_TITLE_MAIN".localized
        case 1: return "SETTINGS_NOTIFICATION_TITLE".localized
            
        default :return ""
            
        }
    }
    
    func setCurrentThemeLabel(){
        let ud = SettingsFunctions.getThemeByUserDefaults()
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
    
    func setCurrentLanuageLabel(){
        let langStr = SettingsFunctions.getCurrentLanguage()
        switch langStr {
        case "en":
            currentLanuageLabel.text = "ENGLISH".localized
        case "de":
            currentLanuageLabel.text = "GERMANY".localized
        case "ru":
            currentLanuageLabel.text = "RUSSIAN".localized
        case "pl":
            currentLanuageLabel.text = "POLISH".localized
        case "uk":
            currentLanuageLabel.text = "UKRAINIAN".localized
        default:
            currentLanuageLabel.text = "ENGLISH".localized
        }
    }
    
    func setCurrentAgeLabel(){
        let ageSetting = SettingsFunctions.getAgeByUserDefaults()
        switch ageSetting {
        case AgeSettingsEnum.upcoming:
            currentAgeLabel.text = "SETTINGS_CONTACT_AGE_UPCOMING".localized
        case AgeSettingsEnum.current:
            currentAgeLabel.text = "SETTINGS_CONTACT_AGE_CURENT".localized
        default:
            currentAgeLabel.text = "SETTINGS_CONTACT_AGE_UPCOMING".localized
        }
    }
    
    func setCurrentNotificationTimeLabel(){
        let notificationTimeString = SettingsFunctions.getNotificationTimeByUserDefaults()
        currentNotificationTimeLabel.text = notificationTimeString
    }
    
    func changeNotificationTime(){
        dummyTextField = UITextField()
        datePickerNotificationTime = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePickerNotificationTime?.preferredDatePickerStyle = .wheels
        }


        view.addSubview(dummyTextField!)
        dummyTextField?.inputView = datePickerNotificationTime
        datePickerNotificationTime?.datePickerMode = .time
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: SettingsFunctions.getNotificationTimeByUserDefaults())
        datePickerNotificationTime!.date = date!
        
        
        let localeID = Locale.preferredLanguages.first
        datePickerNotificationTime?.locale = Locale(identifier: localeID!)
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "CANCEL".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        dummyTextField!.inputAccessoryView = toolbar
        dummyTextField!.becomeFirstResponder()
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let time = formatter.string(from: datePickerNotificationTime!.date)
        SettingsFunctions.setNotificationTimeByUserDefaults(time)
        setCurrentNotificationTimeLabel()
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
