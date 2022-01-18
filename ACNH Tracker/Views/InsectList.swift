//
//  InsectList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct InsectList: View {
    enum ResultDisplayType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case list
        case grid
    }
    enum SortKey: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case name
        case id
    }
    enum FilterByStatus: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case all
        case donated
        case undonated
    }

    public static let scrollTopId = UUID()
    private let cellHeight = 130.0
    private let allInsectItems = Insect.getAll()

    @State private var selectedInsect: Insect? = nil
    @State private var searchText = ""
    @State private var isFilterActive = true
    @State private var sortBy: SortKey = .name
    @State private var filterByStatus: FilterByStatus = .all
    @State private var resultDisplayType: ResultDisplayType = .list
    @State private var changedFilterSort: Bool = false
    
    private let layoutGrid = [
        GridItem(.adaptive(minimum: 130)),
    ]
    private let layoutList = [
        GridItem(.flexible()),
    ]

    private var filteredAndSortedInsectItems: [Insect] {
        var items = allInsectItems
        if !searchText.isEmpty {
            items = items.filter { $0.name.containsWord(startingWith: searchText.lowercased()) }
        }
        switch filterByStatus {
        case .donated:
            items = items.filter { $0.isDonated == true }
            break;
        case .undonated:
            items = items.filter { $0.isDonated == false }
            break;
        default: break
        }
        switch sortBy {
        case .id:
            items = items.sorted(by: { $0.num < $1.num })
            break;
        default: break
        }
        return items
    }

    func toggleFilterMenu() {
        withAnimation {
            isFilterActive = !isFilterActive
        }
    }
    
    func scrollToTop(proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(InsectList.scrollTopId, anchor: .top)
        }
        changedFilterSort = false
    }

    var body: some View {
        NavigationView {
            VStack {
                if isFilterActive {
                    VStack {
                        SearchText(placeholder: "Search text", text: $searchText)
                            .onChange(of: searchText, perform: { _ in
                                changedFilterSort = true
                            })

                        HStack {
                            HStack(spacing: 0) {
                                Text("Display:")
                                    .padding(.trailing, 4)
                                Picker(selection: $resultDisplayType, label: EmptyView()) {
                                    ForEach(ResultDisplayType.allCases) {
                                        Text($0.rawValue.capitalized).tag($0)
                                    }
                                }
                                .onChange(of: resultDisplayType, perform: { _ in
                                    changedFilterSort = true
                                })
                                .labelsHidden()
                                .pickerStyle(.menu)
                            }

                            HStack(spacing: 0) {
                                Text("View:")
                                    .padding(.trailing, 4)
                                Picker(selection: $filterByStatus, label: EmptyView()) {
                                    ForEach(FilterByStatus.allCases) {
                                        Text($0.rawValue.capitalized).tag($0)
                                    }
                                }
                                .onChange(of: filterByStatus, perform: { _ in
                                    changedFilterSort = true
                                })
                                .labelsHidden()
                                .pickerStyle(.menu)
                            }

                            HStack(spacing: 0) {
                                Text("Sort:")
                                    .padding(.trailing, 4)
                                Picker(selection: $sortBy, label: EmptyView()) {
                                    ForEach(SortKey.allCases) {
                                        Text($0.rawValue.capitalized).tag($0)
                                    }
                                }
                                .onChange(of: sortBy, perform: { _ in
                                    changedFilterSort = true
                                })
                                .labelsHidden()
                                .pickerStyle(.menu)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                }

                ScrollView {
                    ScrollViewReader { proxy in
                        EmptyView()
                            .id(InsectList.scrollTopId)

                        if filteredAndSortedInsectItems.count == 0 {
                            Text("No results found")
                        }
                        else if resultDisplayType == .grid {
                            LazyVGrid(columns: layoutGrid, spacing: 5) {
                                ForEach(filteredAndSortedInsectItems, id: \.self.name) { insect in
                                    InsectGridCell(insect: insect) {
                                        selectedInsect = nil // potential fix for rare bug where tapping doesn't open sheet
                                        selectedInsect = insect
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .onChange(of: changedFilterSort) { isChanged in
                                if isChanged {
                                    scrollToTop(proxy: proxy)
                                }
                            }
                        }
                        else if resultDisplayType == .list {
                            LazyVGrid(columns: layoutList, spacing: 5) {
                                ForEach(filteredAndSortedInsectItems, id: \.self.name) { insect in
                                    InsectRow(insect: insect) {
                                        selectedInsect = nil // potential fix for rare bug where tapping doesn't open sheet
                                        selectedInsect = insect
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .onChange(of: changedFilterSort) { isChanged in
                                if isChanged {
                                    scrollToTop(proxy: proxy)
                                }
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedInsect) { item in
                InsectDetail(insect: item)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleFilterMenu) {
                        Label(
                            "Filter",
                            systemImage: isFilterActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
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
}

struct InsectList_Previews: PreviewProvider {
    static var previews: some View {
        InsectList()
    }
}
