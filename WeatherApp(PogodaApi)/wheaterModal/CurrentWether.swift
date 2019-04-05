//
//  CurrentWether.swift
//  WeatherApp(PogodaApi)
//
//  Created by Сергей Гриневич on 30/03/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWether {
    let temperature: Double
    let appearentTemperature: Double
    let humididy: Double
    let pressure: Double
    let icon: UIImage
}

extension CurrentWether: JSONDecodable{
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temperature"] as? Double,
        let appearentTemperature = JSON["apparentTemperature"] as? Double,
            let humididy = JSON["humidity"] as? Double,
        let pressure = JSON["pressure"] as? Double,
            let iconString = JSON["icon"] as? String else {
                return nil
        }
        let icon = WeathericonManager(rawValue: iconString).image
        
        self.temperature = temperature
        self.appearentTemperature = appearentTemperature
        self.humididy = humididy
        self.pressure = pressure
        self.icon = icon
    }
    
    
}

extension CurrentWether {
    var pressureString : String {
        return "\(Int(pressure * 0.750062))mm"
    }
    var humididyString : String {
        return "\(Int(humididy * 100))%"
    }
    var tempString: String
    {
        return "\(Int(5/9 * (temperature - 32)))˚C"
    }
    
    var appirientString : String {
        return " Ощущается как \(Int(5/9 * (appearentTemperature - 32)))˚C"
    }
    
}
