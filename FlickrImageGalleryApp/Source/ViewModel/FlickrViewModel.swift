//
//  FlickrViewModel.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

/// Delegate to comunicate with controller
protocol FlickrListViewModelDelegate: class {
    /// Called when the list of flickr is updated
    ///
    /// - Parameter viewModel: FlickrListViewModel
    func imageListViewModelWasFetch(_ viewModel: FlickrViewModel)
    
    /// Called when some error happen
    ///
    /// - Parameters:
    ///   - viewModel: FlickrListViewModel
    ///   - error: Error
    func imageListViewModel(_ viewModel: FlickrViewModel, threw error: Error)
}

class FlickrViewModel {
    weak var delegate: FlickrListViewModelDelegate?
    
    private var page: Int = 0
    private var service: ImageServiceProtocol
    private var fetchCompleted = false
    private var isFetching = false
    private var error = false

    private(set) var idPhotos: [AllPhotoID] = []
    private(set) var urlImage: [ShowInView] = []

    private var photo = AllPhotoID()
    private var imagesValues = ShowInView()
    private var getLargeImages: Array<ShowInView> = Array()
    
    init(flickrService: ImageServiceProtocol = Webservice()) {
        self.service = flickrService
    }
}

// MARK: - Private
private extension FlickrViewModel {
    struct Constants {
        static let pageSize: Int = 8
        static let correctLabel: String = "Large Square"
    }
    
    func refresh() {
        page = 0
        fetchCompleted = false
    }
}

extension FlickrViewModel {
    /// Possible cell types
    ///
    /// - image: flickr cell
    /// - loading: loading cell
    enum CellType {
        case urlImage(ShowInView)
        case loading
    }
    
    /// Number of items in section
    ///
    /// - Parameter section: section
    /// - Returns: number of itens
    func numberOfItens(in section: Int) -> Int {
        let addLoadingCell = fetchCompleted || error ? 0 : 1

        return getLargeImages.count + addLoadingCell
    }
    
    /// Cell type at index path
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: Cell type
    func cellType(at indexPath: IndexPath) -> CellType {
        if indexPath.row > getLargeImages.count - 1 {
            return .loading
        }
        
        return .urlImage(getLargeImages[indexPath.row])
    }
    
    /// Fetches image list
    ///
    /// - Parameter refresh: True if screen is being refreshed
    func fetch(refresh: Bool = false) {
        guard (!fetchCompleted && !isFetching) || !isFetching else {
            return
        }
        
        if refresh {
            self.refresh()
        }
        
        page += 1
        
        service.getImageList(page: page, perPage: Constants.pageSize) { [weak self] (callback) in
            guard let weakSelf = self else { return }
            do {
                let imageList = try callback()
                if refresh {
                    weakSelf.idPhotos = []
                }
       
                if imageList.getPhotos.isEmpty {
                    weakSelf.fetchCompleted = true
                } else {
                    weakSelf.idPhotos.append(contentsOf: imageList.getPhotos.map({ (photo) -> AllPhotoID in
                        AllPhotoID(photo)
                    }))
                }
                self?.getSourceUrl()
            } catch {
                weakSelf.delegate?.imageListViewModel(weakSelf, threw: error)
                weakSelf.error = true
                weakSelf.page -= 1
            }
        }
    }
    
    func getSourceUrl() {
         isFetching = true
        self.urlImage.removeAll()
        for imageid in self.idPhotos {
            error = false
            service.getURLImage(idPhoto: imageid.photoid) { [weak self] (callback) in
                guard let weakSelf = self else { return }
                do {
                    let imageList = try callback()
                    if imageList.getSize.isEmpty {
                        weakSelf.fetchCompleted = true
                    } else {
                        weakSelf.urlImage.append(contentsOf: imageList.getSize.map({ (imagesValues) -> ShowInView in
                            ShowInView(imagesValues)
                        }))
                    }
                    weakSelf.getImageLargeSize(allimages: weakSelf.urlImage)
                    weakSelf.delegate?.imageListViewModelWasFetch(weakSelf)
                } catch {
                    weakSelf.delegate?.imageListViewModel(weakSelf, threw: error)
                    weakSelf.error = true
                    weakSelf.delegate?.imageListViewModelWasFetch(weakSelf)
                }
                weakSelf.isFetching = false
            }
        }
    }
    

    
    func getImageLargeSize (allimages: [ShowInView]) {
        getLargeImages.removeAll()
        for item in allimages {
            if item.label == Constants.correctLabel {
                getLargeImages.append(item)
            }
        }
    }
    
}
