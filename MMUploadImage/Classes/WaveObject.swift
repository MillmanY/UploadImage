//
//  WaveObject.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/1.
//
//

import UIKit

class WaveObject: NSObject {
    fileprivate var speed:Float = 0.0
    fileprivate var a = 0.0
    fileprivate var offset:Float = 0.0
    fileprivate var waveWidth = 0.0
    fileprivate var toAdd = true
    fileprivate var layerSize:CGSize = CGSize.zero
    
    init (layerSize:CGSize,speed:Float) {
        self.layerSize = layerSize
        self.speed = speed
    }
    
    func generateWavePath(_ yPos:CGFloat) -> CGPath {
        a = (toAdd) ? a + 0.01 : a - 0.01
        toAdd = (a <= 1 ) ? true : (a >= 2.5) ? false : toAdd
        offset = (offset < MAXFLOAT) ? offset + speed : offset - speed
        let bezier = UIBezierPath()
        
        bezier.lineWidth = 1
        bezier.move(to: CGPoint(x: 0, y: yPos))
        
        let width = Double(layerSize.width)
        for x in 0..<Int(layerSize.width) {
            let y = 2 * a * sin (2.5 * .pi / width * Double(x) + Double(offset) * .pi / width) + Double(yPos)
            bezier.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        bezier.addLine(to: CGPoint(x: layerSize.width, y: layerSize.height))
        bezier.addLine(to: CGPoint(x: 0, y: layerSize.height))
        bezier.close()
        
        return bezier.cgPath
    }
}
