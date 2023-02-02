//
//  UIImage+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/07/12.
//

import UIKit
import Photos

public extension UIImage {

    var width: CGFloat {
        return self.size.width
    }
    
    var height: CGFloat {
        return self.size.height
    }
}


// Save Image
public extension UIImage {
    
    func saveImage(location: CLLocation?, completion: @escaping () -> Void) {
        
        PHPhotoLibrary.shared().performChanges({
            
            let createRequest = PHAssetChangeRequest.creationRequestForAsset(from: self)
            createRequest.creationDate = Date()
            createRequest.location = location
            
        }, completionHandler: { (success, error) in
            
            if success {
                print("success")
            } else {
                print("fail")
            }
            
            completion()
        })
    }
    
    func saveImage(exif: NSDictionary?, albumName: String?, jpeg: Bool = true, completion: @escaping () -> Void) {
    
        saveImageWithExif(exif: exif, jpeg: jpeg, completion: { (data, url) in
            
            if let albumName = albumName {
                
                // check album
                let folderOption = PHFetchOptions()
                folderOption.predicate = NSPredicate(format: "localizedTitle = %@", albumName)
                
                let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: folderOption)
                if result.count > 0
                {
                    self.saveImageToCameraRoll(url as URL, result.firstObject, completion: {
                        completion()
                    })
                }
                else
                {
                    // make album
                    var placeHolder = PHObjectPlaceholder()
                    PHPhotoLibrary.shared().performChanges({
                        
                        let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                        placeHolder = changeRequest.placeholderForCreatedAssetCollection
                        
                    }, completionHandler: { (success, error) in
                        
                        if success
                        {
                            let result = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeHolder.localIdentifier], options: nil)
                            if result.count > 0
                            {
                                self.saveImageToCameraRoll(url as URL, result.firstObject, completion: {
                                    completion()
                                })
                            }
                        }
                        else
                        {
                            print("fail to make folder : \(error!)")
                            self.saveImageToCameraRoll(url as URL, result.firstObject, completion: {
                                completion()
                            })
                        }
                        
                    })
                }
            } else {

                self.saveImageToCameraRoll(url as URL, nil, completion: {
                    completion()
                })
            }
        })
    }
    
    func saveImageTemporary(exif: NSDictionary?, albumName: String?, jpeg: Bool = true, completion: @escaping () -> Void) {
        
        saveImageWithExif(exif: exif, jpeg: jpeg, completion: { (data, url) in
            completion()
        })
    }
    
    private func saveImageWithExif(exif: NSDictionary?, jpeg: Bool = true, completion: (_ data: Data, _ path: NSURL) -> Void, quality: CGFloat = 0.8, tempFileName: String = "temp")
    {
        let data = jpeg ? self.jpegData(compressionQuality: 0.7) : self.pngData()
        let ext = jpeg ? ".jpg" : ".png"
        let savePath = NSTemporaryDirectory().appending(tempFileName).appending(ext)
        
        guard data != nil else {
            print("jpeg data is nil")
            return
        }
        
        let imageRef: CGImageSource = CGImageSourceCreateWithData((data! as CFData), nil)!
        let uti: CFString = CGImageSourceGetType(imageRef)!
        let dataWithEXIF: NSMutableData = NSMutableData(data: data! as Data)
        let destination: CGImageDestination = CGImageDestinationCreateWithData((dataWithEXIF as CFMutableData), uti, 1, nil)!
        
        if let properties = exif {
            CGImageDestinationAddImageFromSource(destination, imageRef, 0, (properties as CFDictionary))
        } else {
            CGImageDestinationAddImageFromSource(destination, imageRef, 0, nil)
        }
        
        CGImageDestinationFinalize(destination)
        
        if FileManager.default.createFile(atPath: savePath, contents: dataWithEXIF as Data, attributes: nil) {
            
            completion(dataWithEXIF as Data, NSURL(string: savePath)!)
            print("Saved : \(savePath)")
        } else {
            
            print("Failed : \(savePath)")
        }
    }
    
    
    private func saveImageToCameraRoll(_ url:URL, _ collection:PHAssetCollection?, completion: @escaping () -> Void)
    {
        // save to camera roll
        PHPhotoLibrary.shared().performChanges({
            
            let createRequest = PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: url)
            createRequest?.creationDate = Date()

            // save to specific folder
            if let collection = collection {
                
                let assetCollection = PHAssetCollectionChangeRequest(for: collection)
                let assetPlaceholder = createRequest!.placeholderForCreatedAsset
                
                assetCollection?.addAssets([assetPlaceholder!] as NSArray)
            }
            
        }, completionHandler: { (success, error) in
            
            if success {
                print("success")
            } else {
                print("fail")
            }
            
            completion()
        })
    }
}

// Resize
public extension UIImage {

    func resizeExact(targetSize: CGSize) -> UIImage? {
        return self.getImageFromContext(size: targetSize)
    }

    func resize(targetSize: CGSize) -> UIImage? {
        
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        
        return self.getImageFromContext(size: newSize)
    }
    
    func resize(width: CGFloat) -> UIImage? {
        
        let size = self.size
        let ratio = size.height / size.width
        let newSize = CGSize(width: width, height: width * ratio)
        
        return self.getImageFromContext(size: newSize)
    }
    
    func resize(height: CGFloat) -> UIImage? {

        let size = self.size
        let ratio = size.width / size.height
        let newSize = CGSize(width: height * ratio, height: height)
        
        return self.getImageFromContext(size: newSize)
    }
    
    func getImageFromContext(size: CGSize) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func scaleAndRotate(maxResolution: CGFloat, orientation: UIImage.Orientation) -> UIImage? {
        
        let imageRef = self.cgImage
        
        guard imageRef != nil else {
            return nil
        }
        
        let width = CGFloat(imageRef!.width)
        let height = CGFloat(imageRef!.height)
        
        var transform = CGAffineTransform.identity
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        if (width > maxResolution) || (height > maxResolution) {
            
            let ratio = width / height
            if ratio > 1 {
                
                bounds.size.width = maxResolution
                bounds.size.height = bounds.size.width / ratio
            } else {
                
                bounds.size.height = maxResolution
                bounds.size.width = bounds.size.height * ratio
            }
        }
        
        let scaleRatio = bounds.size.width / width
        let imageSize = CGSize(width: imageRef!.width, height: imageRef!.height)
        var boundHeight: CGFloat = 0.0
        
        switch orientation {
            
        case .up:
            transform = CGAffineTransform.identity
            break

        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            break
            
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
            
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            break
            
        case .leftMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
            break
            
        case .left:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
            break
            
        case .rightMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
            
        case .right:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            
            break
        @unknown default:
            fatalError("scaleAndRotate error")
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        
        guard context != nil else {
            return nil
        }
        
        if orientation == .right || orientation == .left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio)
            context!.translateBy(x: -height, y: 0)
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio)
            context!.translateBy(x: 0, y: -height)
        }
        
        context!.concatenate(transform)
        
        context!.draw(imageRef!, in: CGRect(x: 0, y: 0, width: width, height: height))
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return imageCopy
    }
    
    class func resizeWithSize(_ size: CGSize, contentMode: UIView.ContentMode, bounds: CGSize) -> CGSize {
        let horizontalRatio: CGFloat = bounds.width / size.width
        let verticalRatio: CGFloat = bounds.height / size.height
        var ratio: CGFloat = 1.0
        if contentMode == .scaleAspectFill {
            ratio = max(horizontalRatio, verticalRatio)
        } else if contentMode == .scaleAspectFit {
            ratio = min(horizontalRatio, verticalRatio)
        }
        return CGSize(width: size.width * ratio, height: size.height * ratio)
    }
}

// Crop
public extension UIImage {
    
    func crop(targetBounds: CGRect) -> UIImage? {

        guard self.cgImage != nil else {
            return nil
        }
        
        if let imageRef = self.cgImage!.cropping(to: targetBounds) {
            
            let newImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
            return newImage
        }
        
        return nil
    }
    
    func cropCenter(targetSize: CGSize) -> UIImage? {

        var cropSize = CGSize()
        if targetSize.width / self.size.width > targetSize.height / self.size.height {
            cropSize = CGSize(width: self.size.width, height: self.size.width * targetSize.height / targetSize.width)
        } else {
            cropSize = CGSize(width: self.size.height * targetSize.width / targetSize.height, height: self.size.height)
        }
        let cropRect = CGRect(x: (floor(self.size.width - cropSize.width) / 2.0),
                              y: floor((self.size.height - cropSize.height) / 2.0),
                              width: floor(cropSize.width),
                              height: floor(cropSize.height))
        
        return self.crop(targetBounds: cropRect)
    }
    
    func thumbnail(width: CGFloat) -> UIImage? {
        
        guard self.cgImage != nil else {
            return nil
        }

        var resizeImage: UIImage? = nil
        if self.size.width > self.size.height {
            resizeImage = self.resize(height: width)
        } else {
            resizeImage = self.resize(width: width)
        }
        
        guard resizeImage != nil else {
            return nil
        }
        
        let centerRect = CGRect(x: (resizeImage!.size.width - width) / 2.0,
                                y: (resizeImage!.size.height - width) / 2.0,
                                width: width,
                                height: width)
        let imageRef = resizeImage!.cgImage!.cropping(to: centerRect)!
        let newImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return newImage
    }
}

// Flip image
public extension UIImage {
    
    enum FlipDirect: Int {
        case x = 1
        case y = 2
        case xy = 3
    }
    
    func flip(direct: FlipDirect = FlipDirect.xy) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        if direct == FlipDirect.x {
            
            context.translateBy(x: self.size.width, y: 0)
            context.scaleBy(x: -self.scale, y: 1.0)

        } else if direct == FlipDirect.y {
            
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -self.scale)

        } else {
            
            context.translateBy(x: self.size.width, y: self.size.height)
            context.scaleBy(x: -self.scale, y: -self.scale)
        }
        
        context.draw(self.cgImage!, in: CGRect(origin:CGPoint.zero, size: self.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

// Rotate
public extension UIImage {
    
    func degreeToRadian(degree: CGFloat) -> CGFloat {
        return degree * CGFloat.pi / 180.0
    }
    
    func rotateBy(degree: CGFloat) -> UIImage? {
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let transform = CGAffineTransform.init(rotationAngle: degreeToRadian(degree: degree))
        view.transform = transform
        let size = view.frame.size
        
        UIGraphicsBeginImageContext(size)
        if let bitmap = UIGraphicsGetCurrentContext() {
            
            bitmap.translateBy(x: size.width / 2, y: size.height / 2)
            bitmap.rotate(by: degreeToRadian(degree: degree))
            bitmap.scaleBy(x: 1.0, y: -1.0)
            bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        return nil
    }
}

// Average color
public extension UIImage {
    
    var averageColor: UIColor? {
        
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else {
            return nil
        }
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

public extension UIImage {
    
    convenience init(color: UIColor?, size: CGSize = CGSize(width: UIScreen.main.scale, height: UIScreen.main.scale)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color?.setFill()
        UIRectFill(rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage {
            UIGraphicsEndImageContext()
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            self.init()
        }
    }
    
    static func imageFromColor(_ color: UIColor, size: CGSize) -> UIImage {
        return UIImage(color: color, size: size)
    }
}
