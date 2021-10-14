//
//  FrenchDogCoreMLModel.swift
//  YOLO
//
//  Created by MacBook on 14.10.2021.
//

import UIKit
import CoreML
import Vision

protocol FrenchDogDelegate {
    
    func getFirstResult(_ first: String, _ confidence: Double)
}

class FrenchDogCoreMLModel {
    
    var frenchDogDelegate: FrenchDogDelegate?
    
    func imageClassifier(_ image: UIImage) {
        
        // create model
        guard let model = try? VNCoreMLModel(for: FrenchDogImageClassifier(configuration: MLModelConfiguration()).model) else { return }
        
        // create request completion handler
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // get all results
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            // get first rusult
            guard let first = results.first?.identifier, let confidence = results.first?.confidence else { return }
            
            // dispatch first fesult to delegate
            self.frenchDogDelegate?.getFirstResult(first, Double(confidence))
            
        }
        
        // convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else { return }
        
        // create hadler
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
        } catch { print(error) }
        
    }
    
    
}
