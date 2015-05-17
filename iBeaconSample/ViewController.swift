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
                println("承認済み")
            case .NotDetermined:
                println("未承認")
                if locationManager.respondsToSelector("requestAlwaysAuthorization") {
                    locationManager.requestAlwaysAuthorization()
                }

            default:
                println("default")
            }
            let ver:String = UIDevice.currentDevice().systemVersion
            let startIndex = advance(ver.startIndex, 0)
            let endIndex = advance(ver.startIndex, 1)
            let majorVer = ver[Range(start: startIndex, end: endIndex)]
            println(majorVer)
            if(majorVer.toInt() >= 8){
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
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("didUpdateToLocation")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            println("未承認")
        case .Restricted, .Denied:
            println("制限中")
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            println("承認済")
            break
        default:
            break
        }
    }
}

