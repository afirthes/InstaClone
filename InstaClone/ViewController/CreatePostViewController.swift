//
//  CreatePostViewController.swift
//  InstaClone
//
//  Created by Afir Thes on 18.09.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postCaptionTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var postImage: UIImage!
    
    var activeTextView: UITextView?
    
    var keyboardNotification: NSNotification?
    
    lazy var touchView: UIView = {
        let _touchView = UIView()
        _touchView.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha: 0.0)
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        _touchView.addGestureRecognizer(touchViewTapped)
        _touchView.isUserInteractionEnabled = true
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        return _touchView
    }()
    
    lazy var progressIndicator: UIProgressView = {
        let _progressIndicator = UIProgressView()
        _progressIndicator.trackTintColor = UIColor.red
        _progressIndicator.progressTintColor = UIColor.black
        _progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        _progressIndicator.progress = Float(0)
        return _progressIndicator
    }()
    
    lazy var cancelButton: UIButton = {
       let _cancelButton = UIButton()
        _cancelButton.setTitle("Cancel Upload", for: .normal)
        _cancelButton.setTitleColor(UIColor.black, for: .normal)
        _cancelButton.addTarget(self, action: #selector(cancelUpload), for: .touchUpInside)
        _cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return _cancelButton
    }()
    
    var uploadTask: StorageUploadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProgressBar()

        postImageView.image = postImage
        postCaptionTextView.layer.borderWidth = CGFloat(0.5)
        postCaptionTextView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        postCaptionTextView.layer.cornerRadius = CGFloat(3.0)
        postCaptionTextView.delegate = self
    }
    
    
    func initProgressBar() {
        view.addSubview(progressIndicator)
        view.addSubview(cancelButton)
        
        let constraints: [NSLayoutConstraint] = [
            progressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            progressIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            progressIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            cancelButton.topAnchor.constraint(equalTo: progressIndicator.bottomAnchor, constant: 5)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        cancelButton.isHidden = true
        progressIndicator.isHidden = true
    }
    
    @objc func cancelUpload() {
        progressIndicator.isHidden = true
        cancelButton.isHidden = true
        uploadTask?.cancel()
    }
    
    func uploadImage(data: Data, caption: String) {
        
        if let user = Auth.auth().currentUser {
            progressIndicator.isHidden = false
            cancelButton.isHidden = false
            progressIndicator.progress = Float(0)
            
            let imageId: String = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
            let imageName = "\(imageId).jpeg"
            let pathToPic = "images/\(user.uid)/\(imageName)"
            let storageRef = Storage.storage().reference(withPath: pathToPic)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            uploadTask = storageRef.putData(data, metadata: metaData, completion: { [weak self] (metaData, error) in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    strongSelf.progressIndicator.isHidden = true
                    strongSelf.cancelButton.isHidden = true
                }
                
                if let error = error {
                    print(error.localizedDescription)
                    let alert = Helper.errorAlert(title: "Upload Error", message: "Problem uploading image")
                    DispatchQueue.main.async {
                        strongSelf.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let url = url,
                       error == nil {
                        
                        PostModel.newPost(userId: user.uid, caption: caption, imageDownloadURL: url.absoluteString)
                        
                        DispatchQueue.main.async {
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                        
                    } else {
                        let alert = Helper.errorAlert(title: "Upload Error", message: "Problem uploading image")
                        DispatchQueue.main.async {
                            strongSelf.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                
                
            })
            
            uploadTask!.observe(.progress) {  [weak self] snapshot in
                guard let strongSelf = self else { return }
                
                let percentComplete = 100.0 * (Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount))
                
                DispatchQueue.main.async {
                    strongSelf.progressIndicator.setProgress(Float(percentComplete), animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotification()
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        view.addSubview(touchView)
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize!.height + 10.0), right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = UIScreen.main.bounds
        aRect.size.height -= keyboardSize!.height
        if activeTextView != nil {
            if (aRect.contains(activeTextView!.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        touchView.removeFromSuperview()
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func postButtonDidTouch(_ sender: Any) {
        guard let caption = postCaptionTextView.text,
              !caption.isEmpty else { return }
        
        // Some validation here
        
        if let resizedImage = postImage.resized(toWidth: 1080) {
            if let imageData = resizedImage.jpegData(compressionQuality: 0.75) {
                uploadImage(data: imageData, caption: caption)
            }
        }
    }

}

extension CreatePostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
}
