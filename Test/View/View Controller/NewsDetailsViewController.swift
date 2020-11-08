//
//  NewsDetailsViewController.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import RxSwift

class NewsDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreDescriptionButton: UIButton!
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: view.frame)
        activityIndicator.backgroundColor = view.backgroundColor
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    
    // MARK: - Public Properties
    
    var newsViewModel: NewsViewModel? {
        didSet {
            bindViewModel()
        }
    }
    let disposeBag = DisposeBag()
    
    
    // MARK: - Private Constants
    
    private let descriptionLabelMaxNumberOfLines = 3
    
    // segue
    private let toGalleryViewController = "GalleryViewController"
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuerSettings()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toGalleryViewController:
            let destivationVC = segue.destination as! GalleryViewController
            
            destivationVC.type = sender as! GalleryType
            destivationVC.newsViewModel = newsViewModel
        default:
            break
        }
    }
}


// MARK: - Custom lifecycle

extension NewsDetailsViewController {
    
    private func setContent(viewModel: NewsCellViewModel) {
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        
        mainImageView.setImage(url: viewModel.coverPhotoUrl)

        categoryLabel.text = viewModel.categoryTitle
        dateLabel.text = DateConverter.sharedInstance.string(from: viewModel.date, withFormat: .fullDayMonthYearDotes)
        titleLabel.text = viewModel.title
        descriptionLabel.attributedText = viewModel.body
        
        let linesCount = descriptionLabel.calculateMaxLines()
        moreDescriptionButton.isHidden = linesCount < descriptionLabelMaxNumberOfLines
        moreDescriptionButton.isSelected = false
        descriptionLabel.numberOfLines = descriptionLabelMaxNumberOfLines
        
        galleryButton.isHidden = viewModel.gallery.isEmpty
        videosButton.isHidden = viewModel.video.isEmpty
    }
    
    private func bindViewModel() {
        guard let newsViewModel = newsViewModel else { return }
        
        // events
        newsViewModel.gotSelectedNews.subscribe { [weak self] in
            guard let self = self, let viewModelElement = $0.element, let viewModel = viewModelElement else { return }
            self.setContent(viewModel: viewModel)
        }.disposed(by: disposeBag)
        
        // common
        bindCommonIndicators()
    }
    
    private func configuerSettings() {
        // buttons
        moreDescriptionButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            self.moreDescriptionButton.isSelected = !self.moreDescriptionButton.isSelected
            self.descriptionLabel.numberOfLines = self.moreDescriptionButton.isSelected ? 0 : self.descriptionLabelMaxNumberOfLines
        }.disposed(by: disposeBag)
        galleryButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: self.toGalleryViewController, sender: GalleryType.photo)
        }.disposed(by: disposeBag)
        videosButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: self.toGalleryViewController, sender: GalleryType.video)
        }.disposed(by: disposeBag)
    }
    
    // common alerts, loading
    
    private func bindCommonIndicators() {
        
        newsViewModel?.showLoadingHud
            .map { [weak self] in $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }.subscribe().disposed(by: disposeBag)
        
        newsViewModel?.onShowError
            .map { [weak self] in self?.present(alert: $0)}
            .subscribe().disposed(by: disposeBag)
    }
}

extension NewsDetailsViewController: AlertContainerDelegate {}
