//
//  CreatClassViewController.swift
//  Demo
//
//  Created by HK on 2021/8/3.
//

import UIKit

class CreatClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "创建班级"
        // Do any additional setup after loading the view.
        setUI()
    }
        
    var nameLabel : UILabel!
    var nameText : UITextField!
    var timeLabel : UILabel!
    var timeText : UITextField!
    var checkLabel : UILabel!
    var collegeLabel : UILabel!
    var collegeText : UITextField!
    var checkSwitch : UISwitch!
    var creatButton : UIButton!
    
    func setUI() {
        nameLabel = UILabel.init()
        nameLabel.text = "班级名称"
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.left.equalToSuperview().offset(25)
        }
        
        nameText = UITextField.init()
        nameText.placeholder = "请输入班级名称"
        nameText.borderStyle = UITextField.BorderStyle.roundedRect
        nameText.layer.masksToBounds = true
        nameText.layer.cornerRadius = 12.0
        nameText.layer.borderWidth = 0.5
        nameText.layer.borderColor = UIColor.gray.cgColor
        nameText.returnKeyType = .done
        nameText.delegate = self
        self.view.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(20)
            make.width.equalTo(250)
        }
        
//        timeLabel = UILabel.init()
//        timeLabel.text = "上课时间"
//        self.view.addSubview(timeLabel)
//        timeLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(nameLabel.snp.bottom).offset(50)
//            make.left.equalTo(nameLabel.snp.left)
//        }

//        timeText = UITextView.init()
//        timeText.isEditable = true
//        timeText.text = "请输入班级介绍"
//        timeText.font = UIFont.systemFont(ofSize: 17.5)
//        timeText.textColor = UIColor.placeholderText
//        timeText.delegate = self
//        timeText.layer.masksToBounds = true
//        timeText.layer.cornerRadius = 12.0
//        timeText.layer.borderWidth = 0.5
//        timeText.layer.borderColor = UIColor.gray.cgColor
//        timeText = UITextField.init()
//        timeText.placeholder = "请输入上课时间"
//        timeText.borderStyle = UITextField.BorderStyle.roundedRect
//        timeText.layer.masksToBounds = true
//        timeText.layer.cornerRadius = 12.0
//        timeText.layer.borderWidth = 0.5
//        timeText.layer.borderColor = UIColor.gray.cgColor
//        timeText.returnKeyType = .done
//        timeText.delegate = self
//        self.view.addSubview(timeText)
//        timeText.snp.makeConstraints { (make) in
//            make.centerY.equalTo(timeLabel.snp.centerY)
//            make.left.equalTo(nameText.snp.left)
//            make.width.equalTo(250)
//        }
//
//        collegeLabel = UILabel.init()
//        collegeLabel.text = "授课学院"
//        self.view.addSubview(collegeLabel)
//        collegeLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(timeLabel.snp.bottom).offset(50)
//            make.left.equalTo(nameLabel.snp.left)
//        }
//
//        collegeText = UITextField.init()
//        collegeText.placeholder = "请输入授课学院"
//        collegeText.borderStyle = UITextField.BorderStyle.roundedRect
//        collegeText.layer.masksToBounds = true
//        collegeText.layer.cornerRadius = 12.0
//        collegeText.layer.borderWidth = 0.5
//        collegeText.layer.borderColor = UIColor.gray.cgColor
//        collegeText.returnKeyType = .done
//        collegeText.delegate = self
//        self.view.addSubview(collegeText)
//        collegeText.snp.makeConstraints { (make) in
//            make.centerY.equalTo(collegeLabel.snp.centerY)
//            make.left.equalTo(nameText.snp.left)
//            make.width.equalTo(250)
//        }
        
        checkLabel = UILabel.init()
        checkLabel.text = "无需审核"
        self.view.addSubview(checkLabel)
        checkLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
            make.left.equalTo(nameLabel.snp.left)
        }
        
        checkSwitch = UISwitch.init()
        checkSwitch.addTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)
        self.view.addSubview(checkSwitch)
        checkSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(checkLabel.snp.centerY)
            make.left.equalTo(nameText.snp.left)
        }
        
        creatButton = UIButton.init()
        creatButton.setTitle("发布", for: .normal)
        creatButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        creatButton.backgroundColor = UIColor.link
        creatButton.layer.masksToBounds = true
        creatButton.layer.cornerRadius = 12.0
        creatButton.addTarget(self, action: #selector(creat(sender:)), for: .touchUpInside)
        self.view.addSubview(creatButton)
        creatButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalToSuperview().offset(-100)
        }
    }
    
    @objc func switchChange (sender:UISwitch) {
        print(checkSwitch.isOn)
    }
    
    @objc func creat (sender:UIButton) {
        creat()
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

extension CreatClassViewController: UITextViewDelegate,UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        nameText.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //点击空白处收起键盘
//        timeText.resignFirstResponder()
        nameText.resignFirstResponder()
        self.view.endEditing(false)

    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.placeholderText {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "请输入班级介绍"
//            textView.textColor = UIColor.placeholderText
//        }
//    }
}

extension CreatClassViewController {
    func creat() {
        ClassNetwork.shared.CreatClassRequest(name: nameText.text!, schedule: timeText.text!,college: collegeText.text!) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.autoAccept(classID: content.data)
            }
        }
    }
    
    func autoAccept(classID:String) {
        ClassNetwork.shared.AutoAcceptRequest(classID: classID, enable: checkSwitch.isOn) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "创建成功", message: "班级码为\(classID)/n可在班级详情中查看", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: {_ in
                    self.dismiss(animated: true, completion: nil)
                })
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            } else {
                let alter = UIAlertController(title: "创建失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
}
