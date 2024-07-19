//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import CoreData

struct PersistenceController {

    // MARK: Public properties

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
            try DefaultData(viewContext: viewContext).apply()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    private let inMemory: Bool

    // MARK: Init

    /// To get any errors when loading persistent stores:
    /// Set loadStores parameter to false and call loadPersistentStores method with completion handler

    init(inMemory: Bool = false, loadStores: Bool = true) {
        container = NSPersistentContainer(name: "Arista")
        self.inMemory = inMemory
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        if loadStores {
            loadPersistentStores()
        }
    }
}

// MARK: Load persistent stores

extension PersistenceController {

    func loadPersistentStores(completion: @escaping (Result<Void, AppError>) -> Void = { _ in }) {
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
                completion(.failure(.loadPersistentStores))
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Add default data
        do {
            if !inMemory {
                try DefaultData(viewContext: container.viewContext).apply()
            }
            completion(.success(()))
        } catch {
            completion(.failure(.loadPersistentStores))
        }
    }
}
