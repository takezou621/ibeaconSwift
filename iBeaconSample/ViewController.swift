//
//  ViewController.swift
//  iBeaconSample
//
//  Created by Kawai Takeshi on 2014/09/01.
//  Copyright (c) 2014年 Kawai Takeshi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var region: CLBeaconRegion = CLBeaconRegion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion) {
            locationManager.delegate = self
            region.notifyOnEntry = true
            region.notifyEntryStateOnDisplay = false
            
            let uuid:NSUUID = NSUUID(UUIDString: "xxxxxx-02B5-1801-86F6-001C4D269B5F")!
            
            region = CLBeaconRegion(proximityUUID: uuid, identifier: "info.swiftbeginner")
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("承認済み")
            case .NotDetermined:
                print("未承認")
                if locationManager.respondsToSelector("requestAlwaysAuthorization") {
                    locationManager.requestAlwaysAuthorization()
                }

            default:
                print("default")
            }
            let ver:String = UIDevice.currentDevice().systemVersion
            let startIndex = ver.startIndex.advancedBy(0)
            let endIndex = ver.startIndex.advancedBy(1)
            let majorVer = ver[Range(start: startIndex, end: endIndex)]
            print(majorVer)
            if(Int(majorVer) >= 8){
                // Info.plistに"NSLocationAlwaysUsageDescription"が設定していないとダイアログが表示されない
                locationManager.requestAlwaysAuthorization()
            }else{
                locationManager.startRangingBeaconsInRegion(region)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // CLLocationManager Delegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("didUpdateToLocation")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            print("未承認")
        case .Restricted, .Denied:
            print("制限中")
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            print("承認済")
        }
    }
}

