//
//  SummaryChart.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 25/07/2024.
//

import SwiftUI
import Charts

struct SummaryChart<T>: View where T: Summary {

    @Environment(\.colorScheme) private var colorScheme

    @State private var startAnimation = false
    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    let title: String
    let image: String
    let data: [Date: [T]]
    let yAxisIsHour: Bool
    let maxColumnsNb: Int
    let emptyMessage: String
    let error: String

    // MARK: Cell view

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
            .foregroundStyle(Color("GrayText"))
            .padding(.bottom, 10)
            // Chart content
            if error.isEmpty {
                if data.isEmpty {
                    empty
                } else {
                    createChart(withData: data)
                }
            } else {
                ErrorMessage(message: error)
                    .padding(.top)
            }
        }
        .padding(.all, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("ChartBackground"))
                .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
        )
        .onAppear {
            withAnimation(.bouncy) { startAnimation = true }
        }
        .onDisappear { startAnimation = false }
    }
}

// MARK: Empty chart

extension SummaryChart {

    private var empty: some View {
        VStack {
            Spacer()
            Text(emptyMessage)
                .frame(maxHeight: .infinity)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("GrayText"))
                .font(.footnote)
                .padding()
            Spacer()
        }
    }
}

// MARK: Create chart

extension SummaryChart {

    private func createChart(withData data: [Date: [T]]) -> some View {
        Chart {
            ForEach(data.keys.sorted().suffix(maxColumnsNb), id: \.self) { date in
                if let items = data[date], !items.isEmpty {
                    ForEach(items, id: \.self) { item in
                        let animValue = Int32(Double(item.duration) * 1.5)
                        BarMark(
                            x: .value("Date", date.toString()),
                            y: .value("Value", startAnimation ? item.duration : animValue)
                        )
                        .foregroundStyle(item.chartColor)
                    }
                } else {
                    BarMark(
                        x: .value("Date", date.toString()),
                        y: .value("Value", 0)
                    )
                }
            }
            .clipShape(Capsule())
        }
        .chartXAxis { chartXAxis() }
        .chartYAxis { chartYAxis(isHour: yAxisIsHour) }
        .padding(.horizontal, -5)
    }
}

// MARK: Axis

extension SummaryChart {

    private func chartXAxis() -> some AxisContent {
        AxisMarks(preset: .aligned) { value in
            AxisValueLabel {
                if let date = value.as(String.self) {
                    Text(date)
                        .foregroundStyle(Color("GrayText"))
                        .font(.caption2)
                        .bold()
                }
            }
        }
    }

    private func chartYAxis(isHour: Bool = false) -> some AxisContent {
        AxisMarks(preset: .aligned) { value in
            AxisValueLabel {
                Group {
                    if isHour, let duration = value.as(Int32.self) {
                        Text("\(duration / 60)h")
                    } else if let decimal = value.as(Decimal.self) {
                        Text("\(decimal)")
                    }
                }
                .foregroundStyle(Color("GrayText"))
                .font(.caption2)
                .bold()
            }
        }
    }
}

#Preview {
    SummaryChart(
        title: "Mon graphique",
        image: "moon.fill",
        data: [Date: [UserExercise]](),
        yAxisIsHour: true,
        maxColumnsNb: 3,
        emptyMessage: "Oups, aucune donnée n'est renseignée !",
        error: ""
    )
}
