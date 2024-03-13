//
//  APIClient.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

import Foundation

final class APIClient {
    
    static let shared = APIClient()
    
    let decoder = JSONDecoder()
    var makeURLFunc = MakeAURL()
    
    func GET<T: Decodable>(endpoint: Endpoint,
                           params: [String: String]?,
                           completionHandler: @escaping (Result<T, APIError>) -> Void) {
        
        let url = makeURLFunc.makeURL(endpoint: endpoint, params: params)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let object = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
        }
        task.resume()
    }
}
