//
//  JoinClassViewController.swift
//  Demo
//
//  Created by HK on 2021/8/15.
//

import UIKit

class JoinClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
//        self.navigationItem.title = "加入班级"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var titleLabel : UILabel!
    var codeLabel : UILabel!
    var codeText : UITextField!
    var button : UIButton!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "加入班级"
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(175)
        }
        
        codeLabel = UILabel.init()
        codeLabel.text = "班级码"
        self.view.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
        }
        
        codeText = UITextField.init()
        codeText.placeholder = "请输入班级码"
        codeText.returnKeyType = .done
        codeText.delegate = self
        let underline2 = UIView.init(frame: CGRect.init(x: 0, y: 30, width: 350, height: 1))
        underline2.backgroundColor = UIColor.lightGray
        codeText.addSubview(underline2)
        self.view.addSubview(codeText)
        codeText.snp.makeConstraints { (make) in
            make.left.equalTo(codeLabel.snp.left)
            make.top.equalTo(codeLabel.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-40)
        }
        
        button = UIButton.init()
        button.setTitle("提交申请", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemTeal
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.addTarget(self, action: #selector(join(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeText.snp.bottom).offset(150)
            make.width.equalTo(codeText.snp.width)
            make.height.equalTo(50)
        }
    }
    @objc func join (sender:UIButton) {
        joinClass()
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

extension JoinClassViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        codeText.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
        codeText.resignFirstResponder()
    }
}

extension JoinClassViewController {
    func joinClass() {
        if codeText.text != "" {
            ClassNetwork.shared.JoinClassRequest(classID: codeText.text!){(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    let alter = UIAlertController(title: "提交成功", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                } else {
                    let alter = UIAlertController(title: content.msg, message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alter.addAction(action)
                    self.present(alter, animated: true, completion: nil)
                }
            }
        }
    }
}
