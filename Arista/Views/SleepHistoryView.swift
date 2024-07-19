//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {

    @ObservedObject var viewModel: SleepHistoryViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.fetchError.isEmpty {
                    sleepSessionsList
                } else {
                    ErrorMessage(message: viewModel.fetchError)
                }
            }
            .navigationTitle("Historique de Sommeil")
        }
    }
}

// MARK: Sleep sessions list

extension SleepHistoryView {

    private var sleepSessionsList: some View {
        List(viewModel.sleepSessions) { session in
            HStack {
                QualityIndicator(quality: session.quality)
                    .padding()
                VStack(alignment: .leading) {
                    Text("Début : \(session.date)")
                    Text("Durée : \(session.duration/60) heures")
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
                    .stroke(quality.color(), lineWidth: 5)
                    .foregroundColor(quality.color())
                    .frame(width: 30, height: 30)
                Text("\(quality)")
                    .foregroundColor(quality.color())
            }
        }
    }
}

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
