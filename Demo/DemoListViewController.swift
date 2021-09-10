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
import NohanaImagePicker
import Photos

struct Cell {
    let title: String
    let selector: Selector
}

class DemoListViewController: UITableViewController, NohanaImagePickerControllerDelegate {
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        //
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts: [PHAsset]) {
        //
    }
    

    let cells = [
        Cell(title: "Default", selector: #selector(DemoListViewController.showDefaultPicker)),
        Cell(title: "Large thumbnail", selector: #selector(DemoListViewController.showLargeThumbnailPicker)),
        Cell(title: "No toolbar", selector: #selector(DemoListViewController.showNoToolbarPicker)),
        Cell(title: "Disable to pick assets", selector: #selector(DemoListViewController.showDisableToPickAssetsPicker)),
        Cell(title: "Custom UI", selector: #selector(DemoListViewController.showCustomUIPicker)),
    ]

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = cells[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkIfAuthorizedToAccessPhotos { isAuthorized in
            DispatchQueue.main.async(execute: {
                if isAuthorized {
                    self.perform(self.cells[indexPath.row].selector)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Denied access to photos.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }

    // MARK: - Photos

    func checkIfAuthorizedToAccessPhotos(_ handler: @escaping (_ isAuthorized: Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        handler(true)
                    default:
                        handler(false)
                    }
                }
            }
        case .restricted:
            handler(false)
        case .denied:
            handler(false)
        case .authorized:
            handler(true)
        case .limited:
            handler(true)
        @unknown default:
            fatalError()
        }
    }

    // MARK: - Show NohanaImagePicker

    @objc func showDefaultPicker() {
        let picker = NohanaImagePickerController(mediaType: .any)
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
    }

    @objc func showLargeThumbnailPicker() {
        let picker = NohanaImagePickerController()
        picker.pickerDelegate = self
        picker.numberOfColumnsInPortrait = 2
        picker.numberOfColumnsInLandscape = 3
        present(picker, animated: true, completion: nil)
    }

    @objc func showNoToolbarPicker() {
        let picker = NohanaImagePickerController()
        picker.pickerDelegate = self
        picker.toolbarHidden = true
        present(picker, animated: true, completion: nil)
    }

    @objc func showDisableToPickAssetsPicker() {
        let picker = NohanaImagePickerController()
        picker.pickerDelegate = self
        picker.canPickAsset = { (asset: Asset) -> Bool in
            return asset.identifier % 2 == 0
        }
        present(picker, animated: true, completion: nil)
    }

    @objc func showCustomUIPicker() {
        let picker = NohanaImagePickerController()
        picker.pickerDelegate = self
        picker.config.color.background = UIColor(red: 0xcc/0xff, green: 0xff/0xff, blue: 0xff/0xff, alpha: 1)
        picker.config.color.separator = UIColor(red: 0x00/0xff, green: 0x66/0xff, blue: 0x66/0xff, alpha: 1)
        picker.config.strings.albumListTitle = "🏞"
        picker.config.image.droppedSmall = UIImage(named: "btn_select_m")
        picker.config.image.pickedSmall = UIImage(named: "btn_selected_m")
        present(picker, animated: true, completion: nil)
    }

   
}
