//
//  IconVM.swift
//  IconGenerator
//
//  Created by Stanley Pan on 2022/02/10.
//

import SwiftUI

class IconVM: ObservableObject {
    // MARK: Selected Image for Icon
    @Published var selectedImage: NSImage?
    
    // MARK: Loading and Alert
    @Published var isGenerating: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: Picking Image using NSOpen Panel
    func selectImage() {
        let panel = NSOpenPanel()
        panel.title = "Choose an image"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image, .png, .jpeg]
        
        if panel.runModal() == .OK {
            if let result = panel.url?.path {
                let image = NSImage(contentsOf: URL(fileURLWithPath: result))
                self.selectedImage = image
            }
        } else {
            // MARK: Error Occurred
        }
    }
    
    func generateIconSet() {
        // 1. Ask user where to store icons
        folderSelector { folderURL in
            // 2. Create AppIcon.appiconset folder
            let modifiedURL = folderURL.appendingPathComponent("AppIcon.appiconset")
            
            do {
                let manager = FileManager.default
                try manager.createDirectory(at: modifiedURL, withIntermediateDirectories: true, attributes: [:])
            } catch {
                // MARK: Error Occurred
            }
        }
    }
    
    // MARK: Folder Selector Using NSOpenPanel
    func folderSelector(completion: @escaping (URL) -> ()) {
        let panel = NSOpenPanel()
        panel.title = "Choose an Folder"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.allowedContentTypes = [.folder]
        
        if panel.runModal() == .OK {
            if let result = panel.url?.path {
                completion(URL(fileURLWithPath: result))
            }
        } else {
            // MARK: Error Occurred
        }
    }
}
