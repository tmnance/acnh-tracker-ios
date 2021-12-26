//
//  ArtList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/22/21.
//

import SwiftUI

struct ArtList: View {
    private let cellHeight = 130.0
    @State private var selectedArt: Art? = nil
//    @State private var searchText = ""

    let layout = [
        GridItem(.adaptive(minimum: 130)),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(Art.getAll()) { art in
                        ArtCell(art: art) {
                            print("onTap")
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
//            .searchable(text: $searchText)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
////                ToolbarItem {
////                    Button(action: addItem) {
////                        Label("Add Item", systemImage: "plus")
////                    }
////                }
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
