//
//  TargetListViewCell.swift
//  Demo
//
//  Created by HK on 2021/8/6.
//

import UIKit
protocol NameDelegate : NSObjectProtocol {
    func addName(row:Int)
    func deleteName(row:Int)
}
class TargetListViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var select = false
    var mark : UIButton!
    var label : UILabel!
    var button : UIButton!
    var section = 0
    var row = 0
    var nameDelegate : NameDelegate?
    
    func setUI() {
        mark = UIButton.init()
        mark.setImage(UIImage(systemName: "circle"), for: .normal)
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
    }
    
    @objc func select (sender:UIButton) {
        if select == false {
            select = true
            mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            nameDelegate!.addName(row: row)
        } else {
            select = false
            mark.setImage(UIImage(systemName: "circle"), for: .normal)
            nameDelegate!.deleteName(row: row)
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
