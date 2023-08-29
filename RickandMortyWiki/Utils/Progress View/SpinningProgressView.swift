//
//  SpinningProgressView.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 28/08/23.
//

import SwiftUI

struct SpinningProgressView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        Image("portal")
            .resizable()
            .frame(width: 150, height: 150)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear() {
                isAnimating = true
            }
            .onDisappear() {
                isAnimating = false
            }
    }
}

struct SpinningProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SpinningProgressView()
    }
}
