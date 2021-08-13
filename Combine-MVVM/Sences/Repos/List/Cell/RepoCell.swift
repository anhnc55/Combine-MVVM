//
//  RepoCell.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import UIKit
import SDWebImage

final class RepoCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageColorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 3.0
        avatarImageView.layer.cornerCurve = .continuous
        avatarImageView.layer.masksToBounds = true
    }
    
    func configCell(_ repo: Repository?) {
        avatarImageView.sd_setImage(with: repo?.owner?.avatarUrl, completed: nil)
        nameLabel.text = repo?.owner?.login
        repoNameLabel.text = repo?.name
        descriptionLabel.text = repo?.description
        starCountLabel.text = String(repo?.stargazersCount ?? 0)
        languageLabel.text = repo?.language
        languageColorImageView.tintColor = .random()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
}
