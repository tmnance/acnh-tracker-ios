//
//  BugList.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct BugList: View {
    private let cellHeight = 130.0
    @State private var selectedBug: Bug? = nil
//    @State private var searchText = ""

    let layout = [
        GridItem(.adaptive(minimum: 130)),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(Bug.getAll()) { bug in
                        BugCell(bug: bug) {
                            selectedBug = bug
                        }
                    }
                }
            }
            .sheet(item: $selectedBug) { item in
                BugDetail(bug: item)
//                    .background(BackgroundClearView())
//                    .background(Color.white.opacity(0.95))
            }
            .navigationTitle("Bug")
            .navigationBarTitleDisplayMode(.inline)
//            .searchable(text: $searchText)
//            .toolbar {
//                ToolbarItem(placement: .navigationBBugrailing) {
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

struct BugList_Previews: PreviewProvider {
    static var previews: some View {
        BugList()
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
