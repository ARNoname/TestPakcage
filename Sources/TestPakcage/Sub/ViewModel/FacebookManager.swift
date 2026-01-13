import Foundation
import UIKit
#if canImport(FacebookCore)
import FacebookCore

@MainActor
class FacebookManager: NSObject {
    @MainActor static let shared = FacebookManager()

    private override init() {
        super.init()
    }

    // MARK: - Initialization
    func initializeFacebook() {
        Settings.shared.isAutoLogAppEventsEnabled = true
        Settings.shared.isAdvertiserIDCollectionEnabled = false
    }

    func handleURL(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            options: options
        )
    }
}

#endif
