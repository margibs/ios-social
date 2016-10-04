//
//  CircleView.swift
//  devslopes-social
//
//  Created by margibs on 29/09/2016.
//  Copyright © 2016 margibs. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    
    override func layoutSubviews() {
        //super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
