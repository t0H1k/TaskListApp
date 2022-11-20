//
//  StorageManager.swift
//  TaskList
//
//  Created by Anton Boev on 20.11.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return taskList
    }
    
    func saveTask(in taskList: inout [Task], taskName: String) {
        let task = Task(context: persistentContainer.viewContext)
        task.title = taskName
        taskList.append(task)
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteTask(in taskList: inout [Task], with index: Int) {
        let task = taskList.remove(at: index)
        persistentContainer.viewContext.delete(task)
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
