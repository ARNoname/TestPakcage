import SwiftUI

struct LocalizContainer: Codable {
    var paywallScreen: PaywallData?
    var version: String?
    var appLinks: PaywallLink?
    var splash: Splash?
    var specialOffer: SpecialOffer?
    var silentRSOC: SilentRSOC?
    var techService: TechService?
 
    init(from decoder: Decoder) throws {
        
        let dynamicContainer = try decoder.container(keyedBy: SCDynamicKey.self)
       
        var paywallItems = PaywallData()
        var versionString: String?
        var linksItems: PaywallLink?
        var splash = Splash()
        var specialOffer = SpecialOffer()
        var silentRSOC = SilentRSOC()
        var techService: TechService?
     
        for key in dynamicContainer.allKeys {
           
            if key.stringValue.contains("paywall") || key.stringValue == "paywall" {
                if let pay = try? dynamicContainer.decode(PaywallData.self, forKey: key) {
                    paywallItems = pay
                }
            }
            
            if key.stringValue == "version" {
                if let versionData = try? dynamicContainer.decode([String: String].self, forKey: key),
                   let latestVersion = versionData["latestVersion"] {
                    versionString = latestVersion
                }
            }
            
            if key.stringValue == "links" {
                if let links = try? dynamicContainer.decode(PaywallLink.self, forKey: key) {
                    linksItems = links
                }
            }
            
            if key.stringValue == "splash" {
                if let offer = try? dynamicContainer.decode(Splash.self, forKey: key) {
                    splash = offer
                }
            }
            
            if key.stringValue == "specialOffer" {
                if let offer = try? dynamicContainer.decode(SpecialOffer.self, forKey: key) {
                    specialOffer = offer
                }
            }
            
            if key.stringValue == "silentRSOCConfig" {
                if let offer = try? dynamicContainer.decode(SilentRSOC.self, forKey: key) {
                    silentRSOC = offer
                }
            }
            
            if key.stringValue == "techService" {
                if let offer = try? dynamicContainer.decode(TechService.self, forKey: key) {
                    techService = offer
                }
            }
        }
       
        self.paywallScreen = paywallItems
        self.version = versionString
        self.appLinks = linksItems
        self.splash = splash
        self.specialOffer = specialOffer
        self.silentRSOC = silentRSOC
        self.techService = techService
        
    }
}

struct SCDynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
