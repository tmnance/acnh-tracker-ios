//
//  ArtList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/22/21.
//

import SwiftUI

struct ArtList: View {
    public static let scrollTopId = UUID()
    private let cellHeight = 130.0
    private let allArtItems = Art.getAll()
    @State private var selectedArt: Art? = nil
    @State private var searchText = ""

    let layout = [
        GridItem(.adaptive(minimum: 130)),
    ]

    func getFilteredArtItems() -> [Art] {
        !searchText.isEmpty ?
            allArtItems.filter { $0.shortName.containsWord(startingWith: searchText.lowercased()) } :
            allArtItems
    }

    var body: some View {
        NavigationView {
            ScrollView {
                EmptyView()
                    .id(ArtList.scrollTopId)

                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(getFilteredArtItems()) { art in
                        ArtCell(art: art) {
                            selectedArt = art
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .sheet(item: $selectedArt) { item in
                ArtDetail(art: item)
            }
            .navigationTitle("Art")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)//, placement: .navigationBarDrawer(displayMode: .always))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ArtList_Previews: PreviewProvider {
    static var previews: some View {
        ArtList()
    }
}
