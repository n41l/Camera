//
//  CaptureDevice+AVCaptureDevice.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

// MARK: Getters
extension AVCaptureDevice: CaptureDevice {
    var minExposureDuration: CMTime { activeFormat.minExposureDuration }
    var maxExposureDuration: CMTime { activeFormat.maxExposureDuration }
    var minISO: Float { activeFormat.minISO }
    var maxISO: Float { activeFormat.maxISO }
    var minFrameRate: Float64? {
        var minFrameRate: Float64? = nil
        for format in formats {
            for range in format.videoSupportedFrameRateRanges {
                if range.minFrameRate < minFrameRate ?? 0 {
                    minFrameRate = range.minFrameRate
                }
            }
        }
        return minFrameRate
    }
    var maxFrameRate: Float64? {
        var maxFrameRate: Float64? = nil
        for format in formats {
            for range in format.videoSupportedFrameRateRanges {
                if range.maxFrameRate > maxFrameRate ?? 0 {
                    maxFrameRate = range.maxFrameRate
                }
            }
        }
        return maxFrameRate
    }
    var maxResolution: CMVideoDimensions {
        var maxResolution: CMVideoDimensions = .init()
        for format in formats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            if dimensions.width > maxResolution.width && dimensions.height > maxResolution.height {
                maxResolution = dimensions
            }
        }
        
        return maxResolution
    }
}

// MARK: Getters & Setters
extension AVCaptureDevice {
    var lightMode: CameraLightMode {
        get { torchMode == .off ? .off : .on }
        set { torchMode = newValue == .off ? .off : .on }
    }
    var hdrMode: CameraHDRMode {
        get {
            if automaticallyAdjustsVideoHDREnabled { return .auto }
            else if isVideoHDREnabled { return .on }
            else { return .off }
        }
        set {
            automaticallyAdjustsVideoHDREnabled = newValue == .auto
            if newValue != .auto { isVideoHDREnabled = newValue == .on }
        }
    }
}
