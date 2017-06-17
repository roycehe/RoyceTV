//
//  ParticlesAnimation.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/25.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

class ParticlesAnimation {
    
    static let shareInstance : ParticlesAnimation = ParticlesAnimation()
    
    fileprivate lazy var granuleLayer : CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        //发射器位置
        emitterLayer.emitterPosition = CGPoint(x: 335, y: 637);
        //发射器大小
        emitterLayer.emitterSize = CGSize(width: 20, height: 20)
        //渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered
        //开启三维效果
        emitterLayer.preservesDepth = true
        //创建粒子Cell
        var cellArray = [CAEmitterCell]()
        for i in 0..<10 {
            let cell = CAEmitterCell()
            cell.birthRate = 2
            cell.lifetime = Float(arc4random_uniform(4) + 1)
            cell.lifetimeRange = 1.5
            let image = UIImage(named: "good\(i)_30x30")
            cell.contents = image?.cgImage
            cell.velocity = CGFloat(arc4random_uniform(100) + 100)
            cell.velocityRange = 80
            cell.emissionLongitude = CGFloat(Double.pi + Double.pi / 2)
            cell.emissionRange = CGFloat(Double.pi / 4 / 6)
            cell.scale = 0.7
            cellArray.append(cell)
        }

        
        
        emitterLayer.emitterCells = cellArray
        
        
        return emitterLayer
    }()

  

}
// MARK: - *** 管理动画 ***
extension ParticlesAnimation {

    func addParticleAimation(view : UIView) -> () {
        view.layer.addSublayer(granuleLayer)
    }
    
    func removeParticleAimation() {
        granuleLayer.removeFromSuperlayer()
    }


}







