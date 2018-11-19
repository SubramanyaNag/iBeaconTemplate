//
//  AppDelegate.swift
//  iBeaconTemplateSwift
//
//  Created by subramanya on 20/01/16.
//  Copyright © 2015 subramanya. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
                            
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let uuidString = "F94DBB23-2266-7822-3782-57BEAC0952AC"
        let beaconIdentifier = "0117C55DFB8D"
        let beaconUUID = NSUUID(UUIDString: uuidString)!
        print("this is before beacon")
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        print("This is clbeacon")
        print("the uuid:\(beaconRegion.proximityUUID)")
        print("the major:\(beaconRegion.major) and minor:\(beaconRegion.minor)")
//        var becn:CLBeacon?
//        print(becn?.proximityUUID)
//        print("becon is nil: \(becn?.rssi)")
        
        locationManager = CLLocationManager()
        print("this is cllocationmanagaer")

        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            if #available(iOS 8.0, *) {
                locationManager!.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
            }
        }
            
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        print("this also works?")
        locationManager!.startMonitoringForRegion(beaconRegion)
        print("here monitoring starts")
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        print("here it starts to range for beacons")
        locationManager!.startUpdatingLocation()
            
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            if #available(iOS 8.0, *) {
                print("sahflkas")
                application.registerUserNotificationSettings(
                    UIUserNotificationSettings(
                        forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound],
                        categories: nil
                    )
                )
                print("sahlashfashf")
            } else {
                // Fallback on earlier versions
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate {
	func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        print("111")
		
		if(playSound) {
			// classic star trek communicator beep
			//	http://www.trekcore.com/audio/
			//
			// note: convert mp3 and wav formats into caf using:
			//	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
			// http://stackoverflow.com/a/10388263

			notification.soundName = "beep.caf";
		}
        print("something something")
		
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        inRegion region: CLBeaconRegion) {
            
            print("the beacons have ranged")
            let navVC = window?.rootViewController as! UINavigationController
            let viewController:ViewController = navVC.topViewController as! ViewController
            viewController.beacons = beacons as [CLBeacon]?
            viewController.tableView!.reloadData()
            
            NSLog("didRangeBeacons");
            var message:String = ""
			
			var playSound = false
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] 
                
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    message = "You are far away from the beacon"
					playSound = true
                case CLProximity.Near:
                    message = "You are near the beacon"
                case CLProximity.Immediate:
                    message = "You are in the immediate proximity of the beacon"
                case CLProximity.Unknown:
                    return
                }
            } else {
				
				if(lastProximity == CLProximity.Unknown) {
					return;
            
				}
				
                if #available(iOS 8.0, *) {
                    let alertBox = UIAlertController(title: "No Beacons Found", message: "Can't find any beacons in the area.\nPlease try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertBox.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    viewController.presentViewController(alertBox, animated: true, completion: nil)
                }
                message = "No beacons are nearby"
				playSound = true
				lastProximity = CLProximity.Unknown
            }
			
            NSLog("%@", message)
			sendLocalNotificationWithMessage(message, playSound: playSound)
    }
    
    func locationManager(manager: CLLocationManager,
        didEnterRegion region: CLRegion) {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.startUpdatingLocation()
        
            NSLog("You entered the region")
            sendLocalNotificationWithMessage("You entered the region", playSound: false)
    }
    
    func locationManager(manager: CLLocationManager,
        didExitRegion region: CLRegion) {
            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            sendLocalNotificationWithMessage("You exited the region", playSound: true)
    }
}

