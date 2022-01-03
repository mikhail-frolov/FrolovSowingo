// Name: Mikhail Frolov
// IOS DEV TEST
// ProductModel.swift

import Foundation

// Total 17 hits - products
struct Hits: Codable {
  
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
    
        case products = "hits"
    
    }
}

// Product - one hit
struct Product: Codable, Hashable {
  
    var isFavouriteProduct: Bool
    var id: String
    var name: String
    var subcategory: Category
    var medicalFieldId: String?
    var contentPerUnit: String?
    var onHand: Int?
    var vendorInventory: [VendorInventory]
    var advertisingBadges: AdvertisingBadges
    var countryId: String?
    var orderPackageQuantity: Int?
    var description: String?
    var marketplaceId: String?
    var buyByCase: Bool?
    var mainImage: String?
    var sdsURL: [String]?

    enum CodingKeys: String, CodingKey {
      
        case isFavouriteProduct
        case id
        case name
        case subcategory
        case medicalFieldId
        case contentPerUnit
        case onHand
        case advertisingBadges
        case vendorInventory
        case countryId
        case orderPackageQuantity
        case description
        case marketplaceId
        case buyByCase
        case mainImage
        case sdsURL = "sdsUrl"
  
    }
    
    private let identifier = UUID()
   
    func hash(into hasher: inout Hasher) {
    
        hasher.combine(identifier)
   
    }
}

// advertising_badges
struct AdvertisingBadges: Codable, Hashable {
  
    var hasBadge: Bool
    var badges: [Badge]?
    
    private let uid = UUID()
  
    func hash(into hasher: inout Hasher) {
     
        hasher.combine(uid)
    
    }
}

// advertising_badges -\ badge
struct Badge: Codable, Hashable {
   
    var badgeType: String?
    var badgeImageUrl: String?
    
    private let uid = UUID()
  
    func hash(into hasher: inout Hasher) {
    
        hasher.combine(uid)
    
    }
}


// parent_category
struct Category: Codable, Hashable {
  
    var id: String
    var name: String
    
    private let uid = UUID()
    
    func hash(into hasher: inout Hasher) {
    
        hasher.combine(uid)
    
    }
}

// vendor_inventory
struct VendorInventory: Codable, Hashable {

    var vendorInventoryId: String?
    var listPrice: Double
    var marketplaceId: String?
    var price: Double
    var vendorSku: String
    var vendor: Vendor

    enum CodingKeys: String, CodingKey {

        case vendorInventoryId
        case listPrice
        case marketplaceId
        case price
        case vendorSku
        case vendor

    }
    
    private let uid = UUID()

    func hash(into hasher: inout Hasher) {

        hasher.combine(uid)

    }
}

// MARK: - Vendor
struct Vendor: Codable, Hashable {

    var image: String
    var id: String
    var name: String
    
    private let uid = UUID()

    func hash(into hasher: inout Hasher) {

        hasher.combine(uid)

    }
}
