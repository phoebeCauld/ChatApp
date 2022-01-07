//
//  Extensions.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 06.01.2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(with url: String?) {
        guard let urlString = url else { return }
        let url = URL(string: urlString)
        self.sd_setImage(with: url)
    }
}

