//
//  ShortAlbum.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import Foundation
import Case4Api

 struct ShortAlbum{
     // I create this class because it prevent any input from network layer to my view controller
    let artistName:String
    let genres:[String]
    
    init(album:Album){
        artistName = album.artistName
        genres = album.genres.map({$0.name})
    }
}

