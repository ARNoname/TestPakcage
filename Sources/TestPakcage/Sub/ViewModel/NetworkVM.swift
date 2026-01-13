import Network
import SwiftUI
import Combine

@MainActor
class NetworkVM: ObservableObject {
    
    @Published var isError: Bool = false
    @Published var isConnected: Bool = true
    @Published var connectionType: NWInterface.InterfaceType = .other
    @Published var isExpensive: Bool = false
    @Published var isConstrained: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isExpensive = path.isExpensive
                self?.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.wifi, .wiredEthernet, .cellular]
                self?.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}

