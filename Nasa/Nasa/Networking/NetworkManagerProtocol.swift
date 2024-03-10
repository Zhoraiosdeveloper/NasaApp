//
//  NetworkManagerProtocol.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchMission(for rover: Rover, completionHandler: @escaping (Mission) -> Void)
    func fetchPhotoList(for rover: Rover, on date: Date, completionHandler: @escaping (PhotoList) -> Void)
    func fetchPhotoLists(for rover: Rover,on param: [String:String], completionHandler: @escaping (PhotoList) -> Void)
}

