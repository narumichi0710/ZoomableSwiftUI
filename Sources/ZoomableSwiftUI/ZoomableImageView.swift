//
//  ZoomableView.swift
//
//
//  Created by Narumichi Kubo on 2023/07/09.
//

import SwiftUI

public struct ZoomableImageView: View {
    let url: String
    let frameSize: CGSize?
    
    public init(url: String, frameSize: CGSize? = nil) {
        self.url = url
        self.frameSize = frameSize
    }

    @State private var offset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    @State private var scale = 1.0
    @State private var initialScale = 1.0
    @State private var imageSize: CGSize = .zero

    public var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
                .overlay(content: overlay)
        } placeholder: {
            ProgressView()
        }
        .scaleEffect(scale)
        .offset(offset)
        .gesture(SimultaneousGesture(magnification, drag))
        .onTapGesture(count: 2) {
            if scale < 1.0 {
                zoomIn()
            } else {
                zoomOut()
            }
        }
    }

    func overlay() -> some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    imageSize = geo.size
                }
        }
    }

    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = value * initialScale
            }
            .onEnded { _ in
                if scale < 1.0 {
                    zoomOut()
                } else {
                    initialScale = scale
                }
            }
    }

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = getCalculatedValue(value.translation)
            }
            .onEnded { _ in
                initialOffset = offset
            }
    }

    func zoomIn() {
        withAnimation {
            scale = 2.5
            initialScale = 2.5
        }
    }

    func zoomOut() {
        withAnimation {
            scale = 1.0
            initialScale = 1.0
            offset = .zero
            initialOffset = .zero
        }
    }

    func getCalculatedValue(_ translation: CGSize) -> CGSize {
        let newPosition = CGSize(
            width: initialOffset.width + translation.width,
            height: initialOffset.height + translation.height
        )
        let limitWidth = (imageSize.width * scale - imageSize.width) / 2
        let limitHeight = (imageSize.height * scale - imageSize.height) / 2
        let applyWidth = min(max(newPosition.width, -limitWidth), limitWidth)
        let applyHeight = min(max(newPosition.height, -limitHeight), limitHeight)

        return CGSize(
            width: applyWidth,
            height: applyHeight
        )
    }
}
