//
//  NewsTableViewCell.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import RxSwift

class NewsTableViewCell: UITableViewCell {

    static let id = "NewsTableViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var readIndicatorView: UIView!
    
    
    // MARK: - Public Properties
    
    public var viewModel: NewsCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    var disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        mainImageView.setImage(url: viewModel.coverPhotoUrl)
        
        titleLabel.text = viewModel.title
        categoryLabel.text = viewModel.categoryTitle
        dateLabel.text = DateConverter.sharedInstance.string(from: viewModel.date, withFormat: .fullDayMonthYearDotes)
        readIndicatorView.isHidden = viewModel.isRead
    }
}
