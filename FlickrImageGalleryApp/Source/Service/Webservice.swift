//
//  Webservice.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 28/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import Reachability

/// Image service
protocol ImageServiceProtocol {
    
    /// Gets imahe list
    ///
    /// - Parameters:
    ///   - page: Page number (starting in 1)
    ///   - perPage: Items per page (max = 80)
    ///   - completion: Completion block
    func getImageList(page: Int, perPage: Int, completion: @escaping ((() throws -> (PhotoList)) -> Void))
    
    func getURLImage(idPhoto: String, completion: @escaping ((() throws -> (ValuesURL)) -> Void))
}

class Webservice: ImageServiceProtocol {
    private let session: FlickrURLSession
    private let reachability: FlikerReachability
    
    init(session: FlickrURLSession = URLSession.shared, reachability: FlikerReachability = Reachability(hostName: Constants.WEBSERVICE_BASE_URL)) {
        self.session = session
        self.reachability = reachability
    }
    
    func getURLImage(idPhoto: String, completion: @escaping ((() throws -> (ValuesURL)) -> Void)) {
        
        guard let urlImage = flikerCompleteUrl(method: Constants.SIZES, page: 0, perpage: 0, idPhoto: idPhoto) else {
            completion { throw FlikrError.generic }
            return
        }
        
        session.loadData(from:urlImage) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let upcomingList = try JSONDecoder().decode(ImageURL.self, from: data)
                    let imgList = ValuesURL(getSize: upcomingList.sizes.size)
                    completion { imgList }
                } catch {
                    completion { throw FlikrError.parse(String(describing: ImageURL.self)) }
                }
            }
        }
    }
    
    func getImageList(page: Int, perPage: Int, completion: @escaping ((() throws -> (PhotoList)) -> Void)) {
        guard reachability.internetIsReachable else {
            completion { throw FlikrError.offlineMode }
            return
        }
        
        guard let url = flikerCompleteUrl(method: Constants.SEARCH, page: page, perpage: perPage, idPhoto: "") else {
            completion { throw FlikrError.generic }
            return
        }
        
        session.loadData(from: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let upcomingList = try JSONDecoder().decode(SearchModel.self, from: data)
                    let photoList = PhotoList(getPhotos: upcomingList.photos.photo)
                    completion { photoList }
                } catch {
                    completion { throw FlikrError.parse(String(describing: SearchModel.self)) }
                }
            }
        }
    }
}

private extension Webservice {
    func flikerCompleteUrl(method: String, page: Int, perpage: Int, idPhoto: String) -> URL? {
        var urlComponents = URLComponents(string: Constants.WEBSERVICE_BASE_URL)
        urlComponents?.queryItems = [
            URLQueryItem(name: Constants.nojsoncallback, value: "\(Constants.JSONCALLBACK)"),
            URLQueryItem(name: Constants.format, value: "\(Constants.FORMAT)"),
            URLQueryItem(name: Constants.tags, value: "\(Constants.TAGS)"),
            URLQueryItem(name: Constants.apikey, value: "\(Constants.API_KEY)"),
            URLQueryItem(name: Constants.method, value: "\(method)"),
            URLQueryItem(name: Constants.page, value: "\(page)"),
            URLQueryItem(name: Constants.per_page, value: "\(perpage)"),
            URLQueryItem(name: Constants.photo_id, value: "\(idPhoto)")]
        
        return urlComponents?.url
    }

}
