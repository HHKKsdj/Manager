//
//  ResetPasswordViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "修改密码"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var oldPasswordLabel : UILabel!
    var oldPasswordText : UITextField!
    var newPasswordLabel1 : UILabel!
    var newPasswordText1 : UITextField!
    var newPasswordLabel2 : UILabel!
    var newPasswordText2 : UITextField!
    var button : UIButton!
    
    func setUI() {
        oldPasswordLabel = UILabel.init()
        oldPasswordLabel.text = "密码"
        self.view.addSubview(oldPasswordLabel)
        oldPasswordLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(150)
        }
        
        oldPasswordText = UITextField.init()
        oldPasswordText.placeholder = "请输入当前密码"
        oldPasswordText.returnKeyType = .done
        oldPasswordText.delegate = self
        let underline1 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline1.backgroundColor = UIColor.lightGray
        oldPasswordText.addSubview(underline1)
        self.view.addSubview(oldPasswordText)
        oldPasswordText.snp.makeConstraints { (make) in
            make.left.equalTo(oldPasswordLabel.snp.left)
            make.top.equalTo(oldPasswordLabel.snp.bottom).offset(25)
            make.width.equalTo(350)
        }

        newPasswordLabel1 = UILabel.init()
        newPasswordLabel1.text = "新密码"
        self.view.addSubview(newPasswordLabel1)
        newPasswordLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(oldPasswordLabel.snp.left)
            make.top.equalTo(oldPasswordText.snp.bottom).offset(50)
        }

        newPasswordText1 = UITextField.init()
        newPasswordText1.placeholder = "请输入新密码"
        newPasswordText1.returnKeyType = .done
        newPasswordText1.delegate = self
        let underline2 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline2.backgroundColor = UIColor.lightGray
        newPasswordText1.addSubview(underline2)
        self.view.addSubview(newPasswordText1)
        newPasswordText1.snp.makeConstraints { (make) in
            make.left.equalTo(newPasswordLabel1.snp.left)
            make.top.equalTo(newPasswordLabel1.snp.bottom).offset(25)
            make.width.equalTo(350)
        }

        newPasswordLabel2 = UILabel.init()
        newPasswordLabel2.text = "确认密码"
        self.view.addSubview(newPasswordLabel2)
        newPasswordLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(newPasswordLabel1.snp.left)
            make.top.equalTo(newPasswordText1.snp.bottom).offset(50)
        }

        newPasswordText2 = UITextField.init()
        newPasswordText2.placeholder = "请确认新密码"
        newPasswordText2.returnKeyType = .done
        newPasswordText2.delegate = self
        let underline3 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline3.backgroundColor = UIColor.lightGray
        newPasswordText2.addSubview(underline3)
        self.view.addSubview(newPasswordText2)
        newPasswordText2.snp.makeConstraints { (make) in
            make.left.equalTo(newPasswordLabel2.snp.left)
            make.top.equalTo(newPasswordLabel2.snp.bottom).offset(25)
            make.width.equalTo(350)
        }
        
        button = UIButton.init()
        button.setTitle("确认更改", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.addTarget(self, action: #selector(done(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalToSuperview().offset(-100)
        }
    }
    
    @objc func done (sender:UIButton) {
        reset()
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

extension ResetPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        oldPasswordText.resignFirstResponder()
        newPasswordText1.resignFirstResponder()
        newPasswordText2.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        oldPasswordText.resignFirstResponder()
        newPasswordText1.resignFirstResponder()
        newPasswordText2.resignFirstResponder()
    }
}


extension ResetPasswordViewController {
    func reset() {
        if oldPasswordText.text != nil && newPasswordText1.text != nil {
            if newPasswordText1.text == newPasswordText2.text {
                UserNetwork.shared.ResetPasswordRequest(oldPassword: oldPasswordText.text!, newPassword: newPasswordText1.text!){(error,info) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let content = info else {
                        print("nil")
                        return
                    }
                    var title = ""
                    if content.code == 200 {
                        title = "修改成功"
                    } else {
                        title = "修改失败"
                    }
                    let alter = UIAlertController(title: title, message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }
            } else {
                let alter = UIAlertController(title: "密码验证失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
}
