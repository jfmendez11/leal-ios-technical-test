//
//  DataManager.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

/// Protocol to handle data fetches
protocol DataDelegate{
    func didUpdateData(model: Codable)
    func didFailWithError(_ error: Error)
}

/// Data manager to handle API Requests
struct DataManager <Model: Codable> {
    //MARK: Properties
    var delegate: DataDelegate?
    
    //MARK: Functions
    /// Fetches data with the specified endpoint
    func fetchData(from endpoint: String) {
        let urlString = K.baseURL + endpoint
        performRequest(with: urlString)
    }
    
    /// Performs an API request with the specified URL
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let data = self.parseJSON(safeData) {
                        self.delegate?.didUpdateData(model: data)
                    }
                }
            }
            task.resume()
        }
    }
    
    /// Parses the JSON obtained from the request to the model
    private func parseJSON(_ data: Data) -> Model? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(Model.self, from: data)
            
            return model
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
