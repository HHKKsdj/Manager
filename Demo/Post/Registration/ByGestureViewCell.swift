//
//  TableViewCell.swift
//  Demo
//
//  Created by HK on 2021/7/26.
//

import UIKit
import GPassword

protocol GestureDelegate : NSObjectProtocol {
    func getPassword (password:String)
}

class GestureCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var gestureView: Box = {
        let box = Box(frame: CGRect(x: 85, y: 60, width: self.frame.width - 100 , height: 225))
        box.delegate = self
        return box
    }()
    
    var gestureDelegate : GestureDelegate?
    var password = ""
    var titleLabel : UILabel!
    var orderLabel : UILabel!
    
    func setUI() {
        GPassword.config { (options) in
            options.connectLineStart = .border
            options.normalstyle = .innerFill
            options.isDrawTriangle = true
            options.matrixNum = 3
        }
        self.contentView.addSubview(gestureView)
        
        titleLabel = UILabel.init()
        titleLabel.text = "签到手势"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
        }
        
        orderLabel = UILabel.init()
        orderLabel.textColor = UIColor.gray
        self.contentView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GestureCell: GPasswordEventDelegate {
    func sendTouchPoint(with tag: String) {
        password += tag
//        print(tag)
    }
    
    func touchesEnded() {
        orderLabel.text = "手势顺序: \(password)"
//        print(password)
        gestureDelegate?.getPassword(password: password)
        password = ""
    }
}

