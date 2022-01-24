//
//  InsectListViewModel.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 1/23/22.
//

import Foundation

final class InsectListViewModel: ObservableObject {
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

    private let allInsectItems = Insect.getAll()
    @Published var filteredAndSortedInsectItems: [Insect] = []
    @Published var selectedInsect: Insect? = nil
    @Published var isFilterActive = true
    @Published var searchText = ""
    @Published var sortBy: SortKey = .name
    @Published var filterByStatus: FilterByStatus = .all
    @Published var resultDisplayType: ResultDisplayType = .list
    @Published var lastFilterSortDate: Date = .now

    init() {
        updateContent()
    }

    func updateContent() {
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
        filteredAndSortedInsectItems = items
        lastFilterSortDate = .now
    }
}
