//
//  ContentView.swift
//  Trade Insight
//
//  Created by jolin on 2025/3/1.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedPosition: Position? = nil
    
    var body: some View {
        NavigationSplitView {
            // 侧边栏
            List {
                NavigationLink(destination: PositionListView()) {
                    Label("持仓管理", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(0)
                
                NavigationLink(destination: Text("投资组合分析").font(.largeTitle)) {
                    Label("投资组合分析", systemImage: "chart.pie")
                }
                .tag(1)
                
                NavigationLink(destination: Text("交易记录").font(.largeTitle)) {
                    Label("交易记录", systemImage: "list.bullet.rectangle")
                }
                .tag(2)
                
                NavigationLink(destination: Text("市场行情").font(.largeTitle)) {
                    Label("市场行情", systemImage: "globe")
                }
                .tag(3)
                
                NavigationLink(destination: Text("设置").font(.largeTitle)) {
                    Label("设置", systemImage: "gear")
                }
                .tag(4)
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Trade Insight")
        } detail: {
            // 详情视图
            if let selectedPosition = selectedPosition {
                PositionDetailView(position: selectedPosition)
            } else {
                // 默认显示持仓列表
                PositionListView()
                    .navigationTitle("持仓管理")
            }
        }
    }
}

// 扩展PositionListView，添加选择持仓的功能
extension PositionListView {
    init(selectedPosition: Binding<Position?> = .constant(nil)) {
        _positions = State(initialValue: Position.samples)
        _selectedAccount = State(initialValue: nil)
        _sortOrder = State(initialValue: .none)
        _searchText = State(initialValue: "")
    }
}

#Preview {
    ContentView()
}
