
import SwiftUI
import CoreLocation
import CoreBluetooth

class BeaconManager: NSObject, ObservableObject {
    static let shared = BeaconManager()

    let scanner: BeaconScanner
    let broadcaster: BeaconBroadcaster

    @Published var isAdvertising: Bool = false
    @Published var isBluetoothPoweredOn: Bool = false
    @Published var detectedBeacons: [CLBeacon] = []
    @Published var bluetoothState: CBManagerState = .unknown

    private let uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
    private let major: CLBeaconMajorValue = 1
    private let minor: CLBeaconMinorValue = 1
    private let identifier = "com.example.myBeacon"

    override init() {
        self.scanner = BeaconScanner()
        self.broadcaster = BeaconBroadcaster(uuid: uuid, major: major, minor: minor, identifier: identifier)
        super.init()
        self.scanner.delegate = self
    }

    func startBroadcasting() {
        broadcaster.startAdvertising()
        isAdvertising = true
    }

    func stopBroadcasting() {
        broadcaster.stopAdvertising()
        isAdvertising = false
    }
}


extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        DispatchQueue.main.async {
            self.detectedBeacons = beacons
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // You may want to handle location authorization status here if needed.
    }
}

extension BeaconManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DispatchQueue.main.async {
            self.isBluetoothPoweredOn = (central.state == .poweredOn)
        }
    }
}

extension BeaconManager: BeaconScannerDelegate {
    func beaconScanner(_ scanner: BeaconScanner, didRangeBeacons beacons: [CLBeacon]) {
        DispatchQueue.main.async {
            self.detectedBeacons = beacons
        }
    }

    func beaconScanner(_ scanner: BeaconScanner, didUpdateAuthorization status: CLAuthorizationStatus) {
        // 権限変更時の処理（必要ならここに書く）
    }
}
