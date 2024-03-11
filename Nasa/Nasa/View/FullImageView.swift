//
//  FullImageView.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 11/03/2024.
//

import SwiftUI

struct FullImageView: View {
    
    var imageURL: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack {
                if !imageURL.isEmpty {
                    AsyncImage(url: URL(string: "\(imageURL)")!) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .padding([.top, .bottom], 100)
                }
            }
        }
    }
}

