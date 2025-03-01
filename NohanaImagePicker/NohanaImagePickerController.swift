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
import Photos

public enum MediaType: Int {
    case any = 0, photo, video
}

@objc public protocol NohanaImagePickerControllerDelegate {
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController)
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts: [PHAsset])
}

open class NohanaImagePickerController: UIViewController {

    open var maximumNumberOfSelection: Int = 21 // set 0 to no limit
    open var numberOfColumnsInPortrait: Int = 4
    open var numberOfColumnsInLandscape: Int = 4
    open weak var pickerDelegate: NohanaImagePickerControllerDelegate?
    open var shouldShowMoment: Bool = true
    open var toolbarHidden: Bool = false
    open var canPickAsset = { (asset: Asset) -> Bool in
        return true
    }
    open var config: Config = Config()

    lazy var assetBundle: Bundle = {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "NohanaImagePicker", ofType: "bundle") {
            return Bundle(path: path)!
        }
        return bundle
    }()
    let pickedAssetList: PickedAssetList
    let mediaType: MediaType
    fileprivate let assetCollectionSubtypes: [PHAssetCollectionSubtype]

    public init() {
        assetCollectionSubtypes = [.any]
        mediaType = .any
        pickedAssetList = PickedAssetList()
        super.init(nibName: nil, bundle: nil)
        self.pickedAssetList.nohanaImagePickerController = self
    }
    
    public init(assetCollectionSubtypes: [PHAssetCollectionSubtype] = [.any], mediaType: MediaType) {
        self.assetCollectionSubtypes = assetCollectionSubtypes
        self.mediaType = mediaType
        pickedAssetList = PickedAssetList()
        super.init(nibName: nil, bundle: nil)
        self.pickedAssetList.nohanaImagePickerController = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        super.loadView()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // show albumListViewController
        let storyboard = UIStoryboard(name: "NohanaImagePicker", bundle: assetBundle)
        let viewControllerId = "AlbumListViewController"
        guard let albumListViewController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? AlbumListViewController else {
            fatalError("navigationController init failed.")
        }
        albumListViewController.photoKitAlbumList =
            PhotoKitAlbumList(
                assetCollectionTypes: [.smartAlbum, .album],
                assetCollectionSubtypes: assetCollectionSubtypes,
                mediaType: mediaType,
                handler: { [weak albumListViewController] in
                DispatchQueue.main.async(execute: { () -> Void in
                    albumListViewController?.isLoading = false
                    albumListViewController?.tableView.reloadData()
                })
            })
        albumListViewController.nohanaImagePickerController = self
        
        let navigationController = NohanaImagePickerNavigationController(rootViewController: albumListViewController)
        
        addChild(navigationController)

        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
    }

    open func pickAsset(_ asset: Asset) {
        _ = pickedAssetList.pick(asset: asset)
    }

    open func dropAsset(_ asset: Asset) {
        _ = pickedAssetList.drop(asset: asset)
    }
}

extension NohanaImagePickerController {
    public struct Config {
        public struct Color {
            public var background: UIColor?
            public var empty: UIColor?
            public var separator: UIColor?
        }
        public var color = Color()

        public struct Image {
            public var pickedSmall: UIImage?
            public var pickedLarge: UIImage?
            public var droppedSmall: UIImage?
            public var droppedLarge: UIImage?
        }
        public var image = Image()

        public struct Strings {
            public var albumListTitle: String?
            public var albumListMomentTitle: String?
            public var albumListEmptyMessage: String?
            public var albumListEmptyDescription: String?
            public var toolbarTitleNoLimit: String?
            public var toolbarTitleHasLimit: String?
        }
        public var strings = Strings()
    }
}
