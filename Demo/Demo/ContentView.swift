//
//  ContentView.swift
//  Demo
//
//  Created by quando on 2023/07/09.
//

import SwiftUI
import ZoomableSwiftUI


enum ImageType: String, CaseIterable {
    case infinity
    case random
    
    var size: CGSize? {
        switch self {
        case .infinity:
            return nil
        case .random:
            return .init(
                width: Int.random(in: 100...300),
                height: Int.random(in: 100...300)
            )
        }
    }
}

struct ContentView: View {
    @State private var selectedImage: ImageType = .infinity
    let randomImageUrl = "https://source.unsplash.com/random"
    
    var body: some View {
        VStack {
            Picker(selection: $selectedImage, label: Text("image size")) {
                ForEach(ImageType.allCases, id: \.rawValue) {
                    Text("\($0.rawValue)")
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .frame(height: 48.0)
            .onChange(of: selectedImage) { newValue in
                print(newValue)
            }
            Spacer(minLength: 0.0)
            
            ZoomableImageView(url: randomImageUrl, frameSize: selectedImage.size)
                .overlay {
                    ZStack {
                        Color.orange
                        Text("Content area")
                    }
                    .opacity(0.15)
                }

            Spacer(minLength: 0)

            HStack(alignment: .bottom) {
                Spacer()
                Text("Footer area")
                Spacer()
            }
            .frame(height: 48.0)
            .background(Color.gray)
            .opacity(0.15)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
