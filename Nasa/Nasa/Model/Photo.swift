//
//  Photo.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

struct Photo: Decodable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: URL
    let earthDate: Date
    let rover: Rover
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imgSrc    = "img_src"
        case earthDate = "earth_date"
        case rover
    }
    
    struct Camera: Decodable {
        let id:       Int
        let name:     CameraIdentifier
        let roverID:  Int
        let fullName: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case roverID  = "rover_id"
            case fullName = "full_name"
        }
    }
    
    struct Rover: Decodable {
        let id: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id   = "id"
            case name = "name"
        }
    }
}

