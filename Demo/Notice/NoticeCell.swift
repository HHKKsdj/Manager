//
//  NoticeCell.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class NoticeCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headerView : UIView!
    var footerView : UIView!
    var markImageView : UIImageView!
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var endTime : UILabel!
    var line : UIView!
    var detailLabel :  UILabel!
    var detailImage : UIImageView!
    
    func setUI() {
        headerView = UIView.init()
        headerView.backgroundColor = UIColor.systemGray6
        self.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.width.equalToSuperview()
        }
        
        markImageView = UIImageView.init(frame: CGRect(x: 12.5, y: 30 , width: 7.5, height: 7.5))
        markImageView.backgroundColor = UIColor.systemTeal
        markImageView.layer.masksToBounds = true
        markImageView.layer.cornerRadius = markImageView.frame.size.width/2
        markImageView.isHidden = true
        self.addSubview(markImageView)
        
        titleLabel = UILabel.init()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(markImageView.snp.right).offset(5)
//            make.top.equalToSuperview().offset(15)
            make.top.equalTo(headerView.snp.bottom).offset(15)
        }
        
        nameLabel = UILabel.init()
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        endTime = UILabel.init()
        endTime.textColor = UIColor.gray
        endTime.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp.top)
        }
        
        line = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        line.backgroundColor = UIColor.lightGray
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(1)
            make.top.equalTo(endTime.snp.bottom).offset(15)
        }
        
        detailLabel = UILabel.init()
        detailLabel.text = "详情"
        detailLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(line.snp.bottom).offset(10)
        }
        
        detailImage = UIImageView.init()
        detailImage.tintColor = UIColor.black
        detailImage.image = UIImage(systemName: "chevron.right")
        self.addSubview(detailImage)
        detailImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(detailLabel.snp.top)
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
