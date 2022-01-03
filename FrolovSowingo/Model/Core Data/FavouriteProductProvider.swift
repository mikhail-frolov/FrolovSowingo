//
//  FavouriteProductProvider.swift
//  FrolovSowingo
//
//  Created by Mikhail Frolov on 2022-01-02.
//

import CoreData
import UIKit

class FavouriteProductProvider: NSObject {
    
    let fetchedResultsController: NSFetchedResultsController<FavouriteProduct>
    private let delegate: NSFetchedResultsControllerDelegate
    let storageContainer: StorageContainer
    
    init(storageContainer: StorageContainer, delegate: NSFetchedResultsControllerDelegate) {
    
        let request: NSFetchRequest<FavouriteProduct> = FavouriteProduct.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavouriteProduct.productID, ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                   managedObjectContext: storageContainer.persistentContainer.viewContext,
                                                                   sectionNameKeyPath: nil, cacheName: nil)
        
        self.storageContainer = storageContainer
        self.delegate = delegate
        super.init()
        
        fetchedResultsController.delegate = delegate
        try! fetchedResultsController.performFetch()
    
    }
}


extension FavouriteProductProvider {
   
    func saveFavouriteProduct(productID: String, isFavourite: Bool) {
    
        let favouriteProduct = FavouriteProduct(context: storageContainer.persistentContainer.viewContext)
        
        favouriteProduct.isFavourite = isFavourite
        favouriteProduct.productID = productID
        
        save()
   
    }
    
    func removeFavouriteProduct(_ favouriteProduct: FavouriteProduct) {
      
        storageContainer.persistentContainer.viewContext.delete(favouriteProduct)
        save()
    
    }
    
    func getAllFavouriteProducts() -> [FavouriteProduct] {
        
        let fetchRequest: NSFetchRequest<FavouriteProduct> = FavouriteProduct.fetchRequest()
        
        do {
        
            return try storageContainer.persistentContainer.viewContext.fetch(fetchRequest)
        
        } catch {
        
            return []
        
        }
    }
    
    private func save() {
      
        do {
        
            try storageContainer.persistentContainer.viewContext.save()
        
        } catch {
        
            storageContainer.persistentContainer.viewContext.rollback()
        
        }
    }
}
