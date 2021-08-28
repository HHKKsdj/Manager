//
//  InvolveCell.swift
//  Demo
//
//  Created by HK on 2021/7/31.
//

import UIKit

class InvolveCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headImageView : UIImageView!
    var nameLabel : UILabel!
    var markImageView : UIImageView!
    
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
        
        markImageView = UIImageView.init(frame: CGRect(x: 350, y: 20 , width: 10, height: 10))
        markImageView.layer.masksToBounds = true
        markImageView.layer.cornerRadius = markImageView.frame.size.width/2
        self.addSubview(markImageView)
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
