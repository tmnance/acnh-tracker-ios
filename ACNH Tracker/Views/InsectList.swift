//
//  InsectList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct InsectList: View {
    private let cellHeight = 130.0
    private let allInsectItems = Insect.getAll()
    @State private var selectedInsect: Insect? = nil
    @State private var searchText = ""

    let layout = [
        GridItem(.adaptive(minimum: 130)),
    ]
    
    func getFilteredInsectItems() -> [Insect] {
        !searchText.isEmpty ?
            allInsectItems.filter { $0.name.containsWord(startingWith: searchText.lowercased()) } :
            allInsectItems
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(getFilteredInsectItems()) { insect in
                        InsectCell(insect: insect) {
                            selectedInsect = insect
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .sheet(item: $selectedInsect) { item in
                InsectDetail(insect: item)
            }
            .navigationTitle("Insects")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InsectList_Previews: PreviewProvider {
    static var previews: some View {
        InsectList()
    }
}
