//
//  saveCoreData.swift
//  TodoListApp
//
//  Created by jear on 2018-12-08.
//  Copyright © 2018 jear. All rights reserved.
//

import Foundation
import CoreData

/*----------------(1)-------------*/
class saveCoreData {
    
 /*--------(2) NS persistent container which is used to interact with out datamodel we created (DB)-----------*/
   /*---https://cocoacasts.com/setting-up-the-core-data-stack-with-nspersistentcontainer ---*/
    
    var container: NSPersistentContainer  {
        let container = NSPersistentContainer(name: "TodoCoreD")  // initializing a container
        
    container.loadPersistentStores { (Description, error) in  // associate method with it called
           guard error == nil else {
            print("error \(error!)")
            return
            }
        }
        return container
    }
    
   /*-------(3) creating the method that is responsible for saving deleting and updting -----*/
    
    var managedContext: NSManagedObjectContext{
        return container.viewContext  /*----(4)  now go back to TodoTableViewController to implement it ---*/
    }
    
} /*----------------end of class saveCoreData-------------*/
