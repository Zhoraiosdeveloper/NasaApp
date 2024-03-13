//
//  FilterButton.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI

struct FilterButton: View {
    
    var iconName: String
    var text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.backgroundOne)
                .frame(width: 140, height: 38)
                .cornerRadius(10)
            HStack(spacing:5) {
                Image(iconName)
                    .padding(.leading, 7)
                Text(text)
                    .font(Font.custom("SFPro-Bold", size: 17))
                    .frame(height: 22)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.layerOne)
                Spacer()
            }
        }
    }
}

#Preview {
    FilterButton(iconName: "Camera", text: "All")
}
