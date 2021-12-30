//
//  Art.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/20/21.
//

import Foundation

private struct ArtRaw: Decodable {
    let imageName: String
    let name: String
    let realName: String
    let artist: String
    let fake: String
}

struct Art: Identifiable {
    typealias ID = String
    private static let typeName = "art"

    var id: ID { name }

    let imageName: String
    let name: String
    let realName: String
    let artist: String
    let fake: String
    var isObtained: Bool = false
    var isDonated: Bool = false
    private var obtainedItem: ObtainedItem? = nil

    var shortName: String {
        name.replacingOccurrences(of: " painting", with: "").replacingOccurrences(of: " statue", with: "")
    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: PokemonKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        Pokemon.totalFound += 1
//        self.id = Pokemon.totalFound
//    }

    public static func getAll(
//        sortedBy sortKeys: [(String, Constants.SortDir)] = [("name", .asc)]
    ) -> [Art] {
//        let obtainedItems = loadObtainedItems()
//        let obtainedItemsSet = Set(obtainedItems.map { $0.name })
//        loadObtainedItems().forEach{ (obtainedItem) in
//            if let obtainedItemName = obtainedItem.name {
//                artItemsDict[obtainedItemName]?.isObtained = true
//            }
//        }
        let obtainedItemsDict = loadObtainedItems().reduce(into: [String: ObtainedItem]()) {
            $0[$1.name] = $1
        }

        return (self.getRawArtData() ?? []).map { (artRaw) in
            Art(
                imageName: artRaw.imageName,
                name: artRaw.name,
                realName: artRaw.realName,
                artist: artRaw.artist,
                fake: artRaw.fake,
                isObtained: obtainedItemsDict[artRaw.name] != nil,
                isDonated: obtainedItemsDict[artRaw.name] != nil,
                obtainedItem: obtainedItemsDict[artRaw.name]
            )
        }

//        loadObtainedItems().forEach{ (obtainedItem) in
//            if let obtainedItemName = obtainedItem.name {
//                artItemsDict[obtainedItemName]?.isObtained = true
//            }
//        }
//        return Array(artItemsDict.values)
    }

    private static func loadObtainedItems() -> [ObtainedItem] {
        return ObtainedItem.getAll(ofType: typeName)
    }

    private static func getRawArtData() -> [ArtRaw]? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: "ArtSeed", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let artRawList = try? decoder.decode([ArtRaw].self, from: data)
        else {
            return nil
        }
        return artRawList
    }
    
    mutating func obtainItem() {
        if obtainedItem != nil { // already exists
            return
        }

        let context = PersistenceController.shared.container.viewContext

        let newObtainedItem = ObtainedItem(context: context)
        newObtainedItem.name = name
        newObtainedItem.type = Art.typeName
        newObtainedItem.obtainedAt = Date()
        newObtainedItem.donatedAt = Date()

        do {
            try context.save()
            obtainedItem = newObtainedItem
            isObtained = true
            isDonated = true
        } catch {
            print("Error saving context, \(error)")
        }
    }

    mutating func unobtainItem() {
        guard let obtainedItemToDelete = obtainedItem else {
            return
        }

        let context = PersistenceController.shared.container.viewContext
        context.delete(obtainedItemToDelete)

        do {
            try context.save()
            obtainedItem = nil
            isObtained = false
            isDonated = false
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

extension Art {
    static let sample = Self.init(
        imageName: "vitruvian-man.jpg",
        name: "academic painting",
        realName: "vitruvian man",
        artist: "leonardo da vinci",
        fake: "there is a coffee stain in the upper right corner"
    )
}
