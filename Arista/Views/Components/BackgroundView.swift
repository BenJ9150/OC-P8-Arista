//
//  BackgroundView.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 26/07/2024.
//

import SwiftUI

struct BackgroundView: View {

    @Environment(\.colorScheme) var colorScheme
    let fullscreen: Bool

    init(fullscreen: Bool = false) {
        self.fullscreen = fullscreen
    }
    var body: some View {
        VStack {
            Rectangle()
                .fill(Gradient(colors: [Color("MainBackground"), .clear]))
                .frame(maxHeight: colorScheme == .dark ? 220 : fullscreen ? .infinity : 220)
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
