//
//  MakeAURL.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 12/03/2024.
//

import Foundation

class MakeAURL {
    let nasaPhotoURL = URL(string: baseURL)!

     func makeURL(endpoint: Endpoint, params: [String: String]?) -> URL {
        let queryURL = nasaPhotoURL.appendingPathComponent(endpoint.path())
        
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
