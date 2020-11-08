//
//  NewsRealmManager.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import RealmSwift
import RxSwift

final class NewsRealmManager {
    
    let realm: Realm
    
    
    // MARK: - Init
    
    init() {
        self.realm = try! Realm()
    }
    
    
    // MARK: - Public Methods
    
    
    // MARK: - SELECT
    
    func getNewsList() -> Observable<[NewsModel]> {

        return Observable.create { [weak self] observer -> Disposable in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let allRealmObjcets = self.realm.objects(NewsRealmModel.self)
                let allObjects = allRealmObjcets.map{ NewsModel(from: $0) }
                
                observer.onNext(Array(allObjects))
            }
            return Disposables.create()
        }
    }
    
    
    // MARK: - INSERT
    
    func insertNewsList(_ newsList: [NewsModel]) -> Observable<Bool> {

        return Observable.create { [weak self] observer -> Disposable in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                do {
                    self.realm.beginWrite()
                    
                    let realmNewsList = newsList.map { NewsRealmModel(from: $0) }
                    self.realm.add(realmNewsList, update: .modified)
                    
                    try self.realm.commitWrite()
                    
                    observer.onNext(true)
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    // MARK: - DELETE
    
    public func removeAll() -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                do {
                    
                    let deletingObject = self.realm.objects(NewsRealmModel.self)
                    
                    self.realm.beginWrite()
                    self.realm.delete(deletingObject)
                    try self.realm.commitWrite()
                    
                    observer.onNext(true)
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
