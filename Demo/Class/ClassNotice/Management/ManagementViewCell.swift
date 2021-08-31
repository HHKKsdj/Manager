//
//  ManagementViewCell.swift
//  Demo
//
//  Created by HK on 2021/8/3.
//

import UIKit

protocol errorDelegate : NSObjectProtocol {
    func error()
}

class CheckCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var classID = ""
    var delegate : errorDelegate?
    var titleLabel : UILabel!
    var checkSwitch : UISwitch!
    
    func setUI() {
        titleLabel = UILabel.init()
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        checkSwitch = UISwitch.init()
        checkSwitch.addTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)
        self.contentView.addSubview(checkSwitch)
        checkSwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func switchChange (sender:UISwitch) {
        autoAccept()
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

extension CheckCell {
    func autoAccept() {
        ClassNetwork.shared.AutoAcceptRequest(classID: self.classID, enable: checkSwitch.isOn) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code != 200 && content.code != 400 {
                self.delegate?.error()
            }
        }
    }
}

class DeleteCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var deleteLabel : UILabel!
    
    func setUI() {
        deleteLabel = UILabel.init()
        deleteLabel.text = "删除所有通知"
        deleteLabel.textColor = UIColor.systemBlue
        self.contentView.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
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

class QuitCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var quitLabel : UILabel!
    
    func setUI() {
        quitLabel = UILabel.init()
//        quitLabel.text = "退出并解散"
        quitLabel.textColor = UIColor.systemRed
        self.contentView.addSubview(quitLabel)
        quitLabel.snp.makeConstraints { (make) in
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

class ClassCodeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var contentLabel : UITextView!
    var titleLabel : UILabel!
    
    func setUI() {
        
        titleLabel = UILabel.init()
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        contentLabel = UITextView.init()
        contentLabel.font = UIFont.systemFont(ofSize: 17.5)
        contentLabel.isEditable = false
        contentLabel.textAlignment = .right
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7.5)
            make.height.equalTo(25)
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

