//
//  ViewController.swift
//  Upload Image with Progress Bar
//
//  Created by Adwait Barkale on 17/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
    URLSessionDelegate,URLSessionTaskDelegate,URLSessionDataDelegate
{

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgUploadProgressView: UIProgressView!
    @IBOutlet weak var lblProgressPercent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSelectImageTapped(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController,animated: true,completion: nil)
    }
    

    @IBAction func btnUploadTapped(_ sender: UIButton) {
        uploadImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgView.image = info[.originalImage] as? UIImage
        imgView.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func uploadImage()
    {
        let imageData = imgView.image!.jpegData(compressionQuality: 1)
        
        if imageData == nil { return }
        
        btnUpload.isUserInteractionEnabled = false
        
        //let uploadScriptUrl = URL(string: "https://www.swiftdeveloperblog.com/http--post--example--script/")
        let uploadScriptUrl = URL(string: "https://api.imgur.com/3/upload")
        var request = URLRequest(url: uploadScriptUrl!)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration,delegate: self,delegateQueue: OperationQueue.main)
        
        let task = session.uploadTask(with: request, from: imageData!)
        
        task.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        print("Error Uploading Image - \(error?.localizedDescription ?? "Unknown Error")")
        btnUpload.isUserInteractionEnabled = true
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        imgUploadProgressView.progress = uploadProgress
        let progressPercentage = Int(uploadProgress * 100)
        lblProgressPercent.text = "\(progressPercentage)%"
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        btnUpload.isUserInteractionEnabled = true
    }
}

