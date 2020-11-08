//
//  NewsViewModel.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

import RxSwift
import RxCocoa
import RxDataSources

class NewsViewModel {
    
    // MARK: - Public Properties
    
    // news cells
    var newsCells: Observable<[NewsCellType]> {
        return localNewsCells.asObservable()
    }
    let localNewsCells = BehaviorRelay<[NewsCellType]>(value: [])
   
    // gallery cells
    var galleryCells: Observable<[GalleryCellType]> {
        return localGalleryCells.asObservable()
    }
    let localGalleryCells = BehaviorRelay<[GalleryCellType]>(value: [])
    
    // loading indicator
    var showLoadingHud: Observable<Bool> {
        return loadInProgress.asObservable().distinctUntilChanged()
    }
    let loadInProgress: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    // alert
    let onShowError = PublishSubject<SingleButtonAlert>()
    
    // event
    let gotSelectedNews = BehaviorRelay<NewsCellViewModel?>(value: nil)
    let gotReadNews = BehaviorRelay<NewsCellViewModel?>(value: nil)
    
    
    // MARK: - Standard
    
    let newsRepository: NewsRepository
    let disposeBag = DisposeBag()
    
    
    // MARK: - Private Properties
    
    private var loadingAllowed = true
    
    
    // MARK: - Initializers
    
    init(requestManager: NewsRequestManager = NewsRequestManager()) {
        newsRepository = NewsRepository(requestManager: requestManager)
        
        // events
        gotReadNews.subscribe { [weak self] in
            guard let self = self, let viewModelElement = $0.element, var viewModel = viewModelElement else { return }
            CurrentUserManager.sharedInstance.addToRead(newsModel: viewModel.model)
            viewModel.isRead = true
            self.update(newsCellViewModel: viewModel)
        }.disposed(by: disposeBag)
    }
    
    
    // MARK: - Public Methods
    
    public func getNewsList() {
        guard loadingAllowed else { return }
        loadInProgress.accept(true)
        
        newsRepository.getNewsList().subscribe(
            onNext: { [weak self] newsModels in
                guard let self = self else { return }
                
                // stop loading
                self.loadInProgress.accept(false)
                // allow reloading
                self.loadingAllowed = true
                
                guard !newsModels.isEmpty else {
                    // accept empty cell
                    let errorCell = [NewsCellType.empty]
                    self.localNewsCells.accept(errorCell)
                    return
                }
                
                self.updateLocalDataIfNeeded(newsModels: newsModels)
                
                // accept normal cells
                let items = newsModels.map { NewsCellType.normal(
                    cellViewModel: NewsCellViewModel(
                        model: $0,
                        isRead: CurrentUserManager.sharedInstance.isRead(newsModel: $0)
                    )
                )}
                self.localNewsCells.accept(items)
                
                // accept the selected item
                self.gotSelectedNews.accept(items[0].cellViewModel!)
            },
            onError: { [weak self] error in
                guard let self = self else { return }
                
                // stop loading
                self.loadInProgress.accept(false)
                
                // accept error cell
                let errorCell = [NewsCellType.error(message: error.localizedDescription)]
                self.localNewsCells.accept(errorCell)
                
                // allow reloading
                self.loadingAllowed = true
        }).disposed(by: disposeBag)
    }
    
    func getGalllery(type: GalleryType) {
        guard let selectedNews = gotSelectedNews.value else { return }
        
        let items: [GalleryCellType]
        switch type {
        case .photo:
            items = selectedNews.gallery.map { GalleryCellType.photo(cellViewModel: PhotoCellViewModel(model: $0)) }
        case .video:
            items = selectedNews.video.map { GalleryCellType.video(cellViewModel: VideoCellViewModel(model: $0)) }
        }
        self.localGalleryCells.accept(items)
    }
    
    
    // MARK: - Private Methods
    
    private func update(newsCellViewModel: NewsCellViewModel) {
        var items = localNewsCells.value
        let updatingItem = NewsCellType.normal(cellViewModel: newsCellViewModel)
        guard let index = items.firstIndex(of: updatingItem) else { return }
            
        items[index] = updatingItem
        localNewsCells.accept(items)
    }
    
    private func updateLocalDataIfNeeded(newsModels: [NewsModel]) {
         guard Reachability.sharedInstance.isReachable else { return }
        
        newsRepository.insertNewsList(newsModels).subscribe(
            onNext: { success in
                print("storing local data:", success ? "successed" : "failed")
            }).disposed(by: self.disposeBag)
    }
}
