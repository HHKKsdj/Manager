//
//  CheckAnnouncementViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class CheckAnnouncementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "公告"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        getConfirm()
        getName()
        setUI()
    }
    
    var notice = NoticeInfo()
    var user = UserInfo()
    
    var scrollView : UIView!
    var contentView : UIView!
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var startTime : UILabel!
    var endTime : UILabel!
    var contentLabel : UILabel!
    var involveButton : UIButton!
    var confirmButton : UIButton!
    var confirmList = [String]()
    var nameList = [UserInfo]()
    var confirmed = false
    
    func setUI() {
        scrollView = UIScrollView.init()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(90)
            make.left.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview()
        }
        
        contentView = UIView.init()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        titleLabel = UILabel.init()
//        titleLabel.text = "TESTLABEL"
        titleLabel.text = "【公告】" + notice.title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(5)
        }
        
        nameLabel = UILabel.init()
//        nameLabel.text = "HK"
        nameLabel.text = notice.publisher
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12.5)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        startTime = UILabel.init()
//        startTime.text = "2021-12-12 16:30"
        startTime.text = notice.publishTime
        startTime.textColor = UIColor.gray
        startTime.font = UIFont.systemFont(ofSize: 12.5)
        contentView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.top.equalTo(nameLabel.snp.top)
        }
        
        endTime = UILabel.init()
//        endTime.text = "截止时间:"+"2021-12-13 19:00"
        endTime.text = "截止时间:" + notice.deadline
        endTime.textColor = UIColor.red
        endTime.font = UIFont.systemFont(ofSize: 12.5)
        contentView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.top.equalTo(startTime.snp.top)
            make.right.equalToSuperview().offset(-15)
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
        contentView.addSubview(involveButton)
        involveButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
        }
        
        contentLabel = UILabel.init()
        contentLabel.numberOfLines = 0
        contentLabel.text = notice.body
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(involveButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
        }
        
        confirmButton = UIButton.init()
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        if confirmed == false {
            timer()
            confirmButton.backgroundColor = UIColor.lightGray
            confirmButton.isEnabled = false
            confirmButton.setTitle("确认公告(5s)", for: .normal)
        } else {
            confirmButton.backgroundColor = UIColor.lightGray
            confirmButton.isEnabled = false
            confirmButton.setTitle("已确认", for: .normal)
        }
        if notice.publisher == user.username {
            confirmButton.isHidden = true
        }
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 12.0
        confirmButton.addTarget(self, action: #selector(confirm(sender:)), for: .touchUpInside)
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
            make.width.equalToSuperview().offset(-100)
        }
    }
    func timer() {
        var count = 5
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if count == 1 {
                self.confirmButton.setTitle("确认公告", for: .normal)
                self.confirmButton.backgroundColor = UIColor.systemTeal
                self.confirmButton.isEnabled = true
                timer.invalidate()
            } else {
                count -= 1
                self.confirmButton.backgroundColor = UIColor.lightGray
                self.confirmButton.isEnabled = false
                self.confirmButton.setTitle("确认公告(\(count)s)", for: .normal)
            }
        }
    }
    @objc func confirm (sender:UIButton) {
        confirm()
    }
    @objc func involve (sender:UIButton) {
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

extension CheckAnnouncementViewController {
    func confirm() {
        ClassNetwork.shared.AnnouncementRequest(classID: notice.classID, nid: notice.nid){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "确认成功", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
                self.confirmButton.backgroundColor = UIColor.lightGray
                self.confirmButton.isEnabled = false
                self.confirmButton.setTitle("已确认", for: .normal)
            }
        }
    }
    func getConfirm() {
        ClassNetwork.shared.ConfirmAccouncementRequest(classID: notice.classID, nid: notice.nid){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.confirmList = content.confirmList
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
