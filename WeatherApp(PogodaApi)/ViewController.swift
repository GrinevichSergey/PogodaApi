//
//  ViewController.swift
//  WeatherApp(PogodaApi)
//
//  Created by Сергей Гриневич on 30/03/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var presedLabel: UILabel!
    @IBOutlet weak var himmidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var appirientTempLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicate: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func refreshButtonTapt(_ sender: UIButton) {
        toogleActivityIndicate(on: true)
        getCurrentWeatherData()
    }
    
    func toogleActivityIndicate(on: Bool)
    {
        refreshButton.isHidden = on
        
        if on {
            activityIndicate.startAnimating()
        }
        else
        {
            activityIndicate.stopAnimating()
        }
    }
    lazy var weatherManager = APIWeatherManager(apiKey: "5ce775a35200f116fdfcf7ea950eb251")
    let coordinates = Coordinates(latitude: 55.826782, longitude: 37.501565)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentWeatherData()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        print("hello word")
        print("new print")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        
        print("my location latitude: \(userLocation.coordinate.longitude), longitude: \(userLocation.coordinate.latitude)")
    }
    
    func getCurrentWeatherData() {
        
 weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            self.toogleActivityIndicate(on: false)
            switch result {
            case .Succes(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            default: break
            }
        }
        
    }
    
    
    func updateUIWith(currentWeather: CurrentWether) {
        self.imageView.image = currentWeather.icon
        self.presedLabel.text = currentWeather.pressureString
        self.himmidityLabel.text = currentWeather.humididyString
        self.tempLabel.text = currentWeather.tempString
        self.appirientTempLabel.text = currentWeather.appirientString

    }
    
}


