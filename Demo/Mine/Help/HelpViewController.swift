//
//  HelpViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "帮助中心"
        // Do any additional setup after loading the view.
        WeChat()
//        setUI()
    }
    
    var key = ""
    var titleLabel : UILabel!
    var codeLabel : UILabel!
    var codeText : UITextView!
    var detailLabel : UILabel!
    var image : UIImageView!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "如何绑定微信公众号?"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(125)
        }
        
        codeLabel = UILabel.init()
        codeLabel.text = "当前绑定码为（五分钟内有效）："
        self.view.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(15)
        }
        
        codeText = UITextView.init()
        codeText.text = key
        codeText.textAlignment = .left
        codeText.font = UIFont(name: "Helvetica-Bold", size: 17)
        codeText.isEditable = false
        self.view.addSubview(codeText)
        codeText.snp.makeConstraints { (make) in
            make.centerY.equalTo(codeLabel.snp.centerY).offset(7)
            make.left.equalTo(codeLabel.snp.right)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        detailLabel = UILabel.init()
        detailLabel.numberOfLines = 0
        detailLabel.text = "STP1. 微信扫描二维码关注公众号。\nSTP2. 回复：绑定+绑定码（如：绑定LK8MV0）。\nSTP3. 绑定成功，可获取最新消息推送。\nSTP4. 如需解绑，请回复：解绑+绑定码。"
        self.view.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(codeLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(15)
        }
        
        image = UIImageView.init()
        image.image = UIImage(named: "QR")
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.35
        image.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailLabel.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }
    
    @objc func back (sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HelpViewController {
    func WeChat() {
        UserNetwork.shared.WeChatRequest { (error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.key = content.data
                self.setUI()
            }
        }
    }
}
