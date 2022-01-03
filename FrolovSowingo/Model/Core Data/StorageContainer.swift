//
//  StorageProvider.swift
//  FrolovSowingo
//
//  Created by Mikhail Frolov on 2022-01-02.
//

import Foundation
import CoreData

class StorageContainer {
   
    let persistentContainer: NSPersistentContainer
    
    init() {
    
        persistentContainer = NSPersistentContainer(name: "FrolovSowingo")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
        
                fatalError("Core Data store failed to load with error: \(error)")
            
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    
    }
}
