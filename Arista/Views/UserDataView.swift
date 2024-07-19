//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import Charts

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
                sleepSummary
                Spacer()
            } else {
                ErrorMessage(message: viewModel.fetchError)
            }
        }
        .onAppear {
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
            .padding(.vertical)
            Spacer()
        }
    }
}

// MARK: Sleep summary

extension UserDataView {

    private var sleepSummary: some View {
        VStack(alignment: .leading) {
            // Chart title
            HStack {
                Image(systemName: "moon.fill")
                Text("Votre sommeil")
                    .font(.subheadline)
                    .bold()
            }
            .foregroundStyle(Color("ChartBoldText"))
            // Chart content
            if viewModel.fetchSleepError.isEmpty {
                sleepChart
            } else {
                ErrorMessage(message: viewModel.fetchSleepError)
                    .padding(.top)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("ChartBackground"))
                .shadow(color: shadowColor, radius: 4, x: 0, y: 4)
        )
        .padding()
        .padding(.horizontal)
    }

    private var sleepChart: some View {
        Chart {
            ForEach(viewModel.sleepSummary.keys.sorted(), id: \.self) { date in
                if let sleepSessions = viewModel.sleepSummary[date] {
                    ForEach(sleepSessions, id: \.self) { sleep in
                        BarMark(
                            x: .value("Date", date.toString()),
                            y: .value("Value", startAnimation ? sleep.duration : 600)
                        )
                        .foregroundStyle(sleep.quality.color())
                    }
                }
            }
            .clipShape(.capsule)
        }
        .frame(height: 300)
        .chartXAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let text = value.as(String.self) {
                        Text(text)
                            .foregroundStyle(Color("ChartBoldText"))
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let number = value.as(Int32.self) {
                        Text("\(number/60)h")
                            .foregroundStyle(Color("ChartBoldText"))
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
