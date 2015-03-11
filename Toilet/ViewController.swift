//
//  ViewController.swift
//  Toilet
//
//  Created by yukihiro moriyama on 2015/03/06.
//  Copyright (c) 2015年 YukihiroMoriyama. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    var gmaps : GMSMapView!
    var lm: CLLocationManager!
    var toiletData: JSON!
//    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_maoudamashii_toire", ofType: "mp3")!)
//        audioPlayer = AVAudioPlayer(contentsOfURL: sound_data, error: nil)
        
        toiletData = getToiletData()
        
        drawGoogleMaps()
        settingCurrentLocation()
    }

//    @IBAction func play() {
//        audioPlayer.play()
//    }
    
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
            zoom: 13
        )
        
        gmaps.camera = now
        
        self.view.addSubview(gmaps)
    }
    
    /* トイレをマッピングする */
    func drawToiletOnMaps(now: CLLocation) {
        for (key: String, subJSON: JSON) in toiletData {
            var location: [Double]!
            
            let latStr = subJSON["latitude"].string
            let longStr = subJSON["longitude"].string
            let name = subJSON["facility"].string
            
            switch (latStr, longStr, name) {
            case (.Some(let la), .Some(let lo), .Some(let n)):
                let lat = ((la as NSString).doubleValue)
                let lon = ((lo as NSString).doubleValue)
                
                let toToilet: CLLocation = CLLocation(latitude: lat, longitude: lon)
                let distance = toToilet.distanceFromLocation(now)
                println(distance)
                println(distance < 500)
                
                if distance < 500 {
                    createMarker(lat, longitude: lon, name: n)
                } else {
                    println("not marker")
                }
                
                break
            default:
                println("error")
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
        gmaps.clear()
        
        drawToiletOnMaps(newLocation)
        
//        for (key: String, subJSON: JSON) in toiletData {
//            let latStr = subJSON["latitude"].string
//            let longStr = subJSON["longitude"].string
//            
//            switch (latStr, longStr) {
//            case (.Some(let la), .Some(let lo)):
//                let lat = ((la as NSString).doubleValue)
//                let lon = ((lo as NSString).doubleValue)
//                let toToilet: CLLocation = CLLocation(latitude: lat, longitude: lon)
//                let distance = toToilet.distanceFromLocation(newLocation)
//                println(distance)
//                break
//            default:
//                println("error")
//            }
//            
//        }
        
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

