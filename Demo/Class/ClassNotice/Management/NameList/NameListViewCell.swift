//
//  ActivenessViewCell.swift
//  Demo
//
//  Created by HK on 2021/8/4.
//

import UIKit

class NameListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headImageView : UIImageView!
    var nameLabel : UILabel!
    var roleLabel : UILabel!
    var scoreLabel : UILabel!
    
    func setUI() {
        headImageView = UIImageView.init(frame: CGRect(x: 15, y: 7.5 , width: 35, height: 35))
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = headImageView.frame.size.width/2
        self.addSubview(headImageView)
        
        nameLabel = UILabel.init()
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(headImageView.snp.right).offset(20)
        }
        
        roleLabel = UILabel.init()
        roleLabel.isHidden = true
//        roleLabel.text = "管理员"
        roleLabel.font = UIFont.systemFont(ofSize: 12.5)
        roleLabel.textAlignment = .center
        roleLabel.textColor = UIColor.systemTeal
        roleLabel.layer.masksToBounds = true
        roleLabel.layer.cornerRadius = 12.0
        roleLabel.layer.borderWidth = 0.5
        roleLabel.layer.borderColor = UIColor.systemTeal.cgColor
        self.addSubview(roleLabel)
        roleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-45)
            make.height.equalTo(25)
            make.width.equalTo(50)
        }
        
        scoreLabel = UILabel.init()
        self.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
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
