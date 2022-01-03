// Name: Mikhail Frolov
// IOS DEV TEST
// StorageContainer.swift

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
