//
//  ViewModel.swift
//  FrolovSowingo
//
//  Created by Mikhail Frolov on 2022-01-02.
//

import Foundation

class ViewModel {
   
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var favoriteProducts: [FavouriteProduct] = []
    
    init() {}
    
    func fetchProducts() async throws -> [Product] {
    
        let products = try await APIManager.shared.fetchAllProducts()
        self.products = products
        
        return self.products
    
    }
    
   
    func setFavourite(selected: Bool) async throws -> Favorite {
    
        let favorite = try await APIManager.shared.setFavoriteProduct(selected: selected)
        
        return favorite
    }
    
    func isFavourited(for productID: String) -> Bool {
        
        if let selectedProduct = favoriteProducts.first(where: { $0.productID == productID }), selectedProduct.isFavourite {
        
            return true
        
        } else {
        
            return false
        
        }
    }
    
    func getSavedFavouriteProduct(for id: String) -> FavouriteProduct? {
       
        return favoriteProducts.first(where: { $0.productID == id })
        
    }
}
