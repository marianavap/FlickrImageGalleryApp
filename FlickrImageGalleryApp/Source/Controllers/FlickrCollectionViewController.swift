//
//  FlickrCollectionViewController.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import UIKit

class FickrCollectionViewController: UICollectionViewController {

    struct Constants {
        static let cellsPerRow: Int = 2
        static let loadingCellHeight: CGFloat = 50
        static let insets: CGFloat = 16
        static let margins: CGFloat = CGFloat(cellsPerRow + 1) * insets
        static let marginsLoading: CGFloat = 2 * insets
        static let cellImageMargins: CGFloat = 8.0 * 2.0
        static let cellUsedHeight: CGFloat = cellImageMargins + (4.0 * 2.0) + (3.0 * 20.5)
    }
    
    private var flickrViewModel = FlickrViewModel()
  
    private var value: Bool = false
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .silver
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flickrViewModel.delegate = self
        flickrViewModel.fetch()
        collectionView?.refreshControl = refreshControl
    }
 
}

// MARK: - Private methods
private extension FickrCollectionViewController {
    @objc private func refresh() {
        flickrViewModel.fetch(refresh: true)
    }
}

// MARK: - Delegate
extension FickrCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .urlImage = flickrViewModel.cellType(at: indexPath),
            let flikerCell = cell as? FlickrImageViewCell {
            flikerCell.bannerImage.kf.cancelDownloadTask()
        }
    }
}

// MARK: - Datasource
extension FickrCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrViewModel.numberOfItens(in: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = flickrViewModel.cellType(at: indexPath)
        
        switch cellType {
        case .urlImage(let photoViewModel):
            let cell = collectionView.dequeueReusableCell(viewType: FlickrImageViewCell.self, for: indexPath)
            cell.setup(urlImage: photoViewModel)
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(viewType: FlickrLoadingCell.self, for: indexPath)
            //TODO: Finish Infinity Scroll
                //flickrViewModel.fetch()
            cell.setup()
            return cell
        }
    }
}

// MARK: - FlikerListViewModelDelegate
extension FickrCollectionViewController: FlickrListViewModelDelegate {
    func imageListViewModelWasFetch(_ viewModel: FlickrViewModel) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func imageListViewModel(_ viewModel: FlickrViewModel, threw error: Error) {
         HandleError.handle(error: error)
    }
}

// MARK: - Flow layout
extension FickrCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = flickrViewModel.cellType(at: indexPath)
       
        switch cellType {
        case .urlImage:
            let width = (collectionView.frame.width - Constants.margins)/CGFloat(Constants.cellsPerRow)
            let imageSize: CGFloat = width - Constants.cellImageMargins
            let height: CGFloat = Constants.cellUsedHeight + imageSize
            return CGSize(width: width, height: height)
        case .loading:
            let width = (collectionView.frame.width - Constants.marginsLoading)
            return CGSize(width: width, height: Constants.loadingCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.insets, left: Constants.insets, bottom: Constants.insets, right: Constants.insets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.insets
    }
}
