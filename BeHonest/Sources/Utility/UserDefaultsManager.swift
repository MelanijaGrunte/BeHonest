import Foundation

final public class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    static public let shared = UserDefaultsManager()

    private init() {
        guard
            let defaultSettingsPath = Bundle.main.path(forResource: "DefaultSettings", ofType: "plist"),
            let defaultSettings = NSDictionary(contentsOfFile: defaultSettingsPath) as? [String: Any]
        else {
            print("Failure registering DefaultSettings")
            return
        }
        userDefaults.register(defaults: defaultSettings)
    }

    public func set(_ value: String, forKey key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
        userDefaults.synchronize()
    }

    public func remove(forKey key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    public func string(forKey key: Key) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
}

// MARK: - Key

public extension UserDefaultsManager {
    enum Key: String {
        case firstQuestionAnswer = "FirstQuestionAnswer"
    }
}
