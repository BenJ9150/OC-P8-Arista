//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: SleepHistoryViewModel

    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                if viewModel.fetchError.isEmpty {
                    sleepSessionsList
                } else {
                    ErrorMessage(message: viewModel.fetchError)
                }
            }
            .navigationTitle("Mon Sommeil")
        }
    }
}

// MARK: Sleep sessions list

extension SleepHistoryView {

    private var sleepSessionsList: some View {
        List {
            Section {
                ForEach(viewModel.sleepSessions) { sleep in
                    SleepRow(sleep: sleep)
                }
            } header: {
                Text("") // for top spacing
            }
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
    }
}

// MARK: Sleep row

extension SleepHistoryView {

    private struct SleepRow: View {

        let sleep: Sleep

        var body: some View {
            HStack {
                QualityIndicator(quality: sleep.quality)
                    .padding()
                VStack(alignment: .leading) {
                    Text("Début : \(sleep.date)")
                    Text("Durée : \(sleep.duration/60) heures")
                }
            }
        }
    }
}

// MARK: Quality Indicator

extension SleepHistoryView {

    private struct QualityIndicator: View {
        let quality: Int16

        var body: some View {
            ZStack {
                Circle()
                    .stroke(quality.qualityColor(), lineWidth: 5)
                    .foregroundColor(quality.qualityColor())
                    .frame(width: 30, height: 30)
                Text("\(quality)")
                    .foregroundColor(quality.qualityColor())
            }
        }
    }
}

// MARK: Preview

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
