//
//  ReceiveView.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class ReceivedView: UIView {
    override init(frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var announce : UIButton!
    var vote : UIButton!
    var question : UIButton!
    var draw : UIButton!
    var time :UIButton!
    var gesture : UIButton!
    
    func setUI() {
        self.backgroundColor = UIColor.yellow
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
