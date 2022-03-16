//
//  ShortAlbum.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation
import Case4Api

struct ShortAlbum{
    let artistName:String
    let genres:[String]
    
    init(album:Album){
        artistName = album.artistName
        genres = album.genres.map({$0.name})
    }
}

