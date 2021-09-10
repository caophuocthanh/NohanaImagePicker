//
//  NohanaImagePickerNavigationController.swift
//  NohanaImagePicker
//
//  Created by Cao Phuoc Thanh on 9/10/21.
//  Copyright © 2021 nohana. All rights reserved.
//

import UIKit

class NohanaImagePickerNavigationController: UINavigationController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor(hex: 0x007aff)
        self.navigationBar.barTintColor = UIColor(hex: 0xf5f5f5)
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.backgroundColor = UIColor(hex: 0xf5f5f5)
        self.navigationBar.shadowImage = UIColor(hex: 0xdfdfe0).asImage()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.toolbar.tintColor = .white
        self.toolbar.barTintColor = UIColor(hex: 0x007aff)
        self.toolbar.isTranslucent = false
        self.toolbar.backgroundColor = UIColor(hex: 0x007aff)
    }
}
