//
//  Insect.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import Foundation

private struct InsectRaw: Decodable {
    let num: Int
    let name: String
    let imageName: String
    let price: Int
    let location: String
    let weather: String
    let totalCatchesToUnlock: Int
    let rarity: String
    let hours: [Int]
    let monthsNorthern: [Int]
}

struct Insect: Identifiable {
    typealias ID = String
    private static let typeName = "Insect"

    var id: ID { name }

    let num: Int
    let name: String
    let imageName: String
    let price: Int
    let location: String
    let weather: String
    let totalCatchesToUnlock: Int
    let rarity: String
    let hours: Set<Int>
    let monthsNorthern: Set<Int>
    var isObtained: Bool = false
    var isDonated: Bool = false
    private var obtainedItem: ObtainedItem? = nil

    public static func getAll(
//        sortedBy sortKeys: [(String, Constants.SortDir)] = [("name", .asc)]
    ) -> [Insect] {
        let obtainedItemsDict = loadObtainedItems().reduce(into: [String: ObtainedItem]()) {
            $0[$1.name] = $1
        }

        return (self.getRawInsectData() ?? []).map { (insectRaw) in
            Insect(
                num: insectRaw.num,
                name: insectRaw.name,
                imageName: insectRaw.imageName,
                price: insectRaw.price,
                location: insectRaw.location,
                weather: insectRaw.weather,
                totalCatchesToUnlock: insectRaw.totalCatchesToUnlock,
                rarity: insectRaw.rarity,
                hours: Set(insectRaw.hours),
                monthsNorthern: Set(insectRaw.monthsNorthern),
                isObtained: obtainedItemsDict[insectRaw.name] != nil,
                isDonated: obtainedItemsDict[insectRaw.name] != nil,
                obtainedItem: obtainedItemsDict[insectRaw.name]
            )
        }
    }

    private static func loadObtainedItems() -> [ObtainedItem] {
        return ObtainedItem.getAll(ofType: typeName)
    }

    private static func getRawInsectData() -> [InsectRaw]? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: "InsectSeed", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let insectRawList = try? decoder.decode([InsectRaw].self, from: data)
        else {
            return nil
        }
        return insectRawList
    }
    
    mutating func obtainItem() {
        if obtainedItem != nil { // already exists
            return
        }

        let context = PersistenceController.shared.container.viewContext

        let newObtainedItem = ObtainedItem(context: context)
        newObtainedItem.name = name
        newObtainedItem.type = Insect.typeName
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

extension Insect {
    static let sample = Self.init(
        num: 10,
        name: "agrias butterfly",
        imageName: "agrias-butterfly.png",
        price: 3000,
        location: "flying near flowers",
        weather: "any except rain",
        totalCatchesToUnlock: 20,
        rarity: "uncommon",
        hours: [8, 9, 10, 11, 12, 13, 14, 15, 16],
        monthsNorthern: [3, 4, 5, 6, 7, 8]
    )
}
