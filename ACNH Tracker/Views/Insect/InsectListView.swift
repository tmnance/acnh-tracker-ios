//
//  InsectListView.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct InsectListView: View {
    @StateObject private var viewModel = InsectListViewModel()

    public static let scrollTopId = UUID()
    private let cellHeight = 130.0
    private let layoutGrid = [
        GridItem(.adaptive(minimum: 130)),
    ]
    private let layoutList = [
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isFilterActive {
                    filterView
                }

                ScrollView {
                    ScrollViewReader { proxy in
                        EmptyView()
                            .id(InsectListView.scrollTopId)
                            .onChange(of: viewModel.lastFilterSortDate) { _ in
                                withAnimation {
                                    proxy.scrollTo(InsectListView.scrollTopId, anchor: .top)
                                }
                            }

                        if viewModel.filteredAndSortedInsectItems.count == 0 {
                            Text("No results found")
                        }
                        else if viewModel.resultDisplayType == .list {
                            resultsListView
                        }
                        else if viewModel.resultDisplayType == .grid {
                            resultsGridView
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedInsect) { item in
                InsectDetailsView(insect: item)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleFilterMenu) {
                        Label("Filter", systemImage: viewModel.isFilterActive ?
                            "line.3.horizontal.decrease.circle.fill" :
                            "line.3.horizontal.decrease.circle"
                        )
                    }
                }
            }
            .navigationTitle("Insects")
            .navigationBarTitleDisplayMode(.inline)
//            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .disableAutocorrection(true)
            .autocapitalization(.none)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var filterView: some View {
        VStack {
            SearchText(placeholder: "Search text", text: $viewModel.searchText)
                .onChange(of: viewModel.searchText, perform: { _ in
                    viewModel.updateContent()
                })

            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text("Display:")
                    Picker(selection: $viewModel.resultDisplayType, label: EmptyView()) {
                        ForEach(InsectListViewModel.ResultDisplayType.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .onChange(of: viewModel.resultDisplayType, perform: { _ in
                        viewModel.updateContent()
                    })
                }

                HStack(spacing: 4) {
                    Text("View:")
                    Picker(selection: $viewModel.filterByStatus, label: EmptyView()) {
                        ForEach(InsectListViewModel.FilterByStatus.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .onChange(of: viewModel.filterByStatus, perform: { _ in
                        viewModel.updateContent()
                    })
                }

                HStack(spacing: 4) {
                    Text("Sort:")
                    Picker(selection: $viewModel.sortBy, label: EmptyView()) {
                        ForEach(InsectListViewModel.SortKey.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .onChange(of: viewModel.sortBy, perform: { _ in
                        viewModel.updateContent()
                    })
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .padding(.horizontal, 10)
        .padding(.top, 8)
    }

    private var resultsGridView: some View {
        LazyVGrid(columns: layoutGrid, spacing: 5) {
            ForEach(viewModel.filteredAndSortedInsectItems, id: \.self.name) { insect in
                InsectGridCell(insect: insect) {
                    viewModel.selectedInsect = nil // potential fix for rare bug where tapping doesn't open sheet
                    viewModel.selectedInsect = insect
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
    }

    private var resultsListView: some View {
        LazyVGrid(columns: layoutList, spacing: 5) {
            ForEach(viewModel.filteredAndSortedInsectItems, id: \.self.name) { insect in
                InsectRow(insect: insect) {
                    viewModel.selectedInsect = nil // potential fix for rare bug where tapping doesn't open sheet
                    viewModel.selectedInsect = insect
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
    }

    private func toggleFilterMenu() {
        withAnimation {
            viewModel.isFilterActive = !viewModel.isFilterActive
        }
    }
}

struct InsectList_Previews: PreviewProvider {
    static var previews: some View {
        InsectListView()
    }
}
