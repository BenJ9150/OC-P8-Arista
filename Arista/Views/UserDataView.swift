//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: UserDataViewModel
    @State private var startAnimation = false

    private let chartSpacing: CGFloat = 16

    private var isPortrait: Bool {
        return horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    var body: some View {
        ZStack {
            BackgroundView(fullscreen: true)
            VStack {
                if viewModel.fetchError.isEmpty {
                    Spacer()
                    if isPortrait {
                        userDataToDisplayInPortrait
                        Spacer()
                        portraitSummaries
                    } else {
                        userDataToDisplayInLandscape
                        Spacer()
                        landscapeSummaries
                    }
                } else {
                    ErrorMessage(message: viewModel.fetchError)
                }
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

    private var userDataToDisplayInPortrait: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Heureux de vous revoir")
                    .font(.title3)
                Text("\(viewModel.firstName) \(viewModel.firstName == "" ? " " : "!")")
                    .font(.title)
                    .opacity(startAnimation ? 1 : 0)
                    .scaleEffect(startAnimation ? 1 : 0.7)
                Divider()
            }
            .bold()
            .padding(.horizontal, chartSpacing)
            .padding(.top)
            Spacer()
        }
    }

    private var userDataToDisplayInLandscape: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("Heureux de vous revoir")
                .font(.title3)
            Text("\(viewModel.firstName) \(viewModel.firstName == "" ? " " : "!")")
                .font(.title)
                .opacity(startAnimation ? 1 : 0)
                .scaleEffect(startAnimation ? 1 : 0.7)
            Spacer()
        }
        .bold()
        .padding(.horizontal, chartSpacing)
        .padding(.top, 8)
    }
}

// MARK: Summaries

extension UserDataView {

    private var portraitSummaries: some View {
        VStack(spacing: chartSpacing) {
            SummaryChart(
                title: "Votre sommeil",
                image: "moon.fill",
                data: viewModel.sleepSummary,
                yAxisIsHour: true,
                maxColumnsNb: viewModel.sleepSummaryColumns,
                emptyMessage: "Ajoutez vos sessions de sommeil dans l'onglet \"Sommeil\" !",
                error: viewModel.fetchSleepError
            )
            .padding(.horizontal)
            .padding(.bottom)
            HStack(spacing: chartSpacing) {
                SummaryChart(
                    title: "Vos exercices",
                    image: "flame.fill",
                    data: viewModel.exercisesSummary,
                    yAxisIsHour: true,
                    maxColumnsNb: viewModel.exercisesSummaryColumns,
                    emptyMessage: "Ajoutez vos derniers exercices dans l'onglet \"Exercices\" !",
                    error: viewModel.fetchExercisesError
                )
                .frame(height: 240)
                SummaryChart(
                    title: "Calories brûlées",
                    image: "flame.fill",
                    data: viewModel.caloriesPerDay,
                    yAxisIsHour: false,
                    maxColumnsNb: viewModel.exercisesSummaryColumns,
                    emptyMessage: "Ajoutez vos derniers exercices dans l'onglet \"Exercices\" !",
                    error: viewModel.fetchExercisesError
                )
                .frame(height: 180)
            }
        }
        .padding(.all, chartSpacing)
    }

    private var landscapeSummaries: some View {
        HStack(spacing: chartSpacing) {
            SummaryChart(
                title: "Votre sommeil",
                image: "moon.fill",
                data: viewModel.sleepSummary,
                yAxisIsHour: true,
                maxColumnsNb: viewModel.sleepSummaryColumns,
                emptyMessage: "Ajoutez vos sessions de sommeil dans l'onglet \"Sommeil\" !",
                error: viewModel.fetchSleepError
            )
            .padding(.bottom, 8)
            Divider()
            HStack(spacing: chartSpacing) {
                SummaryChart(
                    title: "Vos exercices",
                    image: "flame.fill",
                    data: viewModel.exercisesSummary,
                    yAxisIsHour: true,
                    maxColumnsNb: viewModel.exercisesSummaryColumns,
                    emptyMessage: "Ajoutez vos derniers exercices dans l'onglet \"Exercices\" !",
                    error: viewModel.fetchExercisesError
                )
                .frame(height: 240)
                SummaryChart(
                    title: "Calories brûlées",
                    image: "flame.fill",
                    data: viewModel.caloriesPerDay,
                    yAxisIsHour: false,
                    maxColumnsNb: viewModel.exercisesSummaryColumns,
                    emptyMessage: "Ajoutez vos derniers exercices dans l'onglet \"Exercices\" !",
                    error: viewModel.fetchExercisesError
                )
                .frame(height: 180)
            }
        }
        .padding(.all, chartSpacing)
    }
}

// MARK: Preview

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
