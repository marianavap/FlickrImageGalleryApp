//
//  FlickrViewModelTest.swift
//  FlickrImageGalleryAppTests
//
//  Created by Mariana V. A. Souza on 01/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

//TODO: Finish ViewModel Unit Test

//@testable import FlickrImageGalleryApp
//
//class FlikerServiceMock: FlickrServiceProtocol {
//    typealias ParamsAssertionType = (Int, Int) -> Void
//
//    var photoList: PhotoList?
//    private var error: Error?
//    var paramsAssertion: ParamsAssertionType?
//
//    init(photoList: PhotoList? = nil, error: Error? = nil, paramsAssertion: ParamsAssertionType? = nil) {
//        self.imageList = imageList
//        self.error = error
//        self.paramsAssertion = paramsAssertion
//    }
//
//    func getImageList(page: Int, perPage: Int, completion: @escaping ((() throws -> (PhotoList)) -> Void)) {
//        paramsAssertion?(page, perPage)
//        if let error = error {
//            completion { throw error }
//        } else if let photoList = photoList {
//            completion { photoList }
//        }
//    }
//
//    class FlickrListViewModelDelegateMock: FlickrListViewModelDelegate {
//        typealias ModelWasFetchAssertionType = (FlickrListViewModel) -> Void
//        typealias ModelThrewErrorAssertionType = (FlickrListViewModel, Error) -> Void
//        private var modelWasFetchAssertion: ModelWasFetchAssertionType?
//        private var modelThrewErrorAssertion: ModelThrewErrorAssertionType?
//
//        init(modelWasFetchAssertion: ModelWasFetchAssertionType? = nil,
//             modelThrewErrorAssertion: ModelThrewErrorAssertionType? = nil) {
//            self.modelWasFetchAssertion = modelWasFetchAssertion
//            self.modelThrewErrorAssertion = modelThrewErrorAssertion
//        }
//
//        func imageListViewModelWasFetch(_ viewModel: FlickrListViewModel) {
//            modelWasFetchAssertion?(viewModel)
//        }
//
//        func imageListViewModel(_ viewModel: FlickrListViewModel, threw error: Error) {
//            modelThrewErrorAssertion?(viewModel, error)
//        }
//    }
//
//    class FlickrListViewModelTests: BaseTests {
//        func testSuccessfullFetch() {
//            //Arrange
//            let expectation = self.expectation(description: "Delegate was called")
//            let flickr = PhotoList(id: "47983647051")
//
//            let photoList = AllPhotoID(photo: [photo])
//
//            let photoServiceMock = FlickrServiceMock(photoList: photoList)
//
//            let vm = FlickrListViewModel(flickrService: photoServiceMock)
//
//            let vmDelegate = FlickrListViewModelDelegateMock(modelWasFetchAssertion: { viewModel in
//                expectation.fulfill()
//                XCTAssertTrue(viewModel === vm)
//            })
//
//            vm.delegate = vmDelegate
//
//            vm.fetch()
//
//            //Assert
//            waitForExpectations(timeout: 1)
//
//            XCTAssertEqual(vm.id, photoList.photoid)
//        }
//    }
//}
