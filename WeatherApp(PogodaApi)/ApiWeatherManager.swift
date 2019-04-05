//
//  ApiWeatherManager.swift
//  WeatherApp(PogodaApi)
//
//  Created by Сергей Гриневич on 31/03/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ForecastType: FinalURLPoint {
    var baseURL: URL {
        return URL(string: "https://api.forecast.io" )!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
    
    case Current(apiKey: String, coordinates: Coordinates)
}

final class APIWeatherManager: ApiManager {
    var sessionConfig: URLSessionConfiguration
    
    lazy  var session: URLSession = {
            return URLSession(configuration: self.sessionConfig)
    }()
    
    let apiKey: String
    
    init(sessionConfig: URLSessionConfiguration, apiKey: String) {
        self.sessionConfig = sessionConfig
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String)
    {
        self.init(sessionConfig: URLSessionConfiguration.default, apiKey: apiKey)
        
    }
    
    func fetchCurrentWeatherWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<CurrentWether>) -> Void)
    {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        
        
        fetch(request: request, parse: { (json) -> CurrentWether? in
            if let dictionary = json["currently"] as? [String: AnyObject] {
             return CurrentWether(JSON: dictionary)
            }
            else {
                return nil
            }
        }, completionHandler: completionHandler )
    }
    
    
    
}
