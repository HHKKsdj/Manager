//
//  PasswordViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class PasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
//        self.navigationItem.title = "忘记密码"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var titleLabel : UILabel!
    var userLabel : UILabel!
    var mailLabel : UILabel!
    var codeLabel : UILabel!
    var userText : UITextField!
    var codeText : UITextField!
    var codeButton : UIButton!
    var nextButton : UIButton!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "忘记密码"
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(175)
        }
        
        userLabel = UILabel.init()
        userLabel.text = "福大邮箱"
        self.view.addSubview(userLabel)
        userLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        userText = UITextField.init()
        userText.placeholder = "请输入学号"
        userText.returnKeyType = .done
        userText.delegate = self
        let underline1 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline1.backgroundColor = UIColor.lightGray
        userText.addSubview(underline1)
        self.view.addSubview(userText)
        userText.snp.makeConstraints { (make) in
            make.left.equalTo(userLabel.snp.left)
            make.top.equalTo(userLabel.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-40)
        }
        
        mailLabel = UILabel.init()
        mailLabel.text = "@fzu.edu.cn"
        self.view.addSubview(mailLabel)
        mailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(userText.snp.right)
            make.top.equalTo(userText.snp.top)
        }
        
        codeLabel = UILabel.init()
        codeLabel.text = "验证码"
        self.view.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userText.snp.left)
            make.top.equalTo(userText.snp.bottom).offset(50)
        }
        
        codeText = UITextField.init()
        codeText.placeholder = "请输入验证码"
        codeText.returnKeyType = .done
        codeText.delegate = self
        let underline2 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline2.backgroundColor = UIColor.lightGray
        codeText.addSubview(underline2)
        self.view.addSubview(codeText)
        codeText.snp.makeConstraints { (make) in
            make.left.equalTo(codeLabel.snp.left)
            make.top.equalTo(codeLabel.snp.bottom).offset(25)
            make.width.equalTo(userText.snp.width)
        }
        
        codeButton = UIButton.init()
        codeButton.setTitle("发送验证码", for: .normal)
        codeButton.backgroundColor = UIColor.systemTeal
        codeButton.layer.masksToBounds = true
        codeButton.layer.cornerRadius = 12.0
        codeButton.addTarget(self, action: #selector(code(sender:)), for: .touchUpInside)
        self.view.addSubview(codeButton)
        codeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeText.snp.bottom)
            make.right.equalTo(codeText.snp.right)
            make.width.equalTo(100)
        }
        
        nextButton = UIButton.init()
        nextButton.setTitle("下一步", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        nextButton.backgroundColor = UIColor.systemTeal
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = 12.0
        nextButton.addTarget(self, action: #selector(next(sender:)), for: .touchUpInside)
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeText).offset(100)
            make.width.equalTo(codeText.snp.width)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func code (sender:UIButton) {
        sendMail()
        var count = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if count == 1 {
                self.codeButton.setTitle("发送验证码", for: .normal)
                self.codeButton.backgroundColor = UIColor.systemTeal
                self.codeButton.isEnabled = true
                timer.invalidate()
            } else if count == 60 {
                count -= 1
                self.codeButton.backgroundColor = UIColor.gray
                self.codeButton.isEnabled = false
                self.codeButton.setTitle("\(count)s", for: .normal)
            } else {
                count -= 1
                self.codeButton.setTitle("\(count)s", for: .normal)
            }
        }
    }
    @objc func next (sender:UIButton) {
        compareCode()
//        let resetVC = ResetViewController()
//        self.navigationController?.pushViewController(resetVC, animated: true)
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

extension PasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        userText.resignFirstResponder()
        codeText.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        userText.resignFirstResponder()
        codeText.resignFirstResponder()
    }
}

extension PasswordViewController {
    func sendMail() {
        if userText.text!.count > 0 {
            UserNetwork.shared.SendMailRequest(username: self.userText.text!) { (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                print(content.code)
                let alter = UIAlertController(title: "\(content.msg)", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
    func compareCode() {
        if codeText.text!.count > 0 {
            UserNetwork.shared.CompareCodeRequest(username: userText.text!, mailCode: codeText.text!) { (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content == true {
                    let resetVC = ResetViewController()
                    resetVC.code = self.codeText.text!
                    resetVC.username = self.userText.text!
                    self.navigationController?.pushViewController(resetVC, animated: true)
                } else {
                    let alter = UIAlertController(title: "验证码错误", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                    self.codeText.text = ""
                }
            }
        }
    }
}
