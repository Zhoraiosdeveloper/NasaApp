//
//  HomeListItem.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI

struct HomeListItem: View {
    
    let roverName: String
    let cameraName: String
    let date: String
    let imageURL: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.backgroundOne) 
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 3)
            
            HStack {
                pictureInfoView(roverName: roverName, cameraName: cameraName, date: date)
                Spacer()
                if !imageURL.isEmpty {
                    AsyncImage(url: URL(string: "\(imageURL)")!) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 130, height: 130)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding([.bottom], 20)
    }
}

@ViewBuilder
func pictureInfoView(roverName: String, cameraName: String, date: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        pictureDetailLineView(attribute: "Rover", info: roverName)
        pictureDetailLineView(attribute: "Camera", info: cameraName)
        pictureDetailLineView(attribute: "Date", info: date)
    }
}

func dateFormatter(date: String) -> String {
    let utcDateString = date
    
    let utcDateFormatter = DateFormatter()
    utcDateFormatter.dateFormat = date
    
    utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    if let utcDate = utcDateFormatter.date(from: utcDateString) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let formattedDate = dateFormatter.string(from: utcDate)
        
        return formattedDate
    } else {
        return date
    }
}

@ViewBuilder
func pictureDetailLineView(attribute: String, info: String) -> some View {
    VStack {
        Text("\(attribute): ")
            .foregroundColor(.layerTwo)
            .font(Font.custom("SFPro", size: 16))
         +
        Text("\(info)")
            .foregroundColor(.layerOne)
            .font(Font.custom("SFPro-Bold", size: 16))
    }
    .padding(.leading, 10)
}
