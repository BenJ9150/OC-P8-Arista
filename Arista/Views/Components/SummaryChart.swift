//
//  SummaryChart.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 25/07/2024.
//

import SwiftUI
import Charts

struct SummaryChart: View {

    @Environment(\.colorScheme) private var colorScheme

    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    let title: String
    let image: String
    let data: [Date: [AnySummary]]
    let error: String

    @State private var startAnimation = false

    var body: some View {
        VStack(alignment: .leading) {
            // Chart title
            HStack {
                Image(systemName: image)
                Text(title)
                    .font(.subheadline)
                    .bold()
            }
            .foregroundStyle(Color("ChartBoldText"))
            // Chart content
            if error.isEmpty {
                createChart(withData: data)
            } else {
                ErrorMessage(message: error)
                    .padding(.top)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("ChartBackground"))
                .shadow(color: shadowColor, radius: 4, x: 0, y: 4)
        )
        .padding()
        .padding(.horizontal)
        .onAppear {
            withAnimation(.bouncy) { startAnimation = true }
        }
        .onDisappear { startAnimation = false }
    }
}

// MARK: Create chart

extension SummaryChart {

    private func createChart(withData data: [Date: [AnySummary]]) -> some View {
        Chart {
            ForEach(data.keys.sorted(), id: \.self) { date in
                if let items = data[date] {
                    ForEach(items, id: \.self) { item in
                        BarMark(
                            x: .value("Date", date.toString()),
                            y: .value("Value", startAnimation ? item.duration : 600)
                        )
                        .foregroundStyle(item.chartColor)
                    }
                }
            }
            .clipShape(Capsule())
        }
        .chartXAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let text = value.as(String.self) {
                        Text(text)
                            .foregroundStyle(Color("ChartBoldText"))
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let number = value.as(Int32.self) {
                        Text("\(number / 60)h")
                            .foregroundStyle(Color("ChartBoldText"))
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    SummaryChart(title: "Mon graphique", image: "moon.fill", data: [:], error: "")
}
