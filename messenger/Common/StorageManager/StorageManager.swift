//
//  StorageManager.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import Foundation
import FirebaseStorage

typealias UploadPictureCompletion = (Result<String, Error>) -> Void

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metaData, error in
            guard error == nil else {
                print("failed to upload: \(String(describing: error?.localizedDescription))")
                completion(.failure(StorageErrors.failedUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to download: \(String(describing: error?.localizedDescription))")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    /// Upload image that will be sent in a conversation message
     public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
         storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
             guard error == nil else {
                 // failed
                 print("failed to upload data to firebase for picture")
                 completion(.failure(StorageErrors.failedUpload))
                 return
             }

             self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                 guard let url = url else {
                     print("Failed to get download url: \(String(describing: error?.localizedDescription))")
                     completion(.failure(StorageErrors.failedToGetDownloadURL))
                     return
                 }

                 let urlString = url.absoluteString
                 print("download url returned: \(urlString)")
                 completion(.success(urlString))
             })
         })
     }
    
    /// Upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload video file to firebase for picture")
                completion(.failure(StorageErrors.failedUpload))
                return
            }

            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url: \(String(describing: error?.localizedDescription))")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }

            completion(.success(url))
        })
    }
}
