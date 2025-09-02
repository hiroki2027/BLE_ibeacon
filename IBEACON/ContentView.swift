import SwiftUI
import CoreLocation
import CoreBluetooth

extension CBManagerState {
    var asText: String {
        switch self {
        case .unknown: return "不明"
        case .resetting: return "リセット中"
        case .unsupported: return "非対応"
        case .unauthorized: return "未許可"
        case .poweredOff: return "OFF"
        case .poweredOn: return "ON"
        @unknown default: return "未知"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var beaconManager: BeaconManager

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    PeripheralSection(beaconManager: beaconManager)
                    CentralSection(beaconManager: beaconManager)
                }
            }
            .navigationTitle("iBeacon デモ")
        }
    }
}

struct PeripheralSection: View {
    @ObservedObject var beaconManager: BeaconManager

    var body: some View {
        Section(header: Text("発信 (Peripheral)")) {
            Button(action: {
                if beaconManager.isAdvertising {
                    beaconManager.stopBroadcasting()
                } else {
                    beaconManager.startBroadcasting()
                }
            }) {
                Text(beaconManager.isAdvertising ? "停止" : "開始")
            }
            Text("状態: \(beaconManager.isAdvertising ? "発信中" : "停止中")")
                .foregroundColor(beaconManager.isAdvertising ? .green : .red)
        }
    }
}

struct CentralSection: View {
    @ObservedObject var beaconManager: BeaconManager

    var body: some View {
        Section(header: Text("検出 (Central)")) {
            Text("Bluetooth 状態: \(beaconManager.bluetoothState.asText)")
            List {
                ForEach(beaconManager.detectedBeacons, id: \.self) { beacon in
                    VStack(alignment: .leading) {
                        Text("UUID: \(beacon.uuid.uuidString)")
                        Text("Major: \(beacon.major)")
                        Text("Minor: \(beacon.minor)")
                        Text(String(format: "推定距離: %.2f m", beacon.accuracy))
                    }
                }
            }
        }
    }
}
