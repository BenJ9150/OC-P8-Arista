//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View { // TODO: Ajouter la possibilité de supprimer un exercice

    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationView {
            List(viewModel.userExercises) { userExercise in
                UserExerciseRow(userExercise: userExercise)
            }
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext)) {
                viewModel.reload()
            }
        }
    }
}

// MARK: User exercise row

extension ExerciseListView {

    private struct UserExerciseRow: View {

        let userExercise: UserExercise

        var body: some View {
            HStack {
                Image(systemName: iconForCategory(userExercise.category))
                VStack(alignment: .leading) {
                    Text(userExercise.category)
                        .font(.headline)
                    Text("Durée: \(userExercise.duration) min")
                        .font(.subheadline)
                    Text(userExercise.date)
                        .font(.subheadline)
                    
                }
                Spacer()
                IntensityIndicator(intensity: userExercise.intensity)
            }
        }

        private func iconForCategory(_ category: String) -> String { // TODO: Mettre dans CoreData le nom de l'image lié à l'exercice
            switch category {
            case "Football":
                return "sportscourt"
            case "Natation":
                return "waveform.path.ecg"
            case "Running":
                return "figure.run"
            case "Marche":
                return "figure.walk"
            case "Cyclisme":
                return "bicycle"
            default:
                return "questionmark"
            }
        }
    }
}

// MARK: Intensity indicator

extension ExerciseListView {

    private struct IntensityIndicator: View {
        var intensity: Int16
        
        var body: some View {
            Circle()
                .fill(colorForIntensity(intensity))
                .frame(width: 10, height: 10)
        }
        
        private func colorForIntensity(_ intensity: Int16) -> Color {
            switch intensity {
            case 0...3:
                return .green
            case 4...6:
                return .yellow
            case 7...10:
                return .red
            default:
                return .gray
            }
        }
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
