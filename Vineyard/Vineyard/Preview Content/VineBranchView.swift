
//
//  VineBranchView.swift
//  Vineyard
//
//  Created by Jiyoon Lee on 11/5/24.
//

import SwiftUI

struct VineBranchView: View {
    @State private var hasScrolledToEnd: Bool = false
    @State private var hasScrolledToStart: Bool = true
    var isStaticPreview: Bool = false
    var body: some View {
        ZStack {
            if isStaticPreview {
                staticImagePreview()
            } else {
                EndDetectionScrollView(.horizontal, showIndicators: false, hasScrolledToEnd: $hasScrolledToEnd, hasScrolledToStart: $hasScrolledToStart) {
                    LazyHStack {
                        ForEach(1..<11, id: \.self) { index in
                            Image("panorama\(index)")
                                .aspectRatio(contentMode: .fit)
                                .containerRelativeFrame(.horizontal, count:2, spacing: 10.0)
                            
                        }
                    }
                }
                .frame(height: 300)
                .ignoresSafeArea()
            }

            if hasScrolledToEnd && !isStaticPreview {
                arrowView(direction: .left)
            }

            if hasScrolledToStart && !isStaticPreview {
                arrowView(direction: .right)
            }
        }
    }

    private func staticImagePreview() -> some View {
        HStack(spacing: 0) {
            //chose 1..<3 to check if images look connected
            //change to last two images
            ForEach(1..<3, id:\.self) {index in
                Image("panorama\(index)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
        }
    }

    private func arrowView(direction: ArrowDirection) -> some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .frame(width: 50, height: 50)
                .cornerRadius(25)
                .opacity(0.7)
            Image(systemName: direction == .left ? "lessthan" : "greaterthan")
                .foregroundColor(.black)
                .font(.title)
                .opacity(0.4)
        }
        .position(x: direction == .left ? 30 : UIScreen.main.bounds.width - 30, y: 350)
        .transition(.opacity)
        .animation(.easeInOut, value: direction)
    }

    enum ArrowDirection {
        case left, right
    }
}

struct EndDetectionScrollView<Content: View>: View {
    let axis: Axis.Set
    let showIndicators: Bool
    @Binding var hasScrolledToEnd: Bool
    @Binding var hasScrolledToStart: Bool
    let content: () -> Content

    init(_ axis: Axis.Set,
         showIndicators: Bool,
         hasScrolledToEnd: Binding<Bool>,
         hasScrolledToStart: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.axis = axis
        self.showIndicators = showIndicators
        self._hasScrolledToEnd = hasScrolledToEnd
        self._hasScrolledToStart = hasScrolledToStart
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: showIndicators) {
            content()
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                updateScrollIndicators(geometry: geometry)
                            }
                            .onChange(of: geometry.frame(in: .global).minX) { _ in
                                updateScrollIndicators(geometry: geometry)
                            }
                    }
                )
        }
    }
    
    private func updateScrollIndicators(geometry: GeometryProxy) {
        let visibleWidth = UIScreen.main.bounds.width
        let contentWidth = geometry.size.width
        let offsetX = geometry.frame(in: .global).minX

        hasScrolledToStart = offsetX >= 0

        hasScrolledToEnd = offsetX <= -(contentWidth - visibleWidth)
    }
}

#Preview {
    VineBranchView()
}
