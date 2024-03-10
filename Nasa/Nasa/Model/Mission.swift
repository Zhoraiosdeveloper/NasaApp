//
//  Mission.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

struct Mission: Decodable {
    let photoManifest: PhotoManifest
    
    enum CodingKeys: String, CodingKey {
        case photoManifest = "photo_manifest"
    }
}
