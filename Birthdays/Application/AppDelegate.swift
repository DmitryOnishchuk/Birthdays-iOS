import UIKit
import UserNotifications
import Toast_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var userDefaultsManager: UserDefaultsManager = UserDefaultsManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DependencyManager {
            Module { self.userDefaultsManager }
        }.build()
        
        configureToastUI()
        
        loadView()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { _, _ in })
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}


extension AppDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var mainVC: MainVC {
        return window!.rootViewController as! MainVC
    }
    
    private func configureToastUI() {
        var style = ToastManager.shared.style
        style.titleAlignment = .center
        style.messageAlignment = .center
        ToastManager.shared.style = style
    }
    
    func loadView() {
        Bundle.setLanguage(userDefaultsManager.currentLanguage)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainModuleBuilder().create()
        window?.makeKeyAndVisible()
        window?.tintColor = Colors.accentColor
    }
}

// выводим print только для разработчиков
func print(_ items: Any...) {
    #if DEBUG
    Swift.print(items.first ?? "NIL")
    #endif
}
