//
//  FileViewCell.swift
//  Demo
//
//  Created by HK on 2021/8/24.
//

import UIKit

protocol FileDelegate : NSObjectProtocol {
    func respond (title:String,msg:String)
}
class FileViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var file = FileInfo()
    var fileName : String!
    var image : UIImageView!
    var titleLabel : UILabel!
    var button : UIButton!
    var delegate : FileDelegate?
    
    var row = 0
    
    func setUI() {
        image = UIImageView.init()
        let type = file.name.split(separator: ".").last
        image.image = UIImage(named: "\(type!)")
        self.contentView.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        titleLabel = UILabel.init()
        titleLabel.text = file.name
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(image.snp.right).offset(25)
        }
        
        button = UIButton.init()
//        button.tag = num
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(download(sender:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
    }
    
    @objc func download (sender:UIButton) {
        ClassNetwork.shared.DownloadRequest(classID: file.classID,fid: file.fid, fileName: file.name) {(error,info) in
            if let error = error {
                print(error)
                self.delegate?.respond(title: "文件已存在", msg: "可在手机文件中查看")
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.msg == "success" {
                self.delegate?.respond(title: "文件保存成功", msg: "可在手机文件中查看")
            }
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
