//
//  FavouriteProduct+CoreDataProperties.swift
//  FrolovSowingo
//
//  Created by Mikhail Frolov on 2022-01-03.
//
//

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
