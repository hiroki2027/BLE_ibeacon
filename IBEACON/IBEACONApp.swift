
import SwiftUI

@main
struct IBEACONApp: App {
    @StateObject private var beaconManager = BeaconManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(beaconManager)
        }
    }
}
