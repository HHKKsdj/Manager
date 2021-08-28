//
//  OptionCell.swift
//  Demo
//
//  Created by HK on 2021/7/27.
//

import UIKit

//MARK: HeadCell

protocol AddDelegate : NSObjectProtocol {
    func add()
}

class HeadCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addDelegate : AddDelegate?
    var titleLabel : UILabel!
    var addButton : UIButton!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "选项"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        addButton = UIButton.init()
        addButton.setTitle("添加选项", for: .normal)
        addButton.setTitleColor(UIColor.link, for: .normal)
        addButton.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)
        self.contentView.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func add(sender:UIButton) {
        addDelegate?.add()
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

//MARK: OptionCell

protocol OptionDelegate : NSObjectProtocol {
    func getOption(option:String, tag:Int)
}

class OptionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var optionDelegate : OptionDelegate!
    var titleLabel : UILabel!
    var contentText : UITextField!
    
    func setUI() {
        titleLabel = UILabel.init()
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        contentText = UITextField.init()
        contentText.placeholder = "点击编辑"
        contentText.delegate = self
        contentText.returnKeyType = .done
        contentText.textAlignment = .center
        contentText.addTarget(self, action: #selector(sendOption(sender:)), for: .editingDidEnd)
        self.contentView.addSubview(contentText)
        contentText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.width.equalTo(300)
        }
    }
    
    @objc func sendOption(sender:UIButton) {
        optionDelegate.getOption(option: contentText.text!,tag: self.tag)
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

extension OptionCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        contentText.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        contentText.resignFirstResponder()
    }
}
