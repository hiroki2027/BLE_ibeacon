
import CoreBluetooth
import CoreLocation

class BeaconBroadcaster: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager?
    private var beaconRegion: CLBeaconRegion?

    let uuid: UUID
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    let identifier: String

    private var isAdvertising = false

    init(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.identifier = identifier
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func startAdvertising() {
        guard let peripheralManager = peripheralManager else {
            print("Peripheral manager is not initialized.")
            return
        }

        if peripheralManager.state != .poweredOn {
            print("Bluetooth is not powered on. Current state: \(peripheralManager.state.rawValue)")
            return
        }

        if isAdvertising {
            print("Already advertising.")
            return
        }

        beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
        let peripheralData = beaconRegion!.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising(peripheralData as? [String: Any])
        isAdvertising = true
        print("iBeacon advertising started with UUID: \(uuid.uuidString), major: \(major), minor: \(minor), identifier: \(identifier)")
    }

    func stopAdvertising() {
        guard let peripheralManager = peripheralManager else {
            print("Peripheral manager is not initialized.")
            return
        }

        if !isAdvertising {
            print("Not currently advertising.")
            return
        }

        peripheralManager.stopAdvertising()
        isAdvertising = false
        print("iBeacon advertising stopped.")
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Bluetooth powered on.")
        case .poweredOff:
            print("Bluetooth powered off.")
            if isAdvertising {
                stopAdvertising()
            }
        case .resetting:
            print("Bluetooth resetting.")
        case .unauthorized:
            print("Bluetooth unauthorized.")
        case .unsupported:
            print("Bluetooth unsupported.")
        case .unknown:
            print("Bluetooth state unknown.")
        @unknown default:
            print("Bluetooth state unknown default.")
        }
    }
}
    
