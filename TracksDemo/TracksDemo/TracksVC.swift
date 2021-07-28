//
//  TracksVC.swift
//  TracksDemo
//
//  Created by Sudin on 28/07/21.
//

import UIKit

class TracksVC: UITableViewController {

    var aryTracks: [Result]
    
    @discardableResult
    init(tableViewStyle: UITableView.Style, tracks: [Result]) {
        aryTracks = tracks
        super.init(style: tableViewStyle)
    }
    
    required init?(coder: NSCoder) {
        aryTracks = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryTracks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TracksCell.identifier, for: indexPath) as? TracksCell else {
            fatalError()
        }
        cell.trackData = aryTracks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return TracksCell.estimatedHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

private extension TracksVC {
    func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TracksCell.identifier, bundle: nil), forCellReuseIdentifier: TracksCell.identifier)
        tableView.reloadData()
    }
}
