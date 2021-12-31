//
//  ArtList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/22/21.
//

import SwiftUI

struct ArtList: View {
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
                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(getFilteredArtItems()) { art in
                        ArtCell(art: art) {
                            selectedArt = art
                        }
                    }
                }
            }
            .sheet(item: $selectedArt) { item in
                ArtDetail(art: item)
//                    .background(BackgroundClearView())
//                    .background(Color.white.opacity(0.95))
            }
            .navigationTitle("Art")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)//, placement: .navigationBarDrawer(displayMode: .always))
//            .onChange(of: searchText) { searchText in
//                if !searchText.isEmpty {
//                    artItems = Art.getAll().filter {
//                        $0.shortName.starts(with: searchText.lowercased())
//                    }
//                } else {
//                    artItems = Art.getAll()
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ArtList_Previews: PreviewProvider {
    static var previews: some View {
        ArtList()
    }
}

//struct BackgroundClearView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        DispatchQueue.main.async {
//            view.superview?.superview?.backgroundColor = .clear
//        }
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
