//
//  CurrentUserManager.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import RealmSwift

final class CurrentUserManager {
    
    static let sharedInstance = CurrentUserManager()
    
    private init() { }
    
    
    // MARK: - Private Properties
    
    private lazy var readListIds: Set<String> = {
        let array = UserDefaults.standard.array(forKey: Constants.UserDefaults.userReadList) as? [String] ?? []
        return Set(array)
    }()
    
    
    // MARK: - Public Interface
    
    public func addToRead(newsModel: NewsModel) {
        guard !isRead(newsModel: newsModel) else { return }
        
        let id = getId(from: newsModel)
        readListIds.insert(id)
        UserDefaults.standard.setValue(Array(readListIds), forKey: Constants.UserDefaults.userReadList)
    }
    
    public func removeAllRead() {
        readListIds.removeAll()
        UserDefaults.standard.setValue([], forKey: Constants.UserDefaults.userReadList)
    }
    
    public func isRead(newsModel: NewsModel) -> Bool {
        let id = getId(from: newsModel)
        return readListIds.contains(id)
    }
    
    
    // MARK: - Private Methods
    
    private func getId(from news: NewsModel) -> String {
        // identifying news by `name` and `date` combination.
        return "\(news.title ?? "")\(news.date ?? 0)"
    }
}
