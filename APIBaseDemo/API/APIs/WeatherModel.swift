//
//  WeatherModel.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    
    let message: String?
    
    let status: Int?
    
    let date: String?
    
    let time: String?
    
    let cityInfo: CityInfoModel?
    
    let data: WeatherInfoModel?
}

struct CityInfoModel: Decodable {
    
    let city: String?
    
    let citykey: String?
    
    let parent: String?
    
    let updateTime: String?
}

struct WeatherInfoModel: Decodable {
    
    let shidu: String
    
    let pm25: Double
    
    let pm10: Double
    
    let quality: String
    
    let wendu: String
    
    let ganmao: String
    
    let forecast: [ForecastModel]
}

struct ForecastModel: Decodable {
    
    let date: String
    
    let high: String
    
    let low: String
    
    let ymd: String
    
    let week: String
    
    let sunrise: String
    
    let sunset: String
    
    let aqi: Int
    
    let fx: String
    
    let fl: String
    
    let type: String
    
    let notice: String
}
