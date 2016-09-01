//
//  WaveObject.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/1.
//
//

import UIKit

class WaveObject: NSObject {
    private var speed:Float = 0.0
    private var a = 0.0
    private var offset:Float = 0.0
    private var waveWidth = 0.0
    private var toAdd = true
    private var layerSize:CGSize = CGSizeZero
    
    init (layerSize:CGSize,speed:Float) {
        self.layerSize = layerSize
        self.speed = speed
    }
    
    func generateWavePath(yPos:CGFloat) -> CGPath {
        a = (toAdd) ? a + 0.01 : a - 0.01
        toAdd = (a <= 1 ) ? true : (a >= 2.5) ? false : toAdd
        offset = (offset < MAXFLOAT) ? offset + speed : offset - speed
        let bezier = UIBezierPath()
        
        bezier.lineWidth = 1
        bezier.moveToPoint(CGPointMake(0, yPos))
        
        let width = Double(layerSize.width)
        for x in 0..<Int(layerSize.width) {
            let y = 2 * a * sin (2.5 * M_PI / width * Double(x) + Double(offset) * M_PI / width) + Double(yPos)
            bezier.addLineToPoint(CGPointMake(CGFloat(x), CGFloat(y)))
        }
        bezier.addLineToPoint(CGPointMake(layerSize.width, layerSize.height))
        bezier.addLineToPoint(CGPointMake(0, layerSize.height))
        bezier.closePath()
        
        return bezier.CGPath
    }
}
