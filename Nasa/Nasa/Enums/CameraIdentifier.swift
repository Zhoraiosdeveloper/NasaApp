//
//  CameraIdentifier.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

enum CameraIdentifier: String, Decodable {
    case all     = "ALL"
    case none    = "NONE"
    case entry   = "ENTRY"
    case fhaz    = "FHAZ"
    case rhaz    = "RHAZ"
    case mast    = "MAST"
    case chemcam = "CHEMCAM"
    case mahli   = "MAHLI"
    case mardi   = "MARDI"
    case navcam  = "NAVCAM"
    case pancam  = "PANCAM"
    case minites = "MINITES"
}
