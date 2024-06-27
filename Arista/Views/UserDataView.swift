//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {

    @ObservedObject var viewModel: UserDataViewModel

    var body: some View {
        if viewModel.fetchError.isEmpty {
            userDataToDisplay
        } else {
            ErrorMessage(message: viewModel.fetchError)
        }
    }
}

// MARK: User data to display

extension UserDataView {

    private var userDataToDisplay: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Hello")
                .font(.largeTitle)
            Text("\(viewModel.firstName) \(viewModel.lastName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID())
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
