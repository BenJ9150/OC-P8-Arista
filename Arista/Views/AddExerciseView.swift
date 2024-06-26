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

    var exerciseAdded: () -> Void = {}

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.fetchError.isEmpty {
                    exerciseForm
                } else {
                    ErrorMessage(message: viewModel.fetchError)
                }
            }
            .navigationTitle("Nouvel Exercice ...")
            .alert(viewModel.addError, isPresented: $viewModel.showAlertError) {
                Button("OK", action: {})
            }
        }
    }
}

// MARK: Exercise Form

extension AddExerciseView {

    private var exerciseForm: some View {
        VStack {
            Form {
                exercisePicker
                durationPicker
                intensityPicker
                hourAndMinutePicker
            }.formStyle(.grouped)
            Spacer()
            Button("Ajouter l'exercice") {
                if viewModel.addUserExercise() {
                    exerciseAdded()
                    presentationMode.wrappedValue.dismiss()
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}

// MARK: Exercise picker

extension AddExerciseView {

    private var exercisePicker: some View {
        Picker("Catégorie", selection: $viewModel.exercise) {
            ForEach(viewModel.exercises) { exercise in
                HStack {
                    IconForCategory(exercise: exercise.type ?? "")
                    Text(exercise.type ?? "")
                }
                .tag(exercise as ExerciseType?)
            }
        }
        .pickerStyle(.menu)
        .padding(.all, 8)
    }
}

// MARK: Duration picker

extension AddExerciseView {

    private var durationPicker: some View {
        VStack(spacing: 6) {
            Text("Durée")
                .padding(.top)
            HStack {
                Spacer()
                // Hour
                Picker("Heures", selection: $viewModel.durationHour) {
                    ForEach(0..<100) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 70)

                Text(viewModel.durationHour > 1 ? "heures" : "heure  ")
                    .bold()
                    .padding(.leading, -10)
                    .padding(.trailing, 8)

                // Minute
                Picker("Minutes", selection: $viewModel.durationMinute) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 70)

                Text(viewModel.durationMinute > 1 ? "minutes" : "minute  ")
                    .bold()
                    .padding(.leading, -10)

                Spacer()
            }
            .frame(maxHeight: 100)
        }
    }
}

// MARK: Hour picker

extension AddExerciseView {

    private var hourAndMinutePicker: some View {
        DatePicker("Heure de démarrage", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
            .padding(.all, 8)
    }
}

// MARK: Intensity picker

extension AddExerciseView {

    private var intensityPicker: some View {
        VStack {
            // Display selection
            HStack {
                Text("Intensité : \(Int(viewModel.intensity))")
                IntensityIndicator(intensity: viewModel.intensity)
            }
            .padding(.top)

            // Slider to choose intensity
            Slider(value: $viewModel.intensity, in: 0...10, step: 1) {
                Text("")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("10")
            }
            .padding()
            .padding(.horizontal)
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
