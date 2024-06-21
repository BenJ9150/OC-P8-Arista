//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    exercisePicker
                    TextField("Heure de démarrage", text: $viewModel.startTime)
                    TextField("Durée (en minutes)", text: $viewModel.duration)
                    TextField("Intensité (0 à 10)", text: $viewModel.intensity)
                }.formStyle(.grouped)
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addUserExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}

// MARK: Exercise picker

extension AddExerciseView {

    private var exercisePicker: some View {
        Picker("Catégorie", selection: $viewModel.exercise) {
            ForEach(viewModel.exercises) { exercise in
                Text(exercise.type ?? "").tag(exercise as Exercise?)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
