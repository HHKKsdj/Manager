//
//  SetViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class SetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        self.navigationItem.title = "设置密码"
        // Do any additional setup after loading the view.
        setUI()
    }
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var nameText : UITextField!
    var setLabel1 : UILabel!
    var setLabel2 : UILabel!
    var setText1 : UITextField!
    var setText2 : UITextField!
    var nextButton : UIButton!
    
    var code = ""
    var username = ""
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "基础设置"
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(175)
        }
        
        nameLabel = UILabel.init()
        nameLabel.text = "姓名"
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        nameText = UITextField.init()
        nameText.placeholder = "请输入真实姓名"
        nameText.returnKeyType = .done
        nameText.delegate = self
        let underline0 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline0.backgroundColor = UIColor.lightGray
        nameText.addSubview(underline0)
        self.view.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-40)
        }
        
        setLabel1 = UILabel.init()
        setLabel1.text = "密码"
        self.view.addSubview(setLabel1)
        setLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(nameText.snp.left)
            make.top.equalTo(nameText.snp.bottom).offset(50)
        }
        
        setText1 = UITextField.init()
        setText1.placeholder = "请输入密码"
        setText1.returnKeyType = .done
        setText1.delegate = self
        let underline1 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline1.backgroundColor = UIColor.lightGray
        setText1.addSubview(underline1)
        self.view.addSubview(setText1)
        setText1.snp.makeConstraints { (make) in
            make.left.equalTo(setLabel1.snp.left)
            make.top.equalTo(setLabel1.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-40)
        }
        
        setLabel2 = UILabel.init()
        setLabel2.text = "验证密码"
        self.view.addSubview(setLabel2)
        setLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(setText1.snp.left)
            make.top.equalTo(setText1.snp.bottom).offset(50)
        }
        
        setText2 = UITextField.init()
        setText2.placeholder = "请再次输入密码"
        setText2.returnKeyType = .done
        setText2.delegate = self
        let underline2 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline2.backgroundColor = UIColor.lightGray
        setText2.addSubview(underline2)
        self.view.addSubview(setText2)
        setText2.snp.makeConstraints { (make) in
            make.left.equalTo(setLabel2.snp.left)
            make.top.equalTo(setLabel2.snp.bottom).offset(25)
            make.width.equalTo(setText1.snp.width)
        }
        
        nextButton = UIButton.init()
        nextButton.setTitle("完成", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        nextButton.backgroundColor = UIColor.systemTeal
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = 12.0
        nextButton.addTarget(self, action: #selector(next(sender:)), for: .touchUpInside)
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(setText2).offset(125)
            make.width.equalTo(setText2.snp.width)
            make.height.equalTo(50)
        }
        
    }

    @objc func next (sender:UIButton) {
        register()
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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

extension SetViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        setText1.resignFirstResponder()
        setText2.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        setText1.resignFirstResponder()
        setText2.resignFirstResponder()
    }
}

extension SetViewController {
    func register() {
        if setText1.text != nil && setText2.text != nil && nameText.text != nil {
            if setText1.text == setText2.text {
                UserNetwork.shared.RegisterRequest(username: self.username, password: self.setText1.text!, realName: nameText.text!) {(error,info) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let content = info else {
                        print("nil")
                        return
                    }
                    if content.code == 200 {
                        self.finishRegister()
                    } else {
                        self.error()
                    }

                }
            } else {
                let alter = UIAlertController(title: "密码验证失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
    
    func finishRegister() {
        UserNetwork.shared.FinishRegisterRequest(username: username, mailCode: code) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "注册成功", message: "稍后可在“我的”——“帮助”中绑定公众号，以获取最新通知", preferredStyle: .alert)
                let action = UIAlertAction(title: "返回登录", style: .default, handler: {_ in
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                })
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            } else {
                self.error()
            }
        }
    }
    
    func error() {
        let alter = UIAlertController(title: "注册失败", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alter.addAction(action)
        self.present(alter, animated: true, completion: nil)
    }
}
