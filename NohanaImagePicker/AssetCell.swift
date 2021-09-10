/*
 * Copyright (C) 2016 nohana, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import UIKit

class AssetCell: UICollectionViewCell {

    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    var pickImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    var overlayView: UIView = {
        let view = UIView()
        return view
    }()
    var durationLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 12)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponents()
        self.setupContraints()
    }
    
    private func setupComponents() {
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 13
        
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.pickImage)
        self.contentView.addSubview(self.overlayView)
        self.contentView.addSubview(self.durationLabel)
    }
    
    private func setupContraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.pickImage.translatesAutoresizingMaskIntoConstraints = false
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: [], metrics: nil, views: ["v": self.imageView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: ["v": self.imageView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: ["v": self.overlayView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: ["v": self.overlayView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[v(20)]", options: [], metrics: nil, views: ["v": self.pickImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(20)]-6-|", options: [], metrics: nil, views: ["v": self.pickImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[v]-8-|", options: [], metrics: nil, views: ["v": self.durationLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(10)]-4-|", options: [], metrics: nil, views: ["v": self.durationLabel]))
    }
    
    weak var nohanaImagePickerController: NohanaImagePickerController? {
        didSet {
            if let nohanaImagePickerController = nohanaImagePickerController {
                self.pickImage.image = nohanaImagePickerController.config.image.pickedSmall ?? UIImage(named: "btn_selected_m", in: nohanaImagePickerController.assetBundle, compatibleWith: nil)
            }
        }
    }
    
    private var pickedImage: UIImage? {
        if let nohanaImagePickerController = nohanaImagePickerController {
            return nohanaImagePickerController.config.image.pickedSmall ?? UIImage(named: "btn_selected_m", in: nohanaImagePickerController.assetBundle, compatibleWith: nil)
        }
        return nil
    }
    
    var asset: Asset?
    
    func makeSelect() {
        guard let asset = asset, let nohanaImagePickerController = nohanaImagePickerController else { return }
        let isPicked: Bool = nohanaImagePickerController.pickedAssetList.isPicked(asset)
        print("isPicked:", isPicked)
        if isPicked {
            if nohanaImagePickerController.pickedAssetList.drop(asset: asset) {
                self.overlayView.isHidden = true
                self.pickImage.isHidden = true
            }
        } else {
            if nohanaImagePickerController.pickedAssetList.pick(asset: asset) {
                self.overlayView.isHidden = false
                self.pickImage.isHidden = false
            }
        }
    }

    func update(asset: Asset, nohanaImagePickerController: NohanaImagePickerController) {
        self.asset = asset
        self.nohanaImagePickerController = nohanaImagePickerController
        let isPicked: Bool = nohanaImagePickerController.pickedAssetList.isPicked(asset)
        self.overlayView.isHidden = !isPicked
        self.pickImage.isHidden = !isPicked
    }
}
