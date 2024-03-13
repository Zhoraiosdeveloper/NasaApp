//
//  NetworkManager.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

final class NetworkManager : NetworkManagerProtocol {
    
    func fetchMission(for rover: Rover, completionHandler: @escaping (Mission) -> Void) {
        var endpoint: Endpoint
        switch rover {
        case .curiosity:
            endpoint = .curiosityManifest
        case .opportunity:
            endpoint = .opportunityManifest
        case .spirit:
            endpoint = .spiritManifest
        }
        
        APIClient.shared.GET(endpoint: endpoint, params: nil) { (result: Result<Mission, APIError>) in
            switch result {
            case let .success(response):
                completionHandler(response)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchPhotoList(for rover: Rover, on date: Date, completionHandler: @escaping (PhotoList) -> Void) {
        var endpoint: Endpoint
        switch rover {
        case .curiosity:
            endpoint = .curiosityPhotos
        case .opportunity:
            endpoint = .opportunityPhotos
        case .spirit:
            endpoint = .spiritPhotos
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        
        APIClient.shared.GET(endpoint: endpoint, params: ["earth_date": dateString]) { (result: Result<PhotoList, APIError>) in
            switch result {
            case let .success(response):
                completionHandler(response)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchPhotoLists(for rover: Rover ,on param: [String:String], completionHandler: @escaping (PhotoList) -> Void) {
        var endpoint: Endpoint
        switch rover {
        case .curiosity:
            endpoint = .curiosityPhotos
        case .opportunity:
            endpoint = .opportunityPhotos
        case .spirit:
            endpoint = .spiritPhotos
        }
                
        APIClient.shared.GET(endpoint: endpoint, params: param) { (result: Result<PhotoList, APIError>) in
            switch result {
            case let .success(response):
                completionHandler(response)
            case let .failure(error):
                print(error)
            }
        }
    }
}
