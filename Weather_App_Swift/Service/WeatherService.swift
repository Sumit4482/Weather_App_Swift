//
//  WeatherService.swift
//  Weather_App_Swift
//
//  Created by E5000855 on 30/06/24.
//

import Foundation
import UIKit
import CoreLocation

enum ServiceError :String, Error{
    case serverError = "Network connection error"
    case decodingError = "Pages not working!"
}

struct WeatherService{
    
    let url = "https://api.openweathermap.org/data/2.5/weather?&appid=29da09b6c0524425481a64417acf537e&units=metric"
    

    
    func fetchWeatherCityName(forcityName cityName: String, completion: @escaping(Result<WeatherModel,ServiceError>)->Void){
        let url = URL(string: "\(url)&q=\(cityName)")!
       fetchWeather(url: url, completion: completion)
    }
    
    func fetchWeatherLocation(latitude: CLLocationDegrees,longitude: CLLocationDegrees , completion: @escaping(Result<WeatherModel,ServiceError>)->Void){
        let url = URL(string: "\(url)&lat=\(latitude)&lon=\(longitude)")!
       fetchWeather(url: url, completion: completion)
    }
    
    
    private func fetchWeather(url : URL ,completion: @escaping(Result<WeatherModel,ServiceError>)->Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    completion(.failure(.serverError))
                }
                guard let data = data else {return}
                guard let result = parseJSON(data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(result))
            }
            
        }.resume()
    }
    
    
    
    private func parseJSON(data : Data) -> WeatherModel?{
        do {
            let result = try JSONDecoder().decode(WeatherModel.self, from: data)
            return result
        } catch  {
            return nil
        }
    }
}




