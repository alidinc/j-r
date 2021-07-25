//
//  SnippetTableViewCell.swift
//  jør
//
//  Created by Ali Dinç on 24/07/2021.
//

import UIKit

class SnippetTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties

    var snippet: Snippet? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods

    func updateViews() {
        guard let snippet = snippet else { return }
        nameLabel.text = snippet.name
        dateLabel.text = "\(snippet.date)"
    }
}
