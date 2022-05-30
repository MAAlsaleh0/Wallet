//
//  CoreData.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 25/10/1443 AH.
//

import Foundation
import CoreData

class Coredata : ObservableObject {
    // Responsible for preparing a model
    let container = NSPersistentContainer(name: "Model")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully. WUHU!!!")
        } catch {
            // Handle errors in our database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func AddData(creditCVC:String?,creditDate:String?,creditNUM:String?,ifIsCredit:Bool,ifisOther:Bool,ifisPassWord:Bool,itemName:String,otherAnyThings:String?,password:String?,userName:String?, Context:NSManagedObjectContext) {
        let itemc = Item(context: Context)
        itemc.id = UUID()
        itemc.creditCVC = creditCVC
        itemc.creditDate = creditDate
        itemc.creditNUM = creditNUM
        itemc.date = Date()
        itemc.ifIsCredit = ifIsCredit
        itemc.ifisOther = ifisOther
        itemc.ifisPassWord = ifisPassWord
        itemc.itemName = itemName
        itemc.otherAnyThings = otherAnyThings
        itemc.password = password
        itemc.userName = userName
        save(context: Context)
    }
    
    func UpdateData(item:Item,creditCVC:String?,creditDate:String?,creditNUM:String?,ifIsCredit:Bool,ifisOther:Bool,ifisPassWord:Bool,itemName:String,otherAnyThings:String?,password:String?,userName:String?, Context:NSManagedObjectContext) {
        item.id = item.id
        item.creditCVC = creditCVC
        item.creditDate = creditDate
        item.creditNUM = creditNUM
        item.date = Date()
        item.ifIsCredit = ifIsCredit
        item.ifisOther = ifisOther
        item.ifisPassWord = ifisPassWord
        item.itemName = itemName
        item.otherAnyThings = otherAnyThings
        item.password = password
        item.userName = userName
        save(context: Context)
    }
    
    func removeData(item:Item,context:NSManagedObjectContext) {
        let objectToDelete = context.object(with: item.objectID)
        context.delete(objectToDelete)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func getData() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}
