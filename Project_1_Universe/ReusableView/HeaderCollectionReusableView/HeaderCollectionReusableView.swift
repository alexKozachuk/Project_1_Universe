//
//  HeaderCollectionReusableView.swift
//  Project_1_Universe
//
//  Created by Sasha on 25/01/2021.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var label: UILabel!
    
    var title: String? {
        set {
            label.text = newValue
        }
        get {
            label.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        title = nil
    }
    
}
