//
//  ViewController.swift
//  Toilet
//
//  Created by yukihiro moriyama on 2015/03/06.
//  Copyright (c) 2015年 YukihiroMoriyama. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    var gmaps : GMSMapView!
    var lm: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawGoogleMaps()
        drawToiletOnMaps()
        settingCurrentLocation()
    }

    /* トイレのJSONデータの取得 */
    func getToiletData() -> JSON {
        let path = NSBundle.mainBundle().pathForResource("toilet_osaka", ofType: "json")
        let data :NSData = NSData(contentsOfFile: path!)!
        let json = JSON(data: data)
        return json
    }
    
    /* 地図の表示 */
    func drawGoogleMaps() {
        gmaps = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        gmaps.myLocationEnabled = true
        gmaps.delegate = self
        
        var now :GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(
            34.686316,
            longitude: 135.519711,
            zoom: 16
        )
        
        gmaps.camera = now
        
        self.view.addSubview(gmaps)
    }
    
    /* トイレをマッピングする */
    func drawToiletOnMaps() {
        let toiletData = getToiletData()
        for (key: String, subJSON: JSON) in toiletData {
            var location: [Double]!
            var name: String!
            
            /* TODO: リファクタリング */
            if var latStr = subJSON["latitude"].string {
                if var longStr = subJSON["longitude"].string {
                    if var name = subJSON["facility"].string {
                        createMarker(
                            ((latStr as NSString).doubleValue) as CLLocationDegrees,
                            longitude: ((longStr as NSString).doubleValue) as CLLocationDegrees,
                            name: name
                        );
                    }
                }
            }
        }
    }
    
    /* マーカー作成 */
    func createMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String) {
        let marker: GMSMarker = GMSMarker ()
        marker.position = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        marker.snippet = name
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.icon = UIImage(named: "toilet-mini")
        marker.map = gmaps
    }
    
    /* 現在位置の取得 */
    func settingCurrentLocation() {
        lm = CLLocationManager()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 300
        lm.startUpdatingLocation()
    }
    
    /* 位置情報の取得成功時 */
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        println("test")
        
        /* 現在位置を地図上に表示 */
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: newLocation.coordinate.latitude,
            longitude: newLocation.coordinate.longitude
        )
        
        var now :GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(
            coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: 17
        )
        
        gmaps.camera = now
        
        /* 現在位置にマッピング */
//        let marker: GMSMarker = GMSMarker ()
//        marker.position = now.target
//        marker.snippet = "現在位置だよー"
//        marker.appearAnimation = kGMSMarkerAnimationPop;
//        marker.map = gmaps;
    }

    /* 位置情報の取得失敗時 */
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println("error")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

