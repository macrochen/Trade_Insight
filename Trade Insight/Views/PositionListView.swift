//
//  PositionListView.swift
//  Trade Insight
//
//  Created by Trae AI on 2025/3/1.
//

import SwiftUI

struct PositionListView: View {
    @State private var positions = Position.samples
    @State private var selectedAccount: String? = nil
    @State private var sortOrder: SortOrder = .none
    @State private var searchText = ""
    
    private var filteredPositions: [Position] {
        var result = positions
        
        // 按账户筛选
        if let selectedAccount = selectedAccount {
            result = result.filter { $0.account == selectedAccount }
        }
        
        // 按搜索文本筛选
        if !searchText.isEmpty {
            result = result.filter { 
                $0.stockCode.localizedCaseInsensitiveContains(searchText) || 
                $0.stockName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // 排序
        switch sortOrder {
        case .profitAscending:
            result.sort { $0.profit < $1.profit }
        case .profitDescending:
            result.sort { $0.profit > $1.profit }
        case .none:
            break
        }
        
        return result
    }
    
    private var accounts: [String] {
        Array(Set(positions.map { $0.account })).sorted()
    }
    
    var body: some View {
        VStack {
            // 搜索栏
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("搜索股票代码或名称", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // 账户选择和排序控制
            HStack {
                Menu {
                    Button("全部账户") {
                        selectedAccount = nil
                    }
                    ForEach(accounts, id: \.self) { account in
                        Button(account) {
                            selectedAccount = account
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedAccount ?? "全部账户")
                        Image(systemName: "chevron.down")
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Menu {
                    Button("默认排序") {
                        sortOrder = .none
                    }
                    Button("盈利从高到低") {
                        sortOrder = .profitDescending
                    }
                    Button("盈利从低到高") {
                        sortOrder = .profitAscending
                    }
                } label: {
                    HStack {
                        Text("排序")
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // 持仓列表
            List {
                Section(header: PositionListHeaderView()) {
                    ForEach(filteredPositions) { position in
                        PositionRowView(position: position)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("持仓管理")
    }
}

struct PositionListHeaderView: View {
    var body: some View {
        HStack {
            Text("代码/名称")
                .frame(width: 120, alignment: .leading)
            Text("数量")
                .frame(width: 80, alignment: .trailing)
            Text("成本价")
                .frame(width: 80, alignment: .trailing)
            Text("现价")
                .frame(width: 80, alignment: .trailing)
            Text("市值")
                .frame(width: 100, alignment: .trailing)
            Text("盈亏")
                .frame(width: 100, alignment: .trailing)
            Text("盈亏%")
                .frame(width: 80, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
    }
}

struct PositionRowView: View {
    let position: Position
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(position.stockCode)
                    .font(.headline)
                Text(position.stockName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: 120, alignment: .leading)
            
            Text("\(position.quantity)")
                .frame(width: 80, alignment: .trailing)
            
            Text(String(format: "%.2f", position.costPrice))
                .frame(width: 80, alignment: .trailing)
            
            Text(String(format: "%.2f", position.currentPrice))
                .frame(width: 80, alignment: .trailing)
            
            Text(String(format: "%.0f", position.marketValue))
                .frame(width: 100, alignment: .trailing)
            
            Text(String(format: "%.0f", position.profit))
                .frame(width: 100, alignment: .trailing)
                .foregroundColor(position.isProfitable ? .green : .red)
            
            Text(String(format: "%.2f%%", position.profitPercentage))
                .frame(width: 80, alignment: .trailing)
                .foregroundColor(position.isProfitable ? .green : .red)
        }
        .padding(.vertical, 8)
    }
}

enum SortOrder {
    case none
    case profitAscending
    case profitDescending
}

#Preview {
    NavigationView {
        PositionListView()
    }
}