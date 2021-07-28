//
//  SearchArtistVC.swift
//  TracksDemo
//
//  Created by Sudin on 28/07/21.
//

import UIKit

class SearchArtistVC: UIViewController {

    @IBOutlet weak var searchArtistTF: UITextField!
    @IBOutlet weak var searchArtistBTN: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let baseURL = "https://itunes.apple.com/search?term="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func verify(artistName name: String?) -> Bool {
        guard let name = searchArtistTF.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        return true
    }
}

private extension SearchArtistVC {
    func setupUI() {
        searchArtistTF.delegate = self
        searchArtistTF.returnKeyType = .search
        searchArtistTF.spellCheckingType = .no
        searchArtistTF.autocorrectionType = .no
        
        searchArtistBTN.layer.cornerRadius = 9
        searchArtistBTN.addTarget(self, action: #selector(searchArtistButtonClick), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardIfNeeded))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func searchArtistButtonClick() {
        callSearchApi(withArtistName: searchArtistTF.text)
        hideKeyboardIfNeeded()
        searchArtistTF.text = nil
    }
    
    func callSearchApi(withArtistName name: String?) {
        guard verify(artistName: name), let artistName = name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            showAlert(withMessage: "Please enter artist name to search")
            return
        }
        let strURL = baseURL + artistName
        guard let apiURL = URL(string: strURL) else { return }
        showActivityIndicator()
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            strongSelf.hideActivityIndicator()
            guard let data = data else {
                strongSelf.showAlert(withMessage: "Something went wrong. Please try again")
                return
            }
            guard data.count > 0 else {
                strongSelf.showAlert(withMessage: "No artist found. Please try again")
                return
            }
            do {
                let modelObj = try JSONDecoder().decode(ArtistResultModel.self, from: data)
                let tracks = modelObj.results
                guard !tracks.isEmpty else {
                    strongSelf.showAlert(withMessage: "No artist found. Please try again")
                    return
                }
                strongSelf.navigateToTracksScreen(withTracks: tracks)
            } catch let err {
                strongSelf.showAlert(withMessage: err.localizedDescription)
            }
        }.resume()
    }
    
    func navigateToTracksScreen(withTracks tracks: [Result]) {
        DispatchQueue.main.async { [weak self] in
            let trackVC = TracksVC(tableViewStyle: .plain, tracks: tracks)
            self?.navigationController?.pushViewController(trackVC, animated: true)
        }
    }
    
    @objc func hideKeyboardIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.searchArtistTF.isFirstResponder {
                strongSelf.searchArtistTF.resignFirstResponder()
            }
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension SearchArtistVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchArtistTF {
            callSearchApi(withArtistName: searchArtistTF.text)
            searchArtistTF.text = nil
            hideKeyboardIfNeeded()
            return true
        }
        return false
    }
}
