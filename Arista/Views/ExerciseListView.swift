//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {

    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false

    var body: some View {
        NavigationView {
            exercisesList
                .navigationTitle("Exercices")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddExerciseView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext)) {
                viewModel.reload()
            }
        }
    }
}

// MARK: User exercises list

extension ExerciseListView {

    private var exercisesList: some View {
        List {
            ForEach(viewModel.userExercises) { userExercise in
                UserExerciseRow(userExercise: userExercise)
            }
            .onDelete(perform: deleteExercise)
        }
    }

    private func deleteExercise(at offsets: IndexSet) {
        // Perform delete operation in your ViewModel
        for index in offsets {
            let exerciseToDelete = viewModel.userExercises[index]
            viewModel.delete(exerciseToDelete)
        }
    }
}

// MARK: User exercise row

extension ExerciseListView {

    private struct UserExerciseRow: View {

        let userExercise: UserExercise

        var body: some View {
            HStack {
                IconForCategory(exercise: userExercise.category)
                    .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    Text(userExercise.category)
                        .font(.headline)
                    Text("Durée: \(userExercise.duration) min")
                        .font(.subheadline)
                    Text(userExercise.date)
                        .font(.subheadline)
                }
                Spacer()
                IntensityIndicator(intensity: Double(userExercise.intensity))
            }
        }
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
