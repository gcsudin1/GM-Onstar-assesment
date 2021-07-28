//
//  TracksCell.swift
//  TracksDemo
//
//  Created by Sudin on 28/07/21.
//

import UIKit

class TracksCell: UITableViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackPriceLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var primaryGenreNameLabel: UILabel!
    
    static let identifier = "TracksCell"
    static let estimatedHeight: CGFloat = 120
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        artistNameLabel.text = nil
        trackNameLabel.text = nil
        trackPriceLabel.text = nil
        releaseDateLabel.text = nil
        primaryGenreNameLabel.text = nil
    }

    var trackData: Result? {
        didSet {
            guard let data = trackData else {
                return
            }
            artistNameLabel.text = data.artistName
            trackNameLabel.text = data.trackName
            trackPriceLabel.text = "\(data.trackPrice) \(data.currency)"
            releaseDateLabel.text = getLocalDateString(fromUTCDateString: data.releaseDate)
            primaryGenreNameLabel.text = data.primaryGenreName
        }
    }
    
    private func getLocalDateString(fromUTCDateString strDate: String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()//DateFormatter()
        isoDateFormatter.timeZone = TimeZone.current
        guard let date = isoDateFormatter.date(from: strDate) else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
