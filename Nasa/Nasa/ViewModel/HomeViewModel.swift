//
//  HomeViewModel.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    let networkManager: NetworkManagerProtocol
    
    @Published var missions: [Rover: Mission] = [:]
    @Published var photos = [Photo] ()
    @Published var apiCalled = false 
    @Published var apiResponse = false
    @Published var useFilter = false
    
    @Published var isShowingDatePicker = false
    @Published var seletedDate  = ""
    @Published var rover  = ""
    @Published var camera  = ""
    @Published var selectedRover: Rover = .curiosity {
        didSet {
            dateRange = getDateRange()
            availableCameras = getAvailableCameras()
            selectedDate = dateRange.upperBound
        }
    }
    
    @Published var selectedDate: Date = Date() {
        didSet {
            availableCameras = getAvailableCameras()
        }
    }
    
    @Published var selectedCamera: CameraIdentifier   = .fhaz
     @Published var dateRange:        ClosedRange<Date>  = Date()...Date()
    @Published var availableCameras: [CameraIdentifier] = [.fhaz]
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        refreshMissions()
    }
    
    func refreshMissions() {
        for rover in Rover.allCases {
            networkManager.fetchMission(for: rover) { mission in
                self.missions[rover] = mission
                
                if rover == self.selectedRover {
                    self.dateRange = self.getDateRange()
                    self.availableCameras = self.getAvailableCameras()
                    self.selectedDate = self.dateRange.upperBound
                }
            }
        }
    }
    
    func getPhotosList(type:Rover,param:[String:String])  {
        apiCalled  = true
        apiResponse = false
        isShowingDatePicker = false 
        networkManager.fetchPhotoLists(for: type, on: param) { photos in
            
            self.photos = photos.photos
            self.apiCalled  = false 
            
            if photos.photos.isEmpty {
                self.apiResponse = true
            }else {
                self.apiResponse = false
            }
                
            
        }
    }

 
    private func getDateRange() -> ClosedRange<Date> {
        guard let startDate = missions[selectedRover]?.photoManifest.landingDate,
              let endDate   = missions[selectedRover]?.photoManifest.maxDate
        else {
            print("Unable to get date range from photo manifest.")
            return Date()...Date()
        }
        
        return startDate...endDate
    }
    
    private func getAvailableCameras() -> [CameraIdentifier] {
        guard let photoMeta = missions[selectedRover]?.photoManifest.photoMeta else {
            print("Unable to get available cameras from photo manifest.")
            selectedCamera = .none
            return [.none]
        }
        
        for record in photoMeta {
            if record.earthDate == selectedDate {
                selectedCamera = .fhaz
                var availableCameras = record.availableCameras
                availableCameras.insert(.all, at: 0)
                return availableCameras
            }
        }
        
        selectedCamera = .none
        return [.none]
    }
    
}




var caseType : CameraIdentifier = .fhaz
