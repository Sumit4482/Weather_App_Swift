//
//  WeatherViewModel.swift
//  Weather_App_Swift
//
//  Created by E5000855 on 30/06/24.
//

import Foundation

struct WeatherViewModel{
    let id: Int
    let city: String
    let temperature : Double
    
    init(weatherModel: WeatherModel){
        self.id = weatherModel.weather[0].id
        self.city = weatherModel.name
        self.temperature = weatherModel.main.temp
    }
    
    var temperatureString: String?{
        return String(format: "%.0f", temperature)
    }
    var statusName:String{
        switch id{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
