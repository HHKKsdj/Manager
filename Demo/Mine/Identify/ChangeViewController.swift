//
//  UploadViewController.swift
//  Demo
//
//  Created by HK on 2021/8/5.
//

import UIKit

class ChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "类别认证"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var label1 : UILabel!
    var button1 : UIButton!
    var button2 : UIButton!
    var button3 : UIButton!
    var button4 : UIButton!
    var label2 : UILabel!
    var textView : UITextView!
    var button : UIButton!
    var buttonList = [UIButton]()
    var type = ""
    
    func setUI() {
        
        label1 = UILabel.init()
        label1.text = "类别选择"
        self.view.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(150)
        }
        
        button1 = UIButton.init()
        button1.setTitle("学生", for: .normal)
        button1.setTitleColor(UIColor.black, for: .normal)
        button1.setImage(UIImage(systemName: "circle"), for: .normal)
        button1.addTarget(self, action: #selector(type(sender:)), for: .touchUpInside)
        buttonList.append(button1)
        self.view.addSubview(button1)
        button1.snp.makeConstraints { (make) in
            make.left.equalTo(label1.snp.right).offset(35)
            make.centerY.equalTo(label1.snp.centerY)
        }
        button2 = UIButton.init()
        button2.setTitle("班长", for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.setImage(UIImage(systemName: "circle"), for: .normal)
        button2.addTarget(self, action: #selector(type(sender:)), for: .touchUpInside)
        buttonList.append(button2)
        self.view.addSubview(button2)
        button2.snp.makeConstraints { (make) in
            make.left.equalTo(button1.snp.right).offset(80)
            make.centerY.equalTo(button1.snp.centerY)
        }
        button3 = UIButton.init()
        button3.setTitle("辅导员", for: .normal)
        button3.setTitleColor(UIColor.black, for: .normal)
        button3.setImage(UIImage(systemName: "circle"), for: .normal)
        button3.addTarget(self, action: #selector(type(sender:)), for: .touchUpInside)
        buttonList.append(button3)
        self.view.addSubview(button3)
        button3.snp.makeConstraints { (make) in
            make.left.equalTo(button1.snp.left)
            make.centerY.equalTo(label1.snp.centerY).offset(50)
        }
        button4 = UIButton.init()
        button4.setTitle("教师", for: .normal)
        button4.setTitleColor(UIColor.black, for: .normal)
        button4.setImage(UIImage(systemName: "circle"), for: .normal)
        button4.addTarget(self, action: #selector(type(sender:)), for: .touchUpInside)
        buttonList.append(button4)
        self.view.addSubview(button4)
        button4.snp.makeConstraints { (make) in
            make.left.equalTo(button2.snp.left)
            make.centerY.equalTo(button3.snp.centerY)
        }
        label2 = UILabel.init()
        label2.text = "验证消息"
        self.view.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(button3.snp.bottom).offset(50)
        }
        textView = UITextView.init()
        textView.isEditable = true
        textView.text = "请输入验证消息（学院——姓名——职工/学号）"
        textView.font = UIFont.systemFont(ofSize: 17.5)
        textView.textColor = UIColor.placeholderText
        textView.delegate = self
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 12.0
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(label2.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(225)
            make.width.equalToSuperview().offset(-40)
        }
        button = UIButton.init()
        button.setTitle("提交认证信息", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.addTarget(self, action: #selector(send(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-125)
            make.width.equalToSuperview().offset(-100)
        }
    }
    
    @objc func type (sender:UIButton) {
        sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        for button in buttonList {
            if button != sender {
                button.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        type = (sender.titleLabel?.text!)!
    }
    @objc func send (sender:UIButton) {
        
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

extension ChangeViewController : UITextViewDelegate {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        textView.resignFirstResponder()
//        self.endEditing(false)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "请输入内容"
            textView.textColor = UIColor.placeholderText
        }
    }
}
