//
//  PermissionManager.swift
//  KICommon
//
//  Created by 조승보 on 2022/07/12.
//

import UIKit
import PhotosUI
import AVFoundation

@available(iOS 14, *)
public final class PermissionManager: NSObject {

    public static func photoPermission() async -> PHAuthorizationStatus {
        return await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
    
    public static func cameraPermission() async -> Bool {
        return await AVCaptureDevice.requestAccess(for: .video)
    }
    
    public static func openSettings() {
        
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }
    }
}
