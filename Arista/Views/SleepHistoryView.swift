//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: SleepHistoryViewModel

    private var isPortrait: Bool {
        return horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

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
            ForEach(viewModel.sleepSessions) { sleep in
                SleepRow(sleep: sleep)
            }
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
        .contentMargins(.vertical, 24, for: .scrollContent)
        .contentMargins(.horizontal, isPortrait ? 16 : 160, for: .scrollContent)
    }
}

// MARK: Sleep row

extension SleepHistoryView {

    private struct SleepRow: View {

        let sleep: Sleep

        var body: some View {
            HStack {
                QualityIndicator(quality: sleep.quality)
                    .padding(.trailing, 10)
                    .padding(.vertical)
                VStack(alignment: .leading) {
                    Text("Début : \(sleep.date)")
                        .font(.headline)
                    Text("Durée : \(sleep.duration/60) heures")
                        .font(.subheadline)
                }
                .foregroundStyle(Color("GrayText"))
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
