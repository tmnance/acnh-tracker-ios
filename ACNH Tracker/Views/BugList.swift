//
//  BugList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct BugList: View {
    private let cellHeight = 130.0
    private let allBugItems = Bug.getAll()
    @State private var selectedBug: Bug? = nil
    @State private var searchText = ""

    let layout = [
        GridItem(.adaptive(minimum: 130)),
    ]
    
    func getFilteredBugItems() -> [Bug] {
        !searchText.isEmpty ?
            allBugItems.filter { $0.name.containsWord(startingWith: searchText.lowercased()) } :
            allBugItems
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(getFilteredBugItems()) { bug in
                        BugCell(bug: bug) {
                            selectedBug = bug
                        }
                    }
                }
            }
            .sheet(item: $selectedBug) { item in
                BugDetail(bug: item)
            }
            .navigationTitle("Bug")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BugList_Previews: PreviewProvider {
    static var previews: some View {
        BugList()
    }
}
