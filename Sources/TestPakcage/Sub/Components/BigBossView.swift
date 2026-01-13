
import SwiftUI

public struct BigBossView: ViewModifier {

    @State private var showSecAlert: Bool = false
    @State private var bigBossInput: String = ""
    @State private var showErrorAlert: Bool = false
    
    @Binding var isSecField: Bool
    let managerIAP: ManagerIAP

    public init(isSecField: Binding<Bool>, managerIAP: ManagerIAP) {
        self._isSecField = isSecField
        self.managerIAP = managerIAP
    }
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: isSecField) {_, newValue in
                if newValue {
                    showSecAlert = true
                    isSecField = false
                }
            }
            .alert("Enter value", isPresented: $showSecAlert) {
                TextField("Vlaue", text: $bigBossInput)
                Button("Cancel", role: .cancel) {
                    bigBossInput = ""
                }
                Button("Confirm") {
                    if bigBossInput == AppConstants.bigBossValue {
                        managerIAP.bigBoss = true
                        let calendar = Calendar.current
                        if let futureDate = calendar.date(byAdding: .year, value: 100, to: Date()) {
                            managerIAP.subEndDate = futureDate
                        }
                    } else {
                        showErrorAlert = true
                    }
                    bigBossInput = ""
                }
            } message: {
                Text("Enter the value to activate hidden features")
            }
            .alert("Invalid Value", isPresented: $showErrorAlert) {
                Button("OK") { }
            } message: {
                Text("The key you entered is incorrect. Please try again.")
            }
    }
}

extension View {
  public func bigBoss(isSecField: Binding<Bool>, managerIAP: ManagerIAP) -> some View {
        modifier(BigBossView(
            isSecField: isSecField,
            managerIAP: managerIAP
        ))
    }
}
