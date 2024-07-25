//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: UserDataViewModel
    @State private var startAnimation = false

    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    var body: some View {
        VStack {
            if viewModel.fetchError.isEmpty {
                userDataToDisplay
                summaries
                Spacer()
            } else {
                ErrorMessage(message: viewModel.fetchError)
            }
        }
        .onAppear {
            viewModel.fetchSummaries()
            withAnimation(.bouncy) { startAnimation = true }
        }
        .onDisappear { startAnimation = false }
    }
}

// MARK: User data to display

extension UserDataView {

    private var userDataToDisplay: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Heureux de vous revoir")
                    .font(.title3)
                Text("\(viewModel.firstName) \(viewModel.firstName == "" ? " " : "!")")
                    .font(.title)
                    .opacity(startAnimation ? 1 : 0)
                    .scaleEffect(startAnimation ? 1 : 0.7)
            }
            .fontWeight(.bold)
            .padding()
            .padding(.horizontal)
            .padding(.top)
            Spacer()
        }
    }
}

// MARK: Summaries

extension UserDataView {

    private var summaries: some View {
        VStack {
            SummaryChart(
                title: "Votre sommeil",
                image: "moon.fill",
                data: viewModel.sleepSummary.mapValues { $0.map(AnySummary.init) },
                error: viewModel.fetchSleepError
            )
            SummaryChart(
                title: "Vos exercices",
                image: "flame.fill",
                data: viewModel.exercisesSummary.mapValues { $0.map(AnySummary.init) },
                error: viewModel.fetchExercisesError
            )
        }
    }
}

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
