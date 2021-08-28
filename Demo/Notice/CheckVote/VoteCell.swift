//
//  VoteCell.swift
//  Demo
//
//  Created by HK on 2021/7/29.
//

import UIKit

class VoteCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var markImageView : UIImageView!
    var optionLabel : UILabel!
    var numLabel : UILabel!
        
    func setUI() {
        markImageView = UIImageView.init()
        markImageView.image = UIImage(systemName: "checkmark.square")
        self.contentView.addSubview(markImageView)
        markImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
        }
        
        optionLabel = UILabel.init()
        optionLabel.text = ""
        optionLabel.textAlignment = .left
        self.contentView.addSubview(optionLabel)
        optionLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(markImageView).offset(50)
            make.width.equalTo(200)
        }
        
        numLabel = UILabel.init()
        numLabel.text = ""
        numLabel.textColor = UIColor.gray
        self.contentView.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
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
