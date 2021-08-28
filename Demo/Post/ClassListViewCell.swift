//
//  ClassListViewCell.swift
//  Demo
//
//  Created by HK on 2021/8/6.
//

import UIKit

protocol TargetDelegate : NSObjectProtocol {
    func addTarget (section:Int,row:Int)
    func deleteTarget(section:Int,row:Int)
}

class ClassListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var select = false
    var targetDelegate : TargetDelegate!
    var mark : UIButton!
    var label : UILabel!
    var button : UIButton!
    var section = 0
    var row = 0
    
    func setUI() {
        mark = UIButton.init()
        if select == false {
            mark.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }

        mark.addTarget(self, action: #selector(select(sender:)), for: .touchUpInside)
        self.contentView.addSubview(mark)
        mark.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        label = UILabel.init()
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(mark.snp.right).offset(25)
        }
        
        button = UIButton.init()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        button.addTarget(self, action: #selector(more(sender:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func select (sender:UIButton) {
        if select == false {
            select = true
            mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            targetDelegate.addTarget(section:section,row:row)
        } else {
            select = false
            mark.setImage(UIImage(systemName: "circle"), for: .normal)
            targetDelegate.deleteTarget(section:section,row:row)
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

class CollectionCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    var nameLabel : UILabel!
    
    func setUI() {
        nameLabel = UILabel.init()
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = self.nameLabel.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]) ?? CGSize.zero
        let att = super.preferredLayoutAttributesFitting(layoutAttributes);
        att.frame = CGRect(x: 0, y: 0, width: size.width+40, height: 25)
        self.nameLabel.frame = CGRect(x: 0, y: 0, width: att.frame.size.width, height: 25)
        return att;
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
