//
//  WaveObject.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/1.
//
//

import UIKit

class WaveObject: NSObject {
    var lastY:CGFloat = 0.0
    var speed:Float = 0.0
    var a = 0.0
    var offset:Float = 0.0
    var waveWidth = 0.0
    var toAdd = true
    var layerWidth:Double = 0.0
    init(layerWidth:Double) {
        self.layerWidth = layerWidth
    }
    
    func generateWavePath(yPos:CGFloat) -> CGPath {
        lastY = (yPos > 0.0) ? yPos : lastY
        a = (toAdd) ? a + 0.01 : a - 0.01
        toAdd = (a <= 1 ) ? true : (a >= 2.5) ? false : toAdd
        offset = (offset < MAXFLOAT) ? offset + speed : offset - speed
        let bezier = UIBezierPath()
        
        bezier.lineWidth = 4
        bezier.moveToPoint(CGPointMake(0, yPos))
        for x in 0..<Int(layerWidth) {
            let y = 2 * a * sin (2.5 * M_PI / layerWidth * Double(x) + Double(offset) * M_PI / layerWidth) + Double(lastY)
            bezier.addLineToPoint(CGPointMake(CGFloat(x), CGFloat(y)))
        }
        
        bezier.addLineToPoint(CGPointMake(CGFloat(layerWidth), 100))
        
        bezier.addLineToPoint(CGPointMake(0, 100))
        bezier.closePath()
        
        return bezier.CGPath
    }
}
