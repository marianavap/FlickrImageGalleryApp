//
//  Photos.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

struct AllPhotoID {
    private(set) var photoid: String = String()
}

extension AllPhotoID {
    init(_ photo: Photo) {
        photoid = photo.id
    }
}
