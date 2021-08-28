//
//  LoginViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var titleLabel : UILabel!
    var userLabel : UILabel!
    var passwordLabel : UILabel!
    var userText : UITextField!
    var passwordText : UITextField!
    var loginButton : UIButton!
    var registerButton : UIButton!
    var passwordButton : UIButton!
    var password = ""
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "欢迎使用福大班务"
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(175)
        }
        
        userLabel = UILabel.init()
        userLabel.text = "账号"
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
        
        passwordLabel = UILabel.init()
        passwordLabel.text = "密码"
        self.view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userText.snp.left)
            make.top.equalTo(userText.snp.bottom).offset(50)
        }
        
        passwordText = UITextField.init()
        passwordText.placeholder = "请输入密码"
        passwordText.returnKeyType = .done
        passwordText.delegate = self
        passwordText.isSecureTextEntry = true
        let underline2 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline2.backgroundColor = UIColor.lightGray
        passwordText.addSubview(underline2)
        self.view.addSubview(passwordText)
        passwordText.snp.makeConstraints { (make) in
            make.left.equalTo(passwordLabel.snp.left)
            make.top.equalTo(passwordLabel.snp.bottom).offset(25)
            make.width.equalTo(userText.snp.width)
        }
        
        loginButton = UIButton.init()
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginButton.backgroundColor = UIColor.systemTeal
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 12.0
        loginButton.addTarget(self, action: #selector(login(sender:)), for: .touchUpInside)
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordText).offset(100)
            make.width.equalTo(passwordText.snp.width)
            make.height.equalTo(50)
        }
        
        passwordButton = UIButton.init()
        passwordButton.setTitle("忘记密码", for: .normal)
        passwordButton.setTitleColor(.gray, for: .normal)
        passwordButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        passwordButton.addTarget(self, action: #selector(password(sender:)), for: .touchUpInside)
        self.view.addSubview(passwordButton)
        passwordButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.left.equalTo(loginButton.snp.left).offset(15)
        }
        
        registerButton = UIButton.init()
        registerButton.setTitle("注册账号", for: .normal)
        registerButton.setTitleColor(.gray, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerButton.addTarget(self, action: #selector(register(sender:)), for: .touchUpInside)
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordButton.snp.top)
            make.right.equalTo(loginButton.snp.right).offset(-15)
        }
    }
    
    @objc func login (sender:UIButton) {
        login()
    }
    @objc func register (sender:UIButton) {
        let registerVC = RegisterViewController()
        let naviVC = UINavigationController(rootViewController: registerVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .flipHorizontal
        self.present(naviVC, animated: true, completion: nil)
    }
    @objc func password (sender:UIButton) {
        let passwordVC = PasswordViewController()
        let naviVC = UINavigationController(rootViewController: passwordVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .flipHorizontal
        self.present(naviVC, animated: true, completion: nil)
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        userText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        userText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
}

extension LoginViewController {
    func login() {
        if userText.text!.count > 0 && passwordText.text!.count > 0 {
            UserNetwork.shared.LoginRequest(username: self.userText.text!, password: self.passwordText.text!) { (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                print(content.code)

                if content.code == 200 {
                    let tabBarVC = TabBarViewController()
                    tabBarVC.modalPresentationStyle = .fullScreen
                    tabBarVC.modalTransitionStyle = .crossDissolve
                    self.present(tabBarVC, animated: true, completion: nil)
                    self.userText.text = ""
                    self.passwordText.text = ""
                } else {
                    let alter = UIAlertController(title: content.msg, message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: {_ in
                        self.passwordText.text = ""
                    })
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }
            }
        }
    }
}
