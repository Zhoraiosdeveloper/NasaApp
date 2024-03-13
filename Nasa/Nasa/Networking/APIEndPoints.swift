//
//  APIEndPoints.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 12/03/2024.
//

import Foundation

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
