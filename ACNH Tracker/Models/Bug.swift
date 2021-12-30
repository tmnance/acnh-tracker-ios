//
//  Bug.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import Foundation

private struct BugRaw: Decodable {
    let image: String
    let name: String
    let price: Int
    let location: String
    let time: [Int]
    let monthsNorthern: [Int]
}

struct Bug: Identifiable {
    typealias ID = String
    private static let typeName = "Bug"

    var id: ID { name }

    let image: String
    let name: String
    let price: Int
    let location: String
    let time: Set<Int>
    let monthsNorthern: Set<Int>
    var isObtained: Bool = false
    var isDonated: Bool = false
    private var obtainedItem: ObtainedItem? = nil

    public static func getAll(
//        sortedBy sortKeys: [(String, Constants.SortDir)] = [("name", .asc)]
    ) -> [Bug] {
        let obtainedItemsDict = loadObtainedItems().reduce(into: [String: ObtainedItem]()) {
            $0[$1.name] = $1
        }

        return (self.getRawBugData() ?? []).map { (bugRaw) in
            Bug(
                image: bugRaw.image,
                name: bugRaw.name,
                price: bugRaw.price,
                location: bugRaw.location,
                time: Set(bugRaw.time),
                monthsNorthern: Set(bugRaw.monthsNorthern),
                isObtained: obtainedItemsDict[bugRaw.name] != nil,
                isDonated: obtainedItemsDict[bugRaw.name] != nil,
                obtainedItem: obtainedItemsDict[bugRaw.name]
            )
        }
    }

    private static func loadObtainedItems() -> [ObtainedItem] {
        return ObtainedItem.getAll(ofType: typeName)
    }

    private static func getRawBugData() -> [BugRaw]? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: "BugSeed", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let bugRawList = try? decoder.decode([BugRaw].self, from: data)
        else {
            return nil
        }
        return bugRawList
    }
    
    mutating func obtainItem() {
        if obtainedItem != nil { // already exists
            return
        }

        let context = PersistenceController.shared.container.viewContext

        let newObtainedItem = ObtainedItem(context: context)
        newObtainedItem.name = name
        newObtainedItem.type = Bug.typeName
        newObtainedItem.obtainedAt = Date()
        newObtainedItem.donatedAt = nil

        do {
            try context.save()
            obtainedItem = newObtainedItem
            isObtained = true
            isDonated = false
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

    mutating func donateItem() {
        if obtainedItem == nil { // not yet marked as obtained
            obtainItem()
        }

        let context = PersistenceController.shared.container.viewContext

        obtainedItem!.donatedAt = Date()

        do {
            try context.save()
            isDonated = true
        } catch {
            print("Error saving context, \(error)")
        }
    }

    mutating func undonateItem() {
        guard let obtainedItemToUndonate = obtainedItem else {
            return
        }

        let context = PersistenceController.shared.container.viewContext
        obtainedItemToUndonate.donatedAt = nil

        do {
            try context.save()
            isDonated = false
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

extension Bug {
    static let sample = Self.init(
        image: "https://gamewith-en.akamaized.net/article_tools/animal-crossing-new-horizons/gacha/musi_10_i.png",
        name: "agrias butterfly",
        price: 3000,
        location: "flying",
        time: [8, 9, 10, 11, 12, 13, 14, 15, 16],
        monthsNorthern: [3, 4, 5, 6, 7, 8]
    )
}
