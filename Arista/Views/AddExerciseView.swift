//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AddExerciseViewModel

    var exerciseAdded: () -> Void = {}

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                title
                if viewModel.fetchError.isEmpty {
                    exerciseForm
                    Spacer()
                    addButton
                } else {
                    ErrorMessage(message: viewModel.fetchError)
                }
            }
        }
        .alert(viewModel.addError, isPresented: $viewModel.showAlertError) {
            Button("OK", action: {})
        }
    }
}

// MARK: Title

extension AddExerciseView {

    private var title: some View {
        Text("Nouvel exercice")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity)
            .frame(height: 100)
    }
}

// MARK: Exercise Form

extension AddExerciseView {

    private var exerciseForm: some View {
        VStack {
            HStack {
                exercisePicker
                intensityTitle
            }
            .padding(.top, 30)
            intensityPicker
            Divider()
            durationPicker
            Divider()
            datePicker
        }
        .padding(.horizontal)
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
    }
}

// MARK: Intensity picker

extension AddExerciseView {

    private var intensityTitle: some View {
        HStack {
            Text("Intensité : \(Int(viewModel.intensity))")
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color("GrayText"))
            IntensityIndicator(intensity: Int16(viewModel.intensity))
        }
    }

    private var intensityPicker: some View {
        Slider(value: $viewModel.intensity, in: 0...10, step: 1) {
            Text("")
        } minimumValueLabel: {
            Text("0")
        } maximumValueLabel: {
            Text("10")
        }
        .padding()
        .padding(.horizontal)
        .tint(Int16(viewModel.intensity).intensityColor())
        .foregroundStyle(Color("GrayText"))
    }
}

// MARK: Duration picker

extension AddExerciseView {

    private var durationPicker: some View {
        VStack(spacing: 6) {
            Text("Durée")
                .padding(.top)
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color("GrayText"))
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
        .padding(.bottom)
    }
}

// MARK: Date picker

extension AddExerciseView {

    private var datePicker: some View {
        HStack {
            Text("Date")
                .padding()
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color("GrayText"))
            Spacer()
            DatePicker("", selection: $viewModel.startTime, displayedComponents: [.date, .hourAndMinute])
                .padding()
        }
    }
}

// MARK: Add button

extension AddExerciseView {

    private var addButton: some View {
        Button {
            if viewModel.addUserExercise() {
                exerciseAdded()
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("AJOUTER")
                .bold()
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
        }
        .buttonStyle(.borderedProminent)
        .padding(.all, 24)
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
