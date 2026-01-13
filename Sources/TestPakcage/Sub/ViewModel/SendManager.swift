import Combine
import Foundation
import UIKit
import AdServices

@MainActor
class SendManager: ObservableObject {
    @MainActor  static let shared = SendManager()
    
    @Published var modelResponse: ResponseModel?
    @Published var showUpdateAlert = false
    
    let config = AppConfig.shared
    
    var deviceID: String
    private var deviceType: String
    
     init() {
        self.deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        self.deviceType = deviceTypeIdentifier()
    }
    
    var pageOnboarding: String {
        return "\(config.onboardKey)-\(config.paywallKey)"
    }
        
    // MARK: - Status Endpoint
    func sendStatus() async {

        let request = RequestModel(
            deviceId: deviceID,
            deviceType: deviceType,
            lang: "en"
        )
        await sendRequest(endpoint: .status, request: request, version: true)
    }
    
    // MARK: - Paywall View Endpoint
    func sendPaywallView() async {
    
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .view, request: request)
    }
    
    // MARK: - Conversion Endpoint
    func sendConversion() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        
        await sendRequest(endpoint: .conversion, request: request)
    }
    
    // MARK: - View Number Endpoint
    func sendViewNumber(pageNumber: Int) async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType,
            number: "\(pageNumber)"
        )
        await sendRequest(endpoint: .view, request: request)
    }
    
    // MARK: - New  Methods
    func sendLockedSwipe() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .lockedSwipe, request: request)
    }
    
    func sendRsocScreen1View() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .rsocScreen1View, request: request)
    }
    
    func sendRsocScreen2View() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .rsocScreen2View, request: request)
    }
    
    func sendRsocScreen3View() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .rsocScreen3View, request: request)
    }
    
    func sendRsocCrossClick() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .rsocCrossClick, request: request)
    }
    
    func sendSpecialOfferView() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .specialOfferView, request: request)
    }
    
    func sendSpecialOfferCtaClick() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .specialOfferCtaClick, request: request)
    }
    
    func sendSpecialOfferCrossClick() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .specialOfferCrossClick, request: request)
    }
    
    func sendPaymentPopupClosed() async {
   
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .paymentPopupClosed, request: request)
    }
    
    // MARK: - Silent RSOC  Methods
    func sendSilentRSOCScreen1() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .silentRSOCScreen1, request: request)
    }
    
    func sendSilentRSOCScreen2() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .silentRSOCScreen2, request: request)
    }
    
    func sendSilentRSOCSponsorPageLoad() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .silentRSOCSponsorPageLoad, request: request)
    }
    
    func sendSilentRSOCSponsorPageVisible() async {
        let request = RequestModel(
            deviceId: deviceID,
            page: pageOnboarding,
            deviceType: deviceType
        )
        await sendRequest(endpoint: .silentRSOCSponsorPageVisible, request: request)
    }
    
    // MARK: - Swipe Paywall Config
      func fetchSwipePaywallConfig(onboardingKey: String, paywallKey: String) async -> ResponseModel? {
      
          guard let url = buildSwipeConfigURL(onboardingKey: onboardingKey, paywallKey: paywallKey) else {
              print("Failed to build URL for swipe paywall config")
              return nil
          }

          print("Swipe Paywall Config URL: \(url)")
          
          var urlRequest = URLRequest(url: url)
          urlRequest.httpMethod = "GET"
          
          do {
              let (data, response) = try await URLSession.shared.data(for: urlRequest)
              if let httpResponse = response as? HTTPURLResponse {
                  print("Swipe paywall config request completed with status: \(httpResponse.statusCode)")
                  if let responseData = try? JSONDecoder().decode(ResponseModel.self, from: data) {
                      print("Swipe Paywall Response: \(responseData)")
                      return responseData
                  }
              }
          } catch {
              print("Swipe paywall config request failed: \(error.localizedDescription)")
          }
          
          return nil
      }
      
      private func buildSwipeConfigURL(onboardingKey: String, paywallKey: String) -> URL? {
      
          var components = URLComponents(string: RequestEndPoint.swipePaywallConfig.fullURL)
          
          let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "onboarding", value: onboardingKey),
              URLQueryItem(name: "paywall", value: paywallKey)
          ]
          
          components?.queryItems = queryItems
          
          return components?.url
      }
    
    // MARK: - Private Helper Methods
    private func sendRequest(endpoint: RequestEndPoint, request: RequestModel, version: Bool = false) async {

        guard let url = buildURL(endpoint: endpoint, request: request) else {
            print("Failed to build URL for endpoint: \(endpoint.rawValue)")
            return
        }

        print("Final URL with GET parameters: \(url)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Analytics GET request to \(endpoint.rawValue) completed with status: \(httpResponse.statusCode)")
                
                if let responseData = try? JSONDecoder().decode(ResponseModel.self, from: data) {
                    print("Response: \(responseData)")
                    
                    await MainActor.run {
                        self.modelResponse = responseData
                        
                    }
                    
                    if version {
                       await checkForUpdate(model: responseData)
                    }
                }
            }
        } catch {
            print("Analytics GET request failed for \(endpoint.rawValue): \(error.localizedDescription)")
        }
    }
    
    private func buildURL(endpoint: RequestEndPoint, request: RequestModel) -> URL? {
   
        var components = URLComponents(string: endpoint.fullURL)
        
        var queryItems: [URLQueryItem] = []
        
        if let deviceId = request.deviceId {
            queryItems.append(URLQueryItem(name: "device_id", value: deviceId))
        }
        if let page = request.page {
            queryItems.append(URLQueryItem(name: "page", value: page))
        }
        if let deviceType = request.deviceType {
            queryItems.append(URLQueryItem(name: "device_type", value: deviceType))
        }
        if let number = request.number {
            queryItems.append(URLQueryItem(name: "number", value: number))
        }
        
        queryItems.append(URLQueryItem(name: "lang", value: request.lang))
        
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        
        return components?.url
    }
    
    // MARK: - Version Checker
     func checkForUpdate(model: ResponseModel) async {
    
            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
            guard let latestVersion = model.localization?.version else { return }
                    
            if shouldShowUpdateAlert(currentVersion: currentVersion, latestVersion: latestVersion) {
                await MainActor.run {
                    self.showUpdateAlert = true
                }
            }
        }
     
    
    // MARK: - Version Comparison Helper
    private func shouldShowUpdateAlert(currentVersion: String, latestVersion: String) -> Bool {
    
        let currentComponents = parseVersion(currentVersion)
        let latestComponents = parseVersion(latestVersion)
        
        if latestComponents.major > currentComponents.major {
            return true
        }
 
        if latestComponents.major == currentComponents.major && latestComponents.minor > currentComponents.minor {
            return true
        }
   
        return false
    }
    
    private func parseVersion(_ version: String) -> (major: Int, minor: Int, patch: Int) {
   
        let components = version.split(separator: ".").compactMap { Int($0) }
        
        let major = components.count > 0 ? components[0] : 0
        let minor = components.count > 1 ? components[1] : 0
        let patch = components.count > 2 ? components[2] : 0
        
        return (major, minor, patch)
    }
}

func deviceTypeIdentifier() -> String {
 
    var systemInfo = utsname()
    uname(&systemInfo)

    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }

    return identifier
}
