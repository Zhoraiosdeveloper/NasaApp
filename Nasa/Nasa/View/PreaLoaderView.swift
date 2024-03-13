//
//  PreaLoaderView.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 10/03/2024.
//

import SwiftUI
import Lottie

struct PrealoderView: View {
    
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color.backgroundOne
                .ignoresSafeArea()
            VStack {
                if isLoading {
                    Spacer()
                    Image("NasaLogo")
                        .frame(width: 123, height: 123)
                        .cornerRadius(30)
                    Spacer()
                    LottieView(filename: "LottieAnimation")
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                } else {
                    HomeView()
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }
}
