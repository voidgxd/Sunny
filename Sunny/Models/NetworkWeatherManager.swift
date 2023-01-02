//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Максим Мосалёв on 02.01.2023.
//  Copyright © 2023 Ivan Akulov. All rights reserved.
//

import Foundation

struct NetworkWeatherManager {
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)"
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                    
                }
            }
        }
        task.resume()
    }
    
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData:currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
}
