// Name: Mikhail Frolov
// IOS DEV TEST
// FavouriteProduct+CoreDataProperties.swift


import Foundation
import CoreData


extension FavouriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteProduct> {
        return NSFetchRequest<FavouriteProduct>(entityName: "FavouriteProduct")
    }

    @NSManaged public var isFavourite: Bool
    @NSManaged public var productID: String?

}

extension FavouriteProduct : Identifiable {

}
