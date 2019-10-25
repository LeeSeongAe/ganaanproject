//
//  ImageTask.swift
//  Project1
//
//  Created by Yujin Robot on 16/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation

protocol ImageTaskDownloadedDelegate {
    func imageDownloaded(id: String)
}

class ImageTask {
    let id: String
    let url: URL
    let session: URLSession
    let delegate: ImageTaskDownloadedDelegate
    
    var retries = 0
    
    var image: UIImage?
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
    
    init(id: String, url: URL, session: URLSession, delegate: ImageTaskDownloadedDelegate) {
        self.id = id
        self.url = url
        self.session = session
        self.delegate = delegate
    }
    
    func resume() {
        if !isDownloading && !isFinishedDownloading {
            
            if let cachedImage = loadImageFromCache(imageId: self.id) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                    self.delegate.imageDownloaded(id: self.id)
                }
                self.isFinishedDownloading = true
                return
            }
            
            isDownloading = true
            
            if let resumeData = resumeData {
                task = session.downloadTask(withResumeData: resumeData, completionHandler: downloadTaskCompletionHandler)
            } else {
                task = session.downloadTask(with: url, completionHandler: downloadTaskCompletionHandler)
            }
            
            task?.resume()
        }
    }
    
    func pause() {
        if isDownloading && !isFinishedDownloading {
            task?.cancel(byProducingResumeData: { (data) in
                self.resumeData = data
            })
            
            self.isDownloading = false
        }
    }
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("Error downloading: ", error)
            
            if retries < 3 {
                retries = retries + 1
                isDownloading = false
                self.resume()
            }
            
            return
        }
        
        guard let url = url else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        guard let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.image = image
            self.delegate.imageDownloaded(id: self.id)
        }
        
        saveImageToDisk(imageId: self.id, image: image)
        
        self.isFinishedDownloading = true
    }
    
    private func loadImageFromCache(imageId: String) -> UIImage? {
        let fm = FileManager.default
        
        let fileURL = getImageFileUrl(imageId: imageId)
        
        if fm.fileExists(atPath: fileURL.path), let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    private func saveImageToDisk(imageId: String, image: UIImage) {
        let fileURL = getImageFileUrl(imageId: imageId)
        
        do {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                try imageData.write(to: fileURL)
            }
        } catch {
            print("Error saving image data to disk: ", error.localizedDescription)
        }
    }
    
    private func getImageFileUrl(imageId: String) -> URL {
        let fm = FileManager.default
        
        let documentDirectory = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let imagesDir = documentDirectory.appendingPathComponent("images", isDirectory: true)
        
        if !fm.fileExists(atPath: imagesDir.path) {
            try? fm.createDirectory(at: imagesDir, withIntermediateDirectories: false, attributes: nil)
        }
        
        return imagesDir.appendingPathComponent(imageId)
    }
}


