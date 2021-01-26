//
//  TopImageCollectionViewCell.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class TopImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    
    var title: String? {
        get {
            nameLable.text
        }
        set {
            nameLable.text = newValue
        }
    }
    
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    func setup(with item: TopImagePresentable) {
        self.image = item.image
        self.title = item.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        title = nil
        image = nil
    }

}
