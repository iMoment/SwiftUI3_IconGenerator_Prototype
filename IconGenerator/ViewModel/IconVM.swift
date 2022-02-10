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
    
    // MARK: Icon Set Image Sizes
    @Published var iconSizes: [Int] = [
        20,60,58,87,80,120,180,40,29,76,152,167,1024,16,32,64,128,256,512,1024
    ]
    
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
                
                // 3. Writing Contents.json file inside the folder
                self.writeContentsToFile(folderURL: modifiedURL.appendingPathComponent("Contents.json"))
                // 4. Generating Icon set and writing inside the folder
                if let selectedImage = self.selectedImage {
                    
                    self.iconSizes.forEach { size in
                        let imageSize = CGSize(width: CGFloat(size), height: CGFloat(size))
                        let imageURL = modifiedURL.appendingPathComponent("\(size).png")
                        selectedImage.resizeImage(size: imageSize)
                            .writeImage(to: imageURL)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Writing Contents.json
    func writeContentsToFile(folderURL: URL) {
        do {
            let bundle = Bundle.main.path(forResource: "Contents", ofType: "json") ?? ""
            let url = URL(fileURLWithPath: bundle)
            
            try Data(contentsOf: url).write(to: folderURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
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

// MARK: Extending NSImage to resize selected image
extension NSImage {
    func resizeImage(size: CGSize) -> NSImage {
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        
        self.draw(in: NSRect(origin: .zero, size: size))
        
        newImage.unlockFocus()
        
        return newImage
    }
    
    // MARK: Writing resized image as PNG
    func writeImage(to: URL) {
        guard let data = tiffRepresentation, let representation = NSBitmapImageRep(data: data), let pngData = representation.representation(using: .png, properties: [:]) else { return }
        
        try? pngData.write(to: to, options: .atomic)
    }
}
