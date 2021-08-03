//
//  CropMaskProtocol.swift
//  Mantis
//
//  Created by Echo on 10/22/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

fileprivate let minOverLayerUnit: CGFloat = 30
fileprivate let initialFrameLength: CGFloat = 1000

protocol CropMaskProtocol where Self: UIView {
    var cropShapeType: CropShapeType { get set }
    
    func initialize()
    func setMask()
    func adaptMaskTo(match cropRect: CGRect)
}

extension CropMaskProtocol {
    func initialize() {
        setInitialFrame()
        setMask()
    }
    
    private func setInitialFrame() {
        let width = initialFrameLength
        let height = initialFrameLength
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let x = (screenWidth - width) / 2
        let y = (screenHeight - height) / 2
        
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    func adaptMaskTo(match cropRect: CGRect) {
        let scaleX = cropRect.width / minOverLayerUnit
        let scaleY = cropRect.height / minOverLayerUnit
        
        transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        self.frame.origin.x = cropRect.midX - self.frame.width / 2
        self.frame.origin.y = cropRect.midY - self.frame.height / 2
    }
    
    func createOverLayer(opacity: Float) -> CAShapeLayer {
        let x = bounds.midX - minOverLayerUnit / 2
        let y = bounds.midY - minOverLayerUnit / 2
        let initialRect = CGRect(x: x, y: y, width: minOverLayerUnit, height: minOverLayerUnit)
        
        let path = UIBezierPath(rect: self.bounds)
        
        let innerPath: UIBezierPath
        
        func getInnerPath(by points: [CGPoint]) -> UIBezierPath {
            let innerPath = UIBezierPath()
            guard points.count >= 3 else {
                return innerPath
            }
            let points0 = CGPoint(x: initialRect.width * points[0].x + initialRect.origin.x, y: initialRect.height * points[0].y + initialRect.origin.y)
            innerPath.move(to: points0)
        
            for i in 1..<points.count {
                let point = CGPoint(x: initialRect.width * points[i].x + initialRect.origin.x, y: initialRect.height * points[i].y + initialRect.origin.y)
                innerPath.addLine(to: point)
            }
            
            innerPath.close()
            return innerPath
        }
                
        switch cropShapeType {
        case .rect, .square:
            innerPath = UIBezierPath(rect: initialRect)
        case .ellipse, .circle:
            innerPath = UIBezierPath(ovalIn: initialRect)
        case .roundedRect(let radiusToShortSide, _):
            let radius = min(initialRect.width, initialRect.height) * radiusToShortSide
            innerPath = UIBezierPath(roundedRect: initialRect, cornerRadius: radius)
        case .diamond:
            let points = [CGPoint(x: 0.5, y: 0), CGPoint(x: 1, y: 0.5), CGPoint(x: 0.5, y: 1), CGPoint(x: 0, y: 0.5)]
            innerPath = getInnerPath(by: points)
        case .path(let points, _):
            innerPath = getInnerPath(by: points)
        case .heart:
            innerPath = UIBezierPath(heartIn: initialRect)
        case .polygon(let sides, let offset, _):
            let points = polygonPointArray(sides: sides, x: 0.5, y: 0.5, radius: 0.5, offset: 90 + offset)
            innerPath = getInnerPath(by: points)
        }
                
        path.append(innerPath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = opacity
        return fillLayer
    }
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()

        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2

        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)

        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.minX + rect.width/2, y: rect.minY + rect.height * 0.2))

        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.minX + rect.width * 0.7, y: rect.minY + rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)

        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.minX + rect.width * 0.5, y: rect.minY + rect.height * 0.95))

        //Left Bottom Line
        self.close()
    }
}

extension CGFloat {
    func radians() -> CGFloat {
        let b = .pi * (self/180)
        return b
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

func polygonPointArray(sides: Int,
                       x: CGFloat,
                       y: CGFloat,
                       radius: CGFloat,
                       offset: CGFloat) -> [CGPoint] {
    let angle = (360/CGFloat(sides)).radians()
    let cx = x // x origin
    let cy = y // y origin
    let r = radius // radius of circle
    var i = 0
    var points = [CGPoint]()
    while i <= sides {
        let xpo = cx + r * cos(angle * CGFloat(i) - offset.radians())
        let ypo = cy + r * sin(angle * CGFloat(i) - offset.radians())
        points.append(CGPoint(x: xpo, y: ypo))
        i += 1
    }
    return points
}

