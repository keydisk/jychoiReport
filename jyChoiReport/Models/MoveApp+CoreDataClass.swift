//
//  MoveApp+CoreDataClass.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/21/24.
//
//

import Foundation
import CoreData

@objc(MoveApp)
public class MoveApp: NSManagedObject {

    static let entitiName = "MoveApp"
    
    convenience init() {
        
        let tmpContext = MoveApp.context
        let coreDataEntityDescription = NSEntityDescription.entity(forEntityName: MoveApp.entitiName, in: tmpContext!)
        
        self.init(entity: coreDataEntityDescription!, insertInto: MoveApp.context)
    }
    
    static var context: NSManagedObjectContext! {
        
        // 메인 스래드 판단
        if OperationQueue.current == OperationQueue.main {
            
            return self.mainContext
        } else {
            
            return self.privateContext
        }
    }
    
    private static var _mainContext: NSManagedObjectContext!
    private static var mainContext: NSManagedObjectContext! {
        
        if self._mainContext == nil {
            
            guard let modelURL = Bundle.main.url(forResource: "AppLocalData", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
            }
            // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Error initializing mom from: \(modelURL)")
            }
            
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
            
            self._mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            self._mainContext.persistentStoreCoordinator = psc
            
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("AppLocalData.sqlite")
            
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL,
                                           options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true] )
                
            } catch {
                
                print("Error migrating store: \(error.localizedDescription)")
                fatalError("Error migrating store: \(error)")
            }
        }
        
        return self._mainContext!
    }
    
    private static var _privateContext: NSManagedObjectContext!
    private static var privateContext: NSManagedObjectContext! {
        
        if self._privateContext == nil {
            
            guard let modelURL = Bundle.main.url(forResource: "AppLocalData", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
            }
            // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Error initializing mom from: \(modelURL)")
            }
            
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
            
            self._privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            self._privateContext.persistentStoreCoordinator = psc
            
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            
            let storeURL = docURL.appendingPathComponent("AppLocalData.sqlite")
            
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL,
                                           options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true] )
                
            } catch {
                
                print("Error migrating store: \(error.localizedDescription)")
                fatalError("Error migrating store: \(error)")
            }
        }
        
        return self._privateContext!
    }
    
    
    /// 동일한 데이터 조회
    ///
    /// - Returns: 모든 코어 데이터
    static func getData(model: Article) -> [MoveApp]? {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: MoveApp.entitiName, in: MoveApp.context)
        
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        let pred =  NSPredicate(format: "(checkID=%@)", model.url)
        request.predicate = pred
        request.entity = entityDescription
        
        do {
            let list = try MoveApp.context.fetch(request) as? [MoveApp]
            
            return list
        } catch let error as NSError {
            
        }
        
        return nil
    }
    
    #if DEBUG
    static func getData() -> [MoveApp]? {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: MoveApp.entitiName, in: MoveApp.context)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        do {
            let list = try MoveApp.context.fetch(request) as? [MoveApp]
            
            return list
        } catch let error as NSError {
            
            print("\(#function) error : \(error)")
        }
        
        return nil
    }
    #endif
    
    static let sync = NSLock()
    
    /// 데이터 저장
    static func saveData()  {
        
        defer {
            self.sync.unlock()
        }
        
        self.sync.lock()
        guard MoveApp.context.hasChanges else {
            return
        }
        
        try? MoveApp.context.save()
    }
    
    /// 데이터 전체 삭제
    ///
    /// - Parameter datas: 삭제할 데이터
    public static func removeAllData() {
        
        MoveApp.getData()?.forEach({ model in
            MoveApp.context.delete(model)
        })
        
        guard MoveApp.context.hasChanges else {
            return
        }
        
        do {
            try MoveApp.context.save()
        } catch let error {
            debugPrint("error : \(error as NSError)")
        }
        
    }
}
