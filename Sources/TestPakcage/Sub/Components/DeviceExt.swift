import SwiftUI

@MainActor
extension UIDevice {
   public static var isSimulator: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
}

@MainActor
public var isPad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
}
