//
//  APIClient.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

import Foundation

final class APIClient {
    
    let apiKey = "6MjIrngMJQ9xfuT49tye2Rew1sz4SR3QFIBWfSfY"
    
    static let shared = APIClient()
    
    let baseURL = URL(string: "https://api.nasa.gov/mars-photos/api/v1/")!
    let decoder = JSONDecoder()
    
    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    enum Endpoint {
        case curiosityPhotos, opportunityPhotos, spiritPhotos
        case curiosityManifest, opportunityManifest, spiritManifest
        
        func path() -> String {
            switch self {
            case .curiosityManifest:
                return "manifests/curiosity"
            case .opportunityManifest:
                return "manifests/opportunity"
            case .spiritManifest:
                return "manifests/spirit"
            case .curiosityPhotos:
                return "rovers/curiosity/photos"
            case .opportunityPhotos:
                return "rovers/opportunity/photos"
            case .spiritPhotos:
                return "rovers/spirit/photos"
            }
        }
    }
    
    func GET<T: Decodable>(endpoint: Endpoint,
                           params: [String: String]?,
                           completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let url = makeURL(endpoint: endpoint, params: params)
        
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
    
    private func makeURL(endpoint: Endpoint, params: [String: String]?) -> URL {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        
        return components.url!
    }
}
