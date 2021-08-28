//
//  DrawViewCell.swift
//  Demo
//
//  Created by HK on 2021/7/27.
//

import UIKit

protocol StartDegate : NSObjectProtocol {
    func start()
}

class StartCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var startDelegate : StartDegate?
    var startButton : UIButton!
    
    func setUI() {
        startButton = UIButton.init(frame: CGRect(x: self.frame.width/3, y: self.frame.height/4, width: 200, height: 200))
        startButton.setTitle("开始", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        startButton.backgroundColor = UIColor.systemTeal
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.frame.size.width/2
        startButton.addTarget(self, action: #selector(start(sender:)), for: .touchUpInside)
        self.contentView.addSubview(startButton)
    }
    
    @objc func start(sender:UIButton) {
        startDelegate?.start()
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

class NameCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var nameLabel : UILabel!
    
    func setUI() {
        nameLabel = UILabel.init()
        nameLabel.text = "123456789"
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
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
