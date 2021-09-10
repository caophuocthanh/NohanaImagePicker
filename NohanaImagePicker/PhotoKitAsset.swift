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
import Photos

public class PhotoKitAsset: Asset {
    
    public var durationString: String? {
        guard self.asset.mediaType == .video else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        let formattedDuration = formatter.string(from: self.duration)
        return formattedDuration
    }
    
    let asset: PHAsset

    public init(asset: PHAsset) {
        self.asset = asset
    }

    public var originalAsset: PHAsset {
        return asset as PHAsset
    }
    
    public var duration: TimeInterval {
        return self.asset.duration
    }

    // MARK: - Asset

    public var identifier: Int {
        return asset.localIdentifier.hash
    }

    public func image(targetSize: CGSize, handler: @escaping (ImageData?) -> Void) {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true

        _ = PHImageManager.default().requestImage(
            for: self.asset,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: option ) { (image, info) -> Void in
                guard let image = image else {
                    handler(nil)
                    return
                }
                handler(ImageData(image: image, info: info as Dictionary<NSObject, AnyObject>?))
        }
    }
}
