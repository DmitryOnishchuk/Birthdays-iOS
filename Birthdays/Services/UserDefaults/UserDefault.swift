import Foundation
import UIKit

fileprivate extension UserDefaults {
	
	class var shared: UserDefaults { .standard }
	
}

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T?
    
    private(set) var storedValue: T?
    
    init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            guard storedValue == nil else { return storedValue }
            guard let object = UserDefaults.shared.object(forKey: key) as? T else { return defaultValue }
            return object
        }
        set {
            storedValue = newValue
            if newValue == nil {
                UserDefaults.shared.removeObject(forKey: key)
            } else {
                UserDefaults.shared.set(newValue, forKey: key)
            }
            UserDefaults.shared.synchronize()
        }
    }
    
}

@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    
    let key: String
    let defaultValue: T?
    
    private(set) var storedValue: T?
    
    init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            guard storedValue == nil else { return storedValue }
            guard let data = UserDefaults.shared.data(forKey: key) else { return defaultValue }
			do {
				return try JSONDecoder().decode(T.self, from: data)
			} catch {
                print(error)
				return defaultValue
			}
        }
        set {
            storedValue = newValue
            if newValue == nil {
                UserDefaults.shared.removeObject(forKey: key)
            } else {
                do {
                    let t = try JSONEncoder().encode(newValue)
                    UserDefaults.shared.set(t, forKey: key)
                    UserDefaults.shared.synchronize()
                } catch {
                    print(error)
                }
            }
        }
    }
    
}
