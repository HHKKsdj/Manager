//
//  CheckByTimeViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class CheckByTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "定时签到"
        // Do any additional setup after loading the view.
        getName()
        signinDetail()
        setUI()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        signinDetail()
//    }
    
    var notice = NoticeInfo()
    var nameList = [UserInfo]()
    var notSigninList = [String]()
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var startTime : UILabel!
    var endTime : UILabel!
    var involveButton : UIButton!
    var checkButton : UIButton!
    var confirmed = false
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "【定时签到】" + notice.title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(5)
        }
        
        nameLabel = UILabel.init()
//        nameLabel.text = "HK"
        nameLabel.text = notice.publisher
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        startTime = UILabel.init()
//        startTime.text = "2021-12-12 16:30"
        startTime.text = notice.publishTime
        startTime.textColor = UIColor.gray
        startTime.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.top.equalTo(nameLabel.snp.top)
        }
        
        endTime = UILabel.init()
//        endTime.text = "截止时间:"+"2021-12-13 19:00"
        endTime.text = "截止时间:"+notice.deadline
        endTime.textColor = UIColor.red
        endTime.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.top.equalTo(startTime.snp.top)
            make.right.equalToSuperview().offset(-10)
        }
        
        involveButton = UIButton.init()
        involveButton.setTitle("参与情况 >", for: .normal)
        involveButton.setTitleColor(.black, for: .normal)
//        involveButton.tintColor = UIColor.black
//        involveButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        involveButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
//        involveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -30)
        involveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.5)
        involveButton.contentHorizontalAlignment = .left
        involveButton.addTarget(self, action: #selector(involve(sender:)), for: .touchUpInside)
        self.view.addSubview(involveButton)
        involveButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }
        
        checkButton = UIButton.init(frame: CGRect(x: self.view.frame.width/4, y: 400 , width: 200, height: 200))
        if confirmed == false {
            checkButton.setTitle("签到", for: .normal)
            checkButton.backgroundColor = UIColor.systemTeal
        } else {
            self.checkButton.backgroundColor = UIColor.lightGray
            self.checkButton.setTitle("已签到", for: .normal)
            self.checkButton.isEnabled = false
        }
        
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        
        checkButton.layer.masksToBounds = true
        checkButton.layer.cornerRadius = checkButton.frame.size.width/2
        checkButton.isUserInteractionEnabled = true
        checkButton.addTarget(self, action: #selector(check(sender:)), for: .touchUpInside)
        self.view.addSubview(checkButton)
    }
    
    @objc func check (sender:UIButton) {
        signin()
    }
    @objc func involve (sender:UIButton) {
        var confirmList = [String]()
        for name in nameList {
            if !notSigninList.contains(name.username) {
                confirmList.append(name.username)
            }
        }
        let involveVC = InvolveViewController()
        involveVC.nameList = nameList
        involveVC.okList = confirmList
        self.navigationController?.pushViewController(involveVC, animated: true)
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
//MARK: Network
extension CheckByTimeViewController {
    func signin() {
        ClassNetwork.shared.SigninRequest(classID: notice.classID, signID: notice.signID, key: "0"){ (error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "签到成功", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
                self.checkButton.backgroundColor = UIColor.lightGray
                self.checkButton.setTitle("已签到", for: .normal)
                self.checkButton.isEnabled = false
            } else {
                let alter = UIAlertController(title: "签到失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
    func signinDetail() {
        ClassNetwork.shared.SigninDetailRequest(classID: notice.classID, signID: notice.signID){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.notSigninList = content.notConfirmList
            }
        }
    }
    func getName() {
        ClassNetwork.shared.GetStudentRequest(classID: notice.classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.nameList.count != 0 {
                self.nameList = content.nameList
            }
        }
    }
}
