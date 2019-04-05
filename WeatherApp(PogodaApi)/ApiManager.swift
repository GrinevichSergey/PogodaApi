//
//  ApiManager.swift
//  WeatherApp(PogodaApi)
//
//  Created by Сергей Гриневич on 31/03/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

enum APIResult<T> {
    case Succes(T)
    case Failure(Error)
}

protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}

protocol ApiManager {
    var sessionConfig: URLSessionConfiguration {get}
    var session: URLSession {get}
    
    func JsonTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request : URLRequest, parse: @escaping ([String : AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
 
}

protocol FinalURLPoint {
    var baseURL: URL {get}
    var path: String {get}
    var request: URLRequest {get}
    
}



extension ApiManager {
    func JsonTaskWith(request: URLRequest, completionHandler:  @escaping JSONCompletionHandler) -> JSONTask {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else
            {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: SWINetWorkingErrorDomain, code: 100, userInfo: userInfo)
                
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil
            {
                if let error = error {
                    completionHandler(nil, httpResponse, error)
                }
            }
            else
            {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let json = try  JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completionHandler(json, httpResponse, nil )
                    }
                    catch let error as NSError {
                        completionHandler(nil, httpResponse, error)
                    }
                default:
                    print("We have got response status \(httpResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request : URLRequest, parse: @escaping ([String : AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        
        let dataTask = JsonTaskWith(request: request) { (json, response, error) in
            
            DispatchQueue.main.async(execute: {
                guard let json = json else {
                    if let error = error {
                        completionHandler(.Failure(error))
                    }
                    return
                }
                
                if let value = parse(json)
                {
                    completionHandler(.Succes(value))
                }
                else
                {
                    let error = NSError(domain: SWINetWorkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.Failure(error))
                    
                }
            })
   
        }
        dataTask.resume()
    }
    
}
