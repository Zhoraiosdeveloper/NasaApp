//
//  DataPicker.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI


struct DataPicker: View {
    
    @State private var date = Date()

    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
                .opacity(0.2)
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.backgroundOne) 
                .background(Color.backgroundOne)
                .padding([.leading, .trailing], 20)
                .frame(width: 353, height: 312)
            VStack {
                HStack {
                    Image("Close")
                        .padding(.leading, 20)
                    Spacer()
                    Text("Date")
                        .foregroundColor(.layerOne)
                        .font(Font.custom("SFPro-Bold", size: 22))
                    Spacer()
                    Image("Tick")
                        .padding(.trailing, 20)
                }
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date])
                   .datePickerStyle(.wheel)
                   .foregroundColor(.layerOne)
                   .labelsHidden()
            }
        }
        
    }
}

#Preview {
    DataPicker()
}
