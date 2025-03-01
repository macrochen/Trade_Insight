//
//  Position.swift
//  Trade Insight
//
//  Created by Trae AI on 2025/3/1.
//

import Foundation

struct Position: Identifiable {
    let id = UUID()
    let stockCode: String
    let stockName: String
    let quantity: Int
    let costPrice: Double
    let currentPrice: Double
    let marketValue: Double
    let profit: Double
    let profitPercentage: Double
    let account: String
    
    // 计算属性：判断是否盈利
    var isProfitable: Bool {
        return profit > 0
    }
    
    // 示例数据
    static let samples = [
        Position(stockCode: "600000", stockName: "浦发银行", quantity: 1000, costPrice: 10.5, currentPrice: 11.2, marketValue: 11200, profit: 700, profitPercentage: 6.67, account: "A股账户"),
        Position(stockCode: "601318", stockName: "中国平安", quantity: 500, costPrice: 60.2, currentPrice: 58.4, marketValue: 29200, profit: -900, profitPercentage: -2.99, account: "A股账户"),
        Position(stockCode: "000001", stockName: "平安银行", quantity: 2000, costPrice: 15.8, currentPrice: 16.5, marketValue: 33000, profit: 1400, profitPercentage: 4.43, account: "A股账户"),
        Position(stockCode: "AAPL", stockName: "苹果公司", quantity: 50, costPrice: 150.2, currentPrice: 175.6, marketValue: 8780, profit: 1270, profitPercentage: 16.91, account: "美股账户"),
        Position(stockCode: "MSFT", stockName: "微软", quantity: 30, costPrice: 280.5, currentPrice: 275.2, marketValue: 8256, profit: -159, profitPercentage: -1.89, account: "美股账户")
    ]
}