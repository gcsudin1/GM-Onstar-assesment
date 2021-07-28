//
//  TracksDemoTests.swift
//  TracksDemoTests
//
//  Created by Sudin on 28/07/21.
//

import XCTest
@testable import TracksDemo

class TracksDemoTests: XCTestCase {

    var artistSearchVC: SearchArtistVC!
    
    override func setUpWithError() throws {
        artistSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchArtistVC") as? SearchArtistVC
        artistSearchVC.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        artistSearchVC = nil
    }
    
    func testVerifyNilName() {
        artistSearchVC.searchArtistTF.text = nil
        let verify = artistSearchVC.verify(artistName: artistSearchVC.searchArtistTF.text)
        XCTAssertEqual(verify, false)
    }
    
    func testVerifyWhiteSpacesInName() {
        artistSearchVC.searchArtistTF.text = "  "
        let verify = artistSearchVC.verify(artistName: artistSearchVC.searchArtistTF.text)
        XCTAssertEqual(verify, false)
    }
    
    func testVerifyCorrectName() {
        artistSearchVC.searchArtistTF.text = "abc"
        let verify = artistSearchVC.verify(artistName: artistSearchVC.searchArtistTF.text)
        XCTAssertEqual(verify, true)
    }
}
