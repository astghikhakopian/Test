//
//  GalleryCollectionViewCell.swift
//  Test
//
//  Created by Astghik Hakopian on 11/7/20.
//

import RxSwift

enum GalleryType { case photo, video }

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let id = "GalleryCollectionViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var videoIndicatorLabel: UILabel!
    
    
    // MARK: - Public Properties
    
    public var photoCellViewModel: PhotoCellViewModel? {
        didSet {
            bindPhotoViewModel()
        }
    }
    public var videoCellViewModel: VideoCellViewModel? {
        didSet {
            bindVideoViewModel()
        }
    }
    var disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    
    // MARK: - Private Methods
    
    private func bindPhotoViewModel() {
        guard let viewModel = photoCellViewModel else { return }
        
        mainImageView.setImage(url: viewModel.thumbnailUrl)
        videoIndicatorLabel.isHidden = true
    }
    
    private func bindVideoViewModel() {
        guard let viewModel = videoCellViewModel else { return }
        
        mainImageView.setImage(url: viewModel.thumbnailUrl)
        videoIndicatorLabel.isHidden = false
    }
}
