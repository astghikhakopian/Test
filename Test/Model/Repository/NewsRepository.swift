//
//  NewsRepository.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

import RxSwift

class NewsRepository {
    
    // MARK: - Private Properties
    
    private let requestManager: NewsRequestManager
    private let realmManager: NewsRealmManager
    
    private let mainScheduler: SchedulerType
    private let backgroundScheduler: SchedulerType
    
    
    // MARK: - Init
    
    init(
        requestManager: NewsRequestManager = NewsRequestManager(),
        realmManager: NewsRealmManager = NewsRealmManager(),
        backgroundScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background),
        mainScheduler: SchedulerType = MainScheduler.instance
    ) {
        self.requestManager = requestManager
        self.realmManager = realmManager
        
        self.mainScheduler = mainScheduler
        self.backgroundScheduler = backgroundScheduler
    }
    
    
    // MARK: - News
    
    func getNewsList() -> Observable<[NewsModel]> {
        
         if Reachability.sharedInstance.isReachable {
            return requestManager.getNewsList()
                .subscribeOn(backgroundScheduler)
                .observeOn(mainScheduler)
                .do(onError: { error in return })
        } else {
            return realmManager.getNewsList()
                .subscribeOn(backgroundScheduler)
                .observeOn(mainScheduler)
                .do(onError: { error in return })
        }
    }
    
    func insertNewsList(_ newsList: [NewsModel]) -> Observable<Bool> {
        return realmManager.insertNewsList(newsList)
            .subscribeOn(backgroundScheduler)
            .observeOn(mainScheduler)
            .do(onError: { error in return })
    }
}
