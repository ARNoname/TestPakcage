import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct InfoButtonView: View {
    @EnvironmentObject var managerIAP: ManagerIAP
        
    var body: some View {
        HStack {
            ButtonApp(action: {
                if let url = URL(string: AppConstants.termsOfUse) {
                    UIApplication.shared.open(url)
                }
            }, label: {
                if AppConfig.shared.payType == .bob {
                    Text(InfoButton.termsOfService.title)
                       
                } else {
                    Text(InfoButton.termsOfService.title)
                }
            })
            
            Spacer()
            
            ButtonApp(action: {
                if let url = URL(string: AppConstants.privacyPolicy) {
                    UIApplication.shared.open(url)
                }
            }, label: {
                if AppConfig.shared.payType == .bob {
                    Text(InfoButton.privacyPolicy.title)
                } else {
                    Text(InfoButton.privacyPolicy.title)
                }
            })
            
            Spacer()
            
            ButtonApp(action: {
                 Task {
                     await managerIAP.restore()
                 }
             }, label: {
                 if AppConfig.shared.payType == .bob {
                     Text(InfoButton.restore.title)
                      
                 } else {
                     Text(InfoButton.restore.title)
                 }
             })
        }
        .fontApp(.semibold, 12)
        .foregroundStyle(AppConfig.shared.payType == .bob ? Color.black : Color.graySubColors)
        .padding(.bottom)
    }
}
#endif
