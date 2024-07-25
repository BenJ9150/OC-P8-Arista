//
//  CaloriesChart.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 25/07/2024.
//

import SwiftUI
import Charts

struct CaloriesChart: View {

    @Environment(\.colorScheme) private var colorScheme

    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    let title: String
    let image: String
    let data: [Date: Decimal]
    let maxColumnsNb: Int
    let error: String

    @State private var startAnimation = false

    var body: some View {
        VStack(alignment: .leading) {
            // Chart title
            HStack(spacing: 5) {
                Image(systemName: image)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
                    .bold()
            }
            .foregroundStyle(Color("ChartBoldText"))
            .padding(.bottom, 10)
            // Chart content
            if error.isEmpty {
                createChart(withData: data)
            } else {
                ErrorMessage(message: error)
                    .padding(.top)
            }
        }
        .padding(.all, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("ChartBackground"))
                .shadow(color: shadowColor, radius: 4, x: 0, y: 4)
        )
        .onAppear {
            withAnimation(.bouncy) { startAnimation = true }
        }
        .onDisappear { startAnimation = false }
    }
}

// MARK: Create chart

extension CaloriesChart {

    private func createChart(withData data: [Date: Decimal]) -> some View {
        Chart {
            ForEach(data.keys.sorted().prefix(maxColumnsNb), id: \.self) { date in
                if let totalCalories = data[date] {
                    BarMark(
                        x: .value("Date", date.toString()),
                        y: .value("Value", startAnimation ? totalCalories : 600)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .clipShape(Capsule())
        }
        .chartXAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let date = value.as(String.self) {
                        Text(date)
                            .foregroundStyle(Color("ChartBoldText"))
                            .font(.caption2)
                            .bold()
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let calories = value.as(Decimal.self) {
                        Text("\(calories)")
                            .foregroundStyle(Color("ChartBoldText"))
                            .font(.caption2)
                            .bold()
                    }
                }
            }
        }
        .padding(.horizontal, -5)
    }
//    private func createChart(withData data: [Date: [UserExercise]]) -> some View {
//        var caloriesPerDay: [Date: Decimal] = [:]
//
//        for (date, exercises) in data {
//            var totalCalories: Decimal = 0
//            for exercise in exercises {
//                if let caloriesPerMin = exercise.exerciseType?.caloriesPerMin {
//                    totalCalories += (caloriesPerMin as Decimal) * Decimal(exercise.duration)
//                }
//            }
//            caloriesPerDay[date] = totalCalories
//        }
//
//        return Chart {
//            ForEach(caloriesPerDay.keys.sorted().prefix(maxColumnsNb), id: \.self) { date in
//                if let totalCalories = caloriesPerDay[date] {
//                    BarMark(
//                        x: .value("Date", date.toString()),
//                        y: .value("Value", startAnimation ? totalCalories : 600)
//                    )
//                    .foregroundStyle(.blue)
//                }
//            }
//            .clipShape(Capsule())
//        }
//        .chartXAxis {
//            AxisMarks(preset: .aligned) { value in
//                AxisValueLabel {
//                    if let date = value.as(String.self) {
//                        Text(date)
//                            .foregroundStyle(Color("ChartBoldText"))
//                            .font(.caption2)
//                            .bold()
//                    }
//                }
//            }
//        }
//        .chartYAxis {
//            AxisMarks(preset: .aligned) { value in
//                AxisValueLabel {
//                    if let calories = value.as(Decimal.self) {
//                        Text("\(calories)")
//                            .foregroundStyle(Color("ChartBoldText"))
//                            .font(.caption2)
//                            .bold()
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, -5)
//    }
}

#Preview {
    CaloriesChart(title: "Mon graphique", image: "moon.fill", data: [:], maxColumnsNb: 3, error: "")
}
