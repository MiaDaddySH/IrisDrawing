//
//  ViewController.swift
//  Mantis
//
//  Created by Echo on 10/19/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit
import Mantis

class ViewController: UIViewController, CropViewControllerDelegate {
    var image = UIImage(named: "sunflower.jpg")
    
    @IBOutlet weak var croppedImageView: UIImageView!
    var imagePicker: ImagePicker!
    @IBOutlet weak var cropShapesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func getImageFromAlbum(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func normalPresent(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        let config = Mantis.Config()
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func presentWithPresetTransformation(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        
        
        let transform = Transformation(offset: CGPoint(x: 231.66666666666666, y: 439.6666666666667),
                                       rotation: 0.5929909348487854,
                                       scale: 2.841958076098717,
                                       manualZoomed: true,
                                       intialMaskFrame: CGRect(x: 14.0, y: 62.25, width: 347.0, height: 520.5),
                                       maskFrame: CGRect(x: 59.47694524495677, y: 14.0, width: 256.04610951008647, height: 617.0),
                                       scrollBounds: CGRect(x: 231.66666666666666, y: 439.6666666666667, width: 557.1387432741491, height: 654.7511809035641))
        
        
        config.presetTransformationType = .presetInfo(info: transform)
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func hideRotationDialPresent(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.showRotationDial = false
        
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func alwayUserOnPresetRatioPresent(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        let config = Mantis.Config()
        
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 16.0 / 9.0)
        present(cropViewController, animated: true)
    }
    
    
    @IBAction func customizedCropToolbarButtonTouched(_ sender: Any) {
        guard let image = image else {
            return
        }
        var config = Mantis.Config()
        
        config.cropToolbarConfig.cropToolbarHeightForVertialOrientation = 44
        config.cropToolbarConfig.cropToolbarWidthForHorizontalOrientation = 80
        
        let cropToolbar = CustomizedCropToolbar(frame: .zero)
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config,
                                                           cropToolbar: cropToolbar)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
        
    }
    
    
    
    @IBAction func customizedCropToolbarWithoutListButtonTouched(_ sender: Any) {
        guard let image = image else {
            return
        }
        var config = Mantis.Config()
        
        config.cropToolbarConfig.cropToolbarHeightForVertialOrientation = 44
        config.cropToolbarConfig.cropToolbarWidthForHorizontalOrientation = 80
        
        let cropToolbar = CustomizedCropToolbarWithoutList(frame: .zero)
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config,
                                                           cropToolbar: cropToolbar)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
        
    }
    
    
    @IBAction func clockwiseRotationButtonTouched(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.cropToolbarConfig.toolbarButtonOptions = [.clockwiseRotate, .reset, .ratio, .alterCropper90Degree];
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func cropShapes(_ sender: Any) {
        showCropShapeList()
    }
    
    @IBAction func darkBackgroundEffect(_ sender: Any) {
        presentWith(backgroundEffect: .dark)
    }
    
    @IBAction func lightBackgroundEffect(_ sender: Any) {
        presentWith(backgroundEffect: .light)
    }
    
    @IBAction func noBackgroundEffect(_ sender: Any) {
        presentWith(backgroundEffect: .none)
    }
    
    typealias CropShapeItem = (type: Mantis.CropShapeType, title: String)
    
    let cropShapeList: [CropShapeItem] = [
        (.rect, "Rect"),
        (.square, "Square"),
        (.ellipse(), "Ellipse"),
        (.circle(), "Circle"),
        (.polygon(sides: 5), "pentagon"),
        (.polygon(sides: 6), "hexagon"),
        (.roundedRect(radiusToShortSide: 0.1), "Rounded rectangle"),
        (.diamond(), "Diamond"),
        (.heart(), "Heart"),
        (.path(points: [CGPoint(x: 0.5, y: 0),
                        CGPoint(x: 0.6, y: 0.3),
                        CGPoint(x: 1, y: 0.5),
                        CGPoint(x: 0.6, y: 0.8),
                        CGPoint(x: 0.5, y: 1),
                        CGPoint(x: 0.5, y: 0.7),
                        CGPoint(x: 0, y: 0.5)]), "Arbitrary path")
    ]
    
    private func showCropShapeList() {
        guard let image = image else {
            return
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for item in cropShapeList {
            let action = UIAlertAction(title: item.title, style: .default) {[weak self] _ in
                guard let self = self else {return}
                var config = Mantis.Config()
                config.cropShapeType = item.type
                
                let cropViewController = Mantis.cropViewController(image: image, config: config)
                cropViewController.modalPresentationStyle = .fullScreen
                cropViewController.delegate = self
                self.present(cropViewController, animated: true)
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.handlePopupInBigScreenIfNeeded(sourceView: cropShapesButton)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func presentWith(backgroundEffect effect: CropVisualEffectType) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.cropVisualEffectType = effect
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController,
           let vc = nc.viewControllers.first as? EmbeddedCropViewController {
            vc.image = image
            vc.didGetCroppedImage = {[weak self] image in
                self?.croppedImageView.image = image
                self?.dismiss(animated: true)
            }
        }
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        print(transformation);
        croppedImageView.image = cropped
        self.dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true)
    }
}

extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        self.image = image
        self.croppedImageView.image = image
    }
}
