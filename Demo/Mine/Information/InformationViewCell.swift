//
//  InformationViewCell.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class InformationHeaderCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var HeadImageView : UIImageView!
    var titleLabel : UILabel!
    var button : UIButton!
    
    func setUI() {
        
        titleLabel = UILabel.init()
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        button = UIButton.init()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = UIColor.black
        self.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        HeadImageView = UIImageView.init()
        self.contentView.addSubview(HeadImageView)
        HeadImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(button.snp.left).offset(-25)
            make.width.equalTo(50)
            make.height.equalTo(50)
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

class InformationCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentLabel : UILabel!
    var titleLabel : UILabel!
    
    func setUI() {
        
        titleLabel = UILabel.init()
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        contentLabel = UILabel.init()
        contentLabel.textAlignment = .right
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
            make.width.equalTo(250)
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
