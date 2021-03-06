//
//  ViewController.swift
//  YOLO
//
//  Created by MacBook on 10.10.2021.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var yoloImage: UIImageView!
    @IBOutlet weak var yoloLabel: UILabel!
    
   
    let imagePicker = UIImagePickerController()
    var frenchDogCoreMLModel = FrenchDogCoreMLModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        frenchDogCoreMLModel.frenchDogDelegate = self
        
        yoloLabel.text = "Pick a photo to check if there is a french bulldog on it"
        
    }

    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
  
    
    
}

//MARK: - UIImage Picker Controller Delegate, UINavigation Controller Delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        yoloImage.image = image
        
        // dispatch image to FrenchDogCoreMLModel
        frenchDogCoreMLModel.imageClassifier(image)
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
}
//MARK: French Dog Delegate
extension ViewController: FrenchDogDelegate {
    func getFirstResult(_ first: String, _ confidence: Double) {
        
        var item = ""
        switch first {
        case "NonFrench":
            item = "no french bulldog detected"
        case "French":
            item = "french bulldog detected"
        default:
            item = "Fucking chupacabra detected"
        }
        
        
        DispatchQueue.main.async {
            self.yoloLabel.text = "It's \(String(format: "%.0f", confidence * 100))% \(first)"
            self.navigationItem.title = item
            
        }
    }
    
    
    
    
}


