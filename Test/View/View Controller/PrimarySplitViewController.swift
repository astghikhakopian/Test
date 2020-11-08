//
//  PrimarySplitViewController.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import UIKit

class PrimarySplitViewController: UISplitViewController {
    
    // MARK: - Public
    
    public private(set) weak var newsTVC: NewsTableViewController?
    public private(set) weak var newsDetailsVC: NewsDetailsViewController?
    
    
    // MARK: - Standard
    
    let newsViewModel = NewsViewModel()
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettings()
        setContent()
    }
}


// MARK: - Custom lifecycle

extension PrimarySplitViewController {
    
    private func configureSettings() {
        delegate = self
    }
    
    private func setContent() {
        guard
            let leftNC = viewControllers.first as? UINavigationController,
            let newsTVC = leftNC.viewControllers.first as? NewsTableViewController,
            let topNC = viewControllers.last as? UINavigationController,
            let newsDetailsVC = topNC.topViewController as? NewsDetailsViewController
        else { return }
        
        newsTVC.newsViewModel = newsViewModel
        newsDetailsVC.newsViewModel = newsViewModel
        
        self.newsTVC = newsTVC
        self.newsDetailsVC = newsDetailsVC
    }
}


// MARK: - UISplitViewControllerDelegate

extension PrimarySplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
    }
    
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
