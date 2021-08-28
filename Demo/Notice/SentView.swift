//
//  SentView.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class SentView: UIView {
    override init(frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tableView : UITableView!
    
    func setUI() {
        self.backgroundColor = UIColor.green
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
