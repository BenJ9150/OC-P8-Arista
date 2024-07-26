//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false

    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                BackgroundView()
                VStack {
                    if viewModel.fetchError.isEmpty {
                        exercisesList
                    } else {
                        ErrorMessage(message: viewModel.fetchError)
                    }
                }
                addExerciseButton
            }
            .navigationTitle("Mes exercices")
            .sheet(isPresented: $showingAddExerciseView) {
                AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext)) {
                    viewModel.reload()
                }
            }
            .alert(viewModel.deleteError, isPresented: $viewModel.showAlertError) {
                Button("OK", action: {})
            }
        }
    }
}

// MARK: User exercises list

extension ExerciseListView {

    private var exercisesList: some View {
        List {
            Section {
                ForEach(viewModel.userExercises) { userExercise in
                    UserExerciseRow(userExercise: userExercise)
                }
                .onDelete(perform: deleteExercise)
            } header: {
                Divider()
            }
        }
        .safeAreaPadding(.bottom, 80) // for add button
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
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
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(userExercise.category)
                        .font(.headline)
                    Text("Durée: \(userExercise.duration) min")
                        .font(.footnote)
                    Text(userExercise.date)
                        .font(.footnote)
                }
                Spacer()
                IntensityIndicator(intensity: userExercise.intensity)
            }
            .foregroundStyle(Color("GrayText"))
        }
    }
}

// MARK: Add exercise button

extension ExerciseListView {

    private var addExerciseButton: some View {
        Button {
            showingAddExerciseView = true
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Circle())
        }
        .padding()
    }
}

// MARK: Preview

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
