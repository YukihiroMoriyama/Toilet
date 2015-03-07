//
//  ViewController.swift
//  Toilet
//
//  Created by yukihiro moriyama on 2015/03/06.
//  Copyright (c) 2015年 YukihiroMoriyama. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    var gmaps : GMSMapView!
    var lm: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* 地図の表示 */
        //        let lat: CLLocationDegrees = 37.508435
        //        let lon: CLLocationDegrees = 139.930696
        //        let zoom: Float = 15
        //        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat,longitude: lon,zoom: zoom);
        
        gmaps = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        //        gmaps.camera = camera
        gmaps.myLocationEnabled = true
        gmaps.delegate = self
        self.view.addSubview(gmaps)
        
        /* 現在位置の取得 */
        /* TODO: 現在位置情報の取得不可 */
        lm = CLLocationManager()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 300
        lm.startUpdatingLocation()
    }
    
    /* 位置情報の取得成功時 */
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        NSLog("success")
        
        /* 現在位置を地図上に表示 */
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:newLocation.coordinate.latitude,longitude:newLocation.coordinate.longitude)
        var now :GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(coordinate.latitude,longitude:coordinate.longitude,zoom:17)
        gmaps.camera = now
        
        /* マーカーの作成 */
        let marker: GMSMarker = GMSMarker ()
        marker.position = now.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = gmaps;
    }

    /* 位置情報の取得失敗時 */
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("error")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

