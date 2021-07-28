//
//  ArtistResultModel.swift
//  TracksDemo
//
//  Created by Sudin on 28/07/21.
//

import Foundation

// MARK: - SuccessModel
struct ArtistResultModel: Codable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let artistName: String
    let trackName: String
    let trackPrice: Double
    let trackRentalPrice, collectionHDPrice, trackHdPrice, trackHdRentalPrice: Double?
    let releaseDate: String
    let country: String
    let currency: String
    let primaryGenreName: String
}
