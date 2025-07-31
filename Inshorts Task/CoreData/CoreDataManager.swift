import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data load error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func fetchAllBookmarksData() -> [Int:Bookmarks] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        var data: [Int:Bookmarks] = [:]
        do {
            let movies = try context.fetch(fetchRequest)
            for movie in movies {
                data[Int(movie.id)] = movie
            }
        } catch {
            print("Failed to fetch movies: \(error)")
        }
        return data
    }
    
    func deleteBookmark(_ movie: Bookmarks) {
        let context = CoreDataManager.shared.context
        context.delete(movie)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete the bookmark: \(error)")
        }
    }
    
    func deleteAllBookmarks() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        do {
            let movies = try context.fetch(fetchRequest)
            for movie in movies {
                deleteBookmark(movie)
            }
        } catch {
            print("Failed to fetch movies: \(error)")
        }
    }
    
    func deleteAllTrending() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Trending> = Trending.fetchRequest()

        do {
            let allTrending = try context.fetch(fetchRequest)
            for trending in allTrending {
                context.delete(trending)
            }
            try context.save()
            print("Deleted all Trending manually.")
        } catch {
            print("Error deleting Trending: \(error)")
        }
    }
    
    func deleteAllNowPlaying() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<NowPlaying> = NowPlaying.fetchRequest()

        do {
            let allNowPlaying = try context.fetch(fetchRequest)
            for trending in allNowPlaying {
                context.delete(trending)
            }
            try context.save()
            print("Deleted all Now Playing manually.")
        } catch {
            print("Error deleting Trending: \(error)")
        }
    }
    
    func fetchAllTrendingData() -> [Trending] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Trending> = Trending.fetchRequest()
        do {
            let movies = try context.fetch(fetchRequest)
            return movies
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }

    func fetchAllNowPlayingData() -> [NowPlaying] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<NowPlaying> = NowPlaying.fetchRequest()
        do {
            let movies = try context.fetch(fetchRequest)
            return movies
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
}
