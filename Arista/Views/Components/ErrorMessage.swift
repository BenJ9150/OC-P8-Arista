//
//  ErrorMessage.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 27/06/2024.
//

import SwiftUI

struct ErrorMessage: View {

    let message: String
    @State private var animation = false

    var body: some View {
        VStack {
            Image(systemName: "figure.walk.motion.trianglebadge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
                .foregroundStyle(.red)
                .symbolEffect(.pulse, options: .repeating, value: animation)
                .padding(.bottom)
                .onAppear {
                    animation.toggle()
                }
            Text(message)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
                .foregroundStyle(.red)
                .bold()
        }
    }
}

#Preview {
    ErrorMessage(message: "Oups, une erreur s'est produite lors du preview de la struct.")
}
