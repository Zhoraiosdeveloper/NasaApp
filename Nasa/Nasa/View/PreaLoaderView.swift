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

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var filename: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}
