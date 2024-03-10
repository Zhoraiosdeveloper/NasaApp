//
//  SaveButton.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI

struct SaveButton: View {
    var body: some View {
       Image("Save")
            .frame(width: 38, height: 38, alignment: .center)
            .background(
               Rectangle()
                .foregroundColor(.backgroundOne)
                .cornerRadius(10)
            )
    }
}

#Preview {
    SaveButton()
}
