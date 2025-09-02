import CoreLocation

class BeaconScanner: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let constraint: CLBeaconIdentityConstraint
    weak var delegate: BeaconScannerDelegate?

    override init() {
        // Swift では UUID 型として標準で用意
        let uuid = UUID(uuidString: "12345678-1234-1234-1234-123456789ABC")!
        constraint = CLBeaconIdentityConstraint(uuid: uuid)
      
        
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        let region = CLBeaconRegion(uuid: uuid, identifier: "com.example.suretigai")
        locationManager.startMonitoring(for: region)
    }

    // 権限確認
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways: print("位置情報: Always ✅")
        case .authorizedWhenInUse: print("位置情報: WhenInUse ⚠️（BG制限あり）")
        case .denied: print("位置情報: Denied 🚫")
        default: break
        }
    }

    // 領域検知でレンジングON/OFF
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Beacon領域に入りました")
        manager.startRangingBeacons(satisfying: constraint)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Beacon領域から出ました")
        manager.stopRangingBeacons(satisfying: constraint)
    }

    // 距離推定
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        guard !beacons.isEmpty else { return }
        if let nearest = beacons.sorted(by: { $0.accuracy < $1.accuracy }).first {
            let distance = nearest.accuracy >= 0 ? String(format: "%.2fm", nearest.accuracy) : "不明"
            print("検出: major=\(nearest.major), minor=\(nearest.minor), proximity=\(nearest.proximity.rawValue), 距離≈\(distance), RSSI=\(nearest.rssi)")
        }
    }
}
