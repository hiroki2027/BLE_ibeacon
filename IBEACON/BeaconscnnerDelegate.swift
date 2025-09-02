import CoreLocation

protocol BeaconScannerDelegate: AnyObject {
    func beaconScanner(_ scanner: BeaconScanner, didRangeBeacons beacons: [CLBeacon])
    func beaconScanner(_ scanner: BeaconScanner, didUpdateAuthorization status: CLAuthorizationStatus)
}
