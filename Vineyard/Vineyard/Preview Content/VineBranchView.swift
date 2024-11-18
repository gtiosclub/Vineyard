
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
    let groupScore: Int
    let groupTotalScore: Int
    var body: some View {
        ZStack {
            EndDetectionScrollView(.horizontal, showIndicators: false, hasScrolledToEnd: $hasScrolledToEnd, hasScrolledToStart: $hasScrolledToStart) {

                HStack(spacing:0) {
                    Image("random0")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                    
                    ForEach(randomize(), id: \.self) { index in
                        Image("random\(index)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                    }
                    
                    // End Image
                    Image("random5")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                }
            }
            .frame(height: 250)
//            .border(Color.gray, width: 5)
            .padding()
            .ignoresSafeArea()
            if hasScrolledToEnd {
                arrowView(direction: .left)
            }

            if hasScrolledToStart {
                arrowView(direction: .right)
            }
        }
    }
    private func randomize() -> [Int] {
        let progressCount = max(ceil(Double(groupScore) / Double(groupTotalScore)), 2) - 2
        let array = Array(1...4)
        let randomizeArray = array.shuffled()
        return Array(randomizeArray.prefix(Int(progressCount)))
    }
    private func arrowView(direction: ArrowDirection) -> some View {
        ZStack {
//            Color.clear
//                .background(.ultraThinMaterial)
//                .frame(width: 50, height: 50)
//                .cornerRadius(25)
//                .opacity(0.7)
            Image(systemName: direction == .left ? "arrow.left" : "arrow.right")
                .foregroundColor(.black)
                .font(.title)
                .opacity(0.4)
        }
        .position(x: direction == .left ? 47 : UIScreen.main.bounds.width - 80, y: 150)
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
    VineBranchView(groupScore: 30, groupTotalScore: 10)
}
