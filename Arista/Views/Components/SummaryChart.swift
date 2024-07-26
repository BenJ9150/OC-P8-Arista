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

    @State private var startAnimation = false
    private var shadowColor: Color {
        return colorScheme == .dark ? .clear : .gray.opacity(0.4)
    }

    let title: String
    let image: String
    let anySummaryData: [Date: [AnySummary]]?
    let decimalData: [Date: Decimal]?
    let maxColumnsNb: Int
    let emptyMessage: String
    let error: String

    // MARK: Init

    init(
        title: String,
        image: String,
        anySummaryData: [Date: [AnySummary]]? = nil,
        decimalData: [Date: Decimal]? = nil,
        maxColumnsNb: Int,
        emptyMessage: String,
        error: String
    ) {
        self.title = title
        self.image = image
        self.anySummaryData = anySummaryData
        self.decimalData = decimalData
        self.maxColumnsNb = maxColumnsNb
        self.emptyMessage = emptyMessage
        self.error = error
    }

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
            .foregroundStyle(Color("ChartBoldText"))
            .padding(.bottom, 10)
            // Chart content
            if error.isEmpty {
                chartOrEmptyMessage
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

// MARK: Chart

extension SummaryChart {

    private var chartOrEmptyMessage: some View {
        Group {
            if let data = anySummaryData {
                if data.isEmpty {
                    empty
                } else {
                    createChart(withSummaryData: data)
                }
            } else if let data = decimalData {
                if data.isEmpty {
                    empty
                } else {
                    createChart(withDecimalData: data)
                }
            }
        }
    }

    private var empty: some View {
        VStack {
            Spacer()
            Text(emptyMessage)
                .frame(maxHeight: .infinity)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("ChartBoldText"))
                .font(.footnote)
                .padding()
            Spacer()
        }
    }
}

// MARK: Create chart

extension SummaryChart {

    private func createChart(withSummaryData data: [Date: [AnySummary]]) -> some View {
        Chart {
            ForEach(data.keys.sorted().suffix(maxColumnsNb), id: \.self) { date in
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
        .chartXAxis { chartXAxis() }
        .chartYAxis { chartYAxis(isHour: true) }
        .padding(.horizontal, -5)
    }

    private func createChart(withDecimalData data: [Date: Decimal]) -> some View {
        Chart {
            ForEach(data.keys.sorted().suffix(maxColumnsNb), id: \.self) { date in
                if let totalCalories = data[date] {
                    BarMark(
                        x: .value("Date", date.toString()),
                        y: .value("Value", startAnimation ? totalCalories : 600)
                    )
                    .foregroundStyle(.orange)
                }
            }
            .clipShape(Capsule())
        }
        .chartXAxis { chartXAxis() }
        .chartYAxis { chartYAxis() }
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
                        .foregroundStyle(Color("ChartBoldText"))
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
                .foregroundStyle(Color("ChartBoldText"))
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
        anySummaryData: [:],
        maxColumnsNb: 3,
        emptyMessage: "Oups, aucune donnée n'est renseignée !",
        error: ""
    )
}
