//
//  PositionDetailView.swift
//  Trade Insight
//
//  Created by Trae AI on 2025/3/1.
//

import SwiftUI
import Charts

struct PositionDetailView: View {
    let position: Position
    
    // 模拟的历史价格数据
    @State private var priceHistory = [
        PricePoint(date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!, price: 10.2),
        PricePoint(date: Calendar.current.date(byAdding: .day, value: -25, to: Date())!, price: 10.5),
        PricePoint(date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, price: 10.8),
        PricePoint(date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, price: 10.4),
        PricePoint(date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, price: 10.9),
        PricePoint(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, price: 11.1),
        PricePoint(date: Date(), price: 11.2)
    ]
    
    @State private var timeRange: TimeRange = .month
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 基本信息卡片
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(position.stockCode)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(position.stockName)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(String(format: "%.2f", position.currentPrice))
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 4) {
                                Image(systemName: position.isProfitable ? "arrow.up" : "arrow.down")
                                Text(String(format: "%.2f%%", position.profitPercentage))
                            }
                            .foregroundColor(position.isProfitable ? .green : .red)
                        }
                    }
                    
                    Divider()
                    
                    // 持仓详情
                    Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 12) {
                        GridRow {
                            Text("持仓数量")
                            Text("\(position.quantity)")
                                .fontWeight(.medium)
                            
                            Text("持仓市值")
                            Text(String(format: "¥%.2f", position.marketValue))
                                .fontWeight(.medium)
                        }
                        
                        GridRow {
                            Text("成本价")
                            Text(String(format: "¥%.2f", position.costPrice))
                                .fontWeight(.medium)
                            
                            Text("当前盈亏")
                            Text(String(format: "¥%.2f", position.profit))
                                .fontWeight(.medium)
                                .foregroundColor(position.isProfitable ? .green : .red)
                        }
                        
                        GridRow {
                            Text("账户")
                            Text(position.account)
                                .fontWeight(.medium)
                            
                            Text("盈亏比例")
                            Text(String(format: "%.2f%%", position.profitPercentage))
                                .fontWeight(.medium)
                                .foregroundColor(position.isProfitable ? .green : .red)
                        }
                    }
                    .font(.subheadline)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // 价格走势图
                VStack(alignment: .leading, spacing: 12) {
                    Text("价格走势")
                        .font(.headline)
                    
                    // 时间范围选择器
                    Picker("时间范围", selection: $timeRange) {
                        Text("1周").tag(TimeRange.week)
                        Text("1月").tag(TimeRange.month)
                        Text("3月").tag(TimeRange.quarter)
                        Text("1年").tag(TimeRange.year)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // 价格图表
                    Chart {
                        ForEach(filteredPriceHistory) { point in
                            LineMark(
                                x: .value("日期", point.date),
                                y: .value("价格", point.price)
                            )
                            .foregroundStyle(position.isProfitable ? .green : .red)
                            
                            AreaMark(
                                x: .value("日期", point.date),
                                y: .value("价格", point.price)
                            )
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [position.isProfitable ? .green.opacity(0.3) : .red.opacity(0.3), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    .frame(height: 250)
                    .chartYScale(domain: chartYDomain)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: strideDays)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // 交易建议
                VStack(alignment: .leading, spacing: 12) {
                    Text("交易建议")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("风险评级", systemImage: "exclamationmark.shield")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(riskRating)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(riskColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("建议操作", systemImage: "arrow.left.arrow.right")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(recommendedAction)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(actionColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                    
                    Text("分析说明")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(analysisDescription)
                        .font(.body)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle("持仓详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    // 根据选择的时间范围过滤价格历史数据
    private var filteredPriceHistory: [PricePoint] {
        let calendar = Calendar.current
        let filterDate: Date
        
        switch timeRange {
        case .week:
            filterDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        case .month:
            filterDate = calendar.date(byAdding: .month, value: -1, to: Date())!
        case .quarter:
            filterDate = calendar.date(byAdding: .month, value: -3, to: Date())!
        case .year:
            filterDate = calendar.date(byAdding: .year, value: -1, to: Date())!
        }
        
        return priceHistory.filter { $0.date >= filterDate }
    }
    
    // 图表Y轴范围
    private var chartYDomain: ClosedRange<Double> {
        if let min = filteredPriceHistory.map({ $0.price }).min(),
           let max = filteredPriceHistory.map({ $0.price }).max() {
            let buffer = (max - min) * 0.1
            return (min - buffer)...(max + buffer)
        }
        return 0...100
    }
    
    // 图表X轴刻度间隔天数
    private var strideDays: Int {
        switch timeRange {
        case .week: return 1
        case .month: return 5
        case .quarter: return 15
        case .year: return 30
        }
    }
    
    // 风险评级
    private var riskRating: String {
        if position.profitPercentage < -10 {
            return "高风险"
        } else if position.profitPercentage < 0 {
            return "中等风险"
        } else {
            return "低风险"
        }
    }
    
    private var riskColor: Color {
        if position.profitPercentage < -10 {
            return .red
        } else if position.profitPercentage < 0 {
            return .orange
        } else {
            return .green
        }
    }
    
    // 建议操作
    private var recommendedAction: String {
        if position.profitPercentage < -15 {
            return "考虑止损"
        } else if position.profitPercentage < -5 {
            return "观望"
        } else if position.profitPercentage > 20 {
            return "考虑获利了结"
        } else {
            return "持有"
        }
    }
    
    private var actionColor: Color {
        switch recommendedAction {
        case "考虑止损":
            return .red
        case "观望":
            return .orange
        case "考虑获利了结":
            return .blue
        default:
            return .green
        }
    }
    
    // 分析说明
    private var analysisDescription: String {
        if position.isProfitable {
            return "该持仓目前处于盈利状态，盈利率为\(String(format: "%.2f%%", position.profitPercentage))。根据历史价格走势分析，该股票近期表现稳定，建议继续持有观察。"
        } else {
            return "该持仓目前处于亏损状态，亏损率为\(String(format: "%.2f%%", abs(position.profitPercentage)))。根据历史价格走势分析，该股票近期表现不佳，建议密切关注，视情况考虑止损或加仓降低成本。"
        }
    }
}

// 价格点数据模型
struct PricePoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

// 时间范围枚举
enum TimeRange {
    case week
    case month
    case quarter
    case year
}

#Preview {
    NavigationView {
        PositionDetailView(position: Position.samples[0])
    }
}