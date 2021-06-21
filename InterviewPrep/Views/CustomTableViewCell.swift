//
//  CustomTableViewCell.swift
//  InterviewPrep
//
//  Created by Raghu, Reshma L on 11/02/21.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    var imageModel: ImageModel! {
        didSet {
            setupData()
        }
    }
    
    func setupData() {
        title.text = imageModel.data[0].title
        dateCreated.text = imageModel.data[0].date_created
            
        if let imageURL = URL(string: imageModel.links[0].href) {
            thumbnailView.sd_setImage(with: imageURL,
                                      placeholderImage: UIImage(systemName: "photo.circle"),
                                      options: SDWebImageOptions.progressiveLoad,
                                      context: nil)
        } else {
            thumbnailView.image = UIImage(systemName: "photo.circle")
        }
    }
}
