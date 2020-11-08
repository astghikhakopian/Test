//
//  GalleryViewController.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import RxSwift
import RxDataSources
import ImageSlideshow

class GalleryViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Standard
    
    var newsViewModel: NewsViewModel?
    var type: GalleryType = .photo
    let disposeBag = DisposeBag()
    
    
    // MARK: - Private Constants
    
    private let itemsPerRow: CGFloat = 3
    private var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettings()
        bindViewModel()
        setContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


// MARK: - Custom lifecycle

extension GalleryViewController {
    
    private func configureSettings() {
        collectionView.register(UINib(nibName: GalleryCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: GalleryCollectionViewCell.id)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setContent() {
        newsViewModel?.getGalllery(type: type)
        
        switch type {
        case .photo: title = "Gallery"  // TODO: - Localize
        case .video: title = "Videos"   // TODO: - Localize
        }
    }
    
    private func bindViewModel() {
        bindCollectionViewDataSource()
        bindCellSelection()
    }
}

// MARK: - Private Methods

extension GalleryViewController {
    
    private func setMessage(_ message: String?) {
        guard let message = message else {
            collectionView.backgroundView = nil
            return
        }
        
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        collectionView.backgroundView = messageLabel
    }
    
    private func showPhotoSlider(currentMedia: PhotoCellViewModel, indexPath: IndexPath) {
        guard let galleryItems = newsViewModel?.localGalleryCells.value, !galleryItems.isEmpty else { return }
        let index = galleryItems.firstIndex(where: {$0.photoCellViewModel?.id == currentMedia.id}) ?? 0
        let kfDatasourceItems = galleryItems.compactMap { KingfisherSource(urlString: $0.photoCellViewModel?.contentUrl?.absoluteString ?? "") }

        let fullScreenController = FullScreenSlideshowViewController()
        fullScreenController.inputs = kfDatasourceItems
        fullScreenController.initialPage = index
        
        if let cell = collectionView.cellForItem(at: indexPath), let imageView = (cell as? GalleryCollectionViewCell)?.mainImageView {
            slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(imageView: imageView, slideshowController: fullScreenController)
            fullScreenController.modalPresentationStyle = .fullScreen
            fullScreenController.transitioningDelegate = slideshowTransitioningDelegate
        }
        
        fullScreenController.slideshow.currentPageChanged = { [weak self] page in
            if let cell = self?.collectionView.cellForItem(at: IndexPath(row: page, section: 0)), let imageView = (cell as? GalleryCollectionViewCell)?.mainImageView {
                self?.slideshowTransitioningDelegate?.referenceImageView = imageView
            }
        }
        present(fullScreenController, animated: true, completion: nil)
    }
    
    private func showVideoSlider(currentMedia: VideoCellViewModel, indexPath: IndexPath) {
        guard let galleryItems = newsViewModel?.localGalleryCells.value, !galleryItems.isEmpty else { return }
        let index = galleryItems.firstIndex(where: {$0.videoCellViewModel?.id == currentMedia.id}) ?? 0

        let youtubePlayerSliderSource = galleryItems.map {
            YoutubePlayerSliderSource(
                youtubeId: $0.videoCellViewModel?.youtubeId ?? "",
                thumbnailUrl: $0.videoCellViewModel?.thumbnailUrl
            )
        }
        
        let fullScreenController = FullScreenSlideshowViewController()
        fullScreenController.setInputs(youtubePlayerSliderSource)
        fullScreenController.initialPage = index
        
        if let cell = collectionView.cellForItem(at: indexPath), let imageView = (cell as? GalleryCollectionViewCell)?.mainImageView {
            slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(imageView: imageView, slideshowController: fullScreenController)
            fullScreenController.modalPresentationStyle = .fullScreen
            fullScreenController.transitioningDelegate = slideshowTransitioningDelegate
        }
        
        fullScreenController.slideshow.currentPageChanged = { [weak self] page in
            guard let cell = self?.collectionView.cellForItem(at: IndexPath(row: page, section: 0)), let imageView = (cell as? GalleryCollectionViewCell)?.mainImageView else { return }
            self?.slideshowTransitioningDelegate?.referenceImageView = imageView
        }
        fullScreenController.slideshow.willBeginDragging = { [weak fullScreenController] in
            fullScreenController?.slideshow.pauseYoutubePlayer()
        }
        fullScreenController.slideshow.didEndDecelerating = { [weak fullScreenController] in
            fullScreenController?.slideshow.playYoutubePlayer()
        }
        present(fullScreenController, animated: true, completion: nil)
    }
}

// MARK: - Binding

extension GalleryViewController {
    
    private func bindCollectionViewDataSource() {
        newsViewModel?.localGalleryCells.bind(to: collectionView.rx.items) { [unowned self] collectionView, index, element in
            self.makeCell(with: element, from: collectionView, indexPath: IndexPath(row: index, section: 0))
        }.disposed(by: disposeBag)
    }
    
    private func bindCellSelection() {
        collectionView.rx.itemSelected.subscribe(
            onNext: { [weak self] indexPath in
                guard let self = self, let cellValues = self.newsViewModel?.localGalleryCells.value, indexPath.item < cellValues.count else { return }
                let cellType = cellValues[indexPath.item]

                switch cellType {
                case .photo(let cellViewModel):
                    self.showPhotoSlider(currentMedia: cellViewModel, indexPath: indexPath)
                case .video(let cellViewModel):
                    self.showVideoSlider(currentMedia: cellViewModel, indexPath: indexPath)
                default: break
                }
               
        }).disposed(by: disposeBag)
    }
    
    private func makeCell(with element: GalleryCellType, from collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch element {
        case .photo(let cellViewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.id, for: indexPath) as! GalleryCollectionViewCell
            
            cell.photoCellViewModel = cellViewModel
            cell.isHidden = false
            setMessage(nil)
            
            return cell
        case .video(let cellViewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.id, for: indexPath) as! GalleryCollectionViewCell
            
            cell.videoCellViewModel = cellViewModel
            cell.isHidden = false
            setMessage(nil)
            
            return cell
        case .error(let message):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.id, for: indexPath)
            setMessage(message)
            cell.isUserInteractionEnabled = false
            cell.isHidden = true
            return cell
        case .empty:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.id, for: indexPath)
            setMessage("No Data Available") // TODO: - Localize
            cell.isUserInteractionEnabled = false
            cell.isHidden = true
            return cell
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width / itemsPerRow - 1
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
