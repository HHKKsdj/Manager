//
//  CheckAnnouncementViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit
import Kingfisher

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
        getID()
//        setUI()
    }
    
    func getID() {
        if notice.body.contains("{") {
            let body = notice.body.split(separator: "{")
            bodyText = String(body.first!)
            let idList = body.last?.split(separator: "}").first
            print(String(idList!))
            let list = idList?.components(separatedBy: ",")
            if list?.count == 1 {
                let str = list![0]
                let char : Character = str[str.index(str.startIndex, offsetBy: 0)]
                print(char)
                if char == ":" {
                    let fid = str.components(separatedBy: ":").last!
                    fidList.append(fid)
                    getAFile(fid: Int(fid)!)
                    
                } else {
                    let imageid = str.components(separatedBy: ":").first!
                    imageidList.append(imageid)
                    setUI()
                }
            } else if ((list?.first?.contains(":")) == true) {
                let fid = idList?.split(separator: ":").last
                fidList = (fid?.components(separatedBy: ","))!
                for fid in fidList {
                    getAFile(fid: Int(fid)!)
                }
            } else if ((list?.last?.contains(":")) == true) {
                let imageid = idList?.split(separator: ":").first
                imageidList = (imageid?.components(separatedBy: ","))!
                setUI()
            }  else {
                let imageid = idList?.split(separator: ":").first
                let fid = idList?.split(separator: ":").last
                imageidList = (imageid?.components(separatedBy: ","))!
                fidList = (fid?.components(separatedBy: ","))!
                for fid in fidList {
                    getAFile(fid: Int(fid)!)
                }
            }
            
//            let imageid = idList?.split(separator: ":").first
//            let fid = idList?.split(separator: ":").last
//            print(String(body.last!))
//            if imageid?.count != 0 {
//                imageidList = (imageid?.components(separatedBy: ","))!
//            }
//            if fid?.count != 0 && imageid != fid{
//                fidList = (fid?.components(separatedBy: ","))!
//                for fid in fidList {
//                    getAFile(fid: Int(fid)!)
//                }
//            } else {
//                setUI()
//            }
        } else {
            bodyText = notice.body
            setUI()
        }
        
    }
    
    var notice = NoticeInfo()
    var user = UserInfo()
    
    var bodyText = ""
    var fidList = [String]()
    var imageidList = [String]()
    var fileList = [FileInfo]()
    
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
    
    var imageView : UIImageView!
    var fileView : UIView!
    var fileImage : UIImageView!
    var fileName : UILabel!
    var download : UIButton!
    
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
//        contentView.snp.makeConstraints { (make) in
//            make.edges.width.equalTo(scrollView)
//            make.top.equalTo(scrollView)
//            make.height.greaterThanOrEqualTo(scrollView)
//        }
        
        titleLabel = UILabel.init()
//        titleLabel.text = "TESTLABEL"
        titleLabel.text = "【公告】" + notice.title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
//            make.height.equalTo(40)
            make.left.equalToSuperview().offset(5)
        }
        
        nameLabel = UILabel.init()
//        nameLabel.text = "HK"
        nameLabel.text = notice.publisher
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12.5)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
//            make.height.equalTo(25)
        }
        
        startTime = UILabel.init()
//        startTime.text = "2021-12-12 16:30"
        startTime.text = notice.publishTime
        startTime.textColor = UIColor.gray
        startTime.font = UIFont.systemFont(ofSize: 12.5)
        contentView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.top.equalTo(nameLabel.snp.top)
//            make.height.equalTo(25)
        }
        
        endTime = UILabel.init()
//        endTime.text = "截止时间:"+"2021-12-13 19:00"
        endTime.text = "截止时间:" + notice.deadline
        endTime.textColor = UIColor.red
        endTime.font = UIFont.systemFont(ofSize: 12.5)
        contentView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.top.equalTo(startTime.snp.top)
            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(25)
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
//            make.height.equalTo(25)
        }
        
        contentLabel = UILabel.init()
        contentLabel.numberOfLines = 0
        contentLabel.text = bodyText
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(involveButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
        }
        
        var lastImageView = UIImageView()
        for i in 0..<imageidList.count {
            imageView = UIImageView.init()
            imageView.kf.indicatorType = .activity
            let token = UserDefaults.standard.string(forKey: "token")! as String
            if let url = URL(string: "http://goback.jessieback.top/classes/\(notice.classID)/download?token=\(token)&classID=\(notice.classID)&fid=\(imageidList[i])") {
                imageView.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
//            imageView.image = UIImage(named: "test")
            
//            if let url = URL(string: "http://goback.jessieback.top/classes/\(notice.classID)/download?token=\(token)&classID=\(notice.classID)&fid=\(imageidList[i])") {
//                imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image) in
//                    print(image）
//                })
//            }
            
            contentView.addSubview(imageView)
            if i == 0 {
                imageView.snp.makeConstraints { (make) in
                    make.top.equalTo(contentLabel.snp.bottom).offset(15)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().offset(25)
                    make.height.equalTo(375)
                }
            } else {
                imageView.snp.makeConstraints { (make) in
                    make.top.equalTo(lastImageView.snp.bottom).offset(1)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().offset(25)
                    make.height.equalTo(375)
                }
            }
            lastImageView = imageView
        }
        
        if fileList.count != 0 {
            setFileView()
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
            if fileList.count != 0 {
                make.top.equalTo(fileView.snp.bottom).offset(50)
            } else if imageidList.count != 0 {
                make.top.equalTo(imageView.snp.bottom).offset(50)
            } else {
                make.top.equalTo(contentLabel.snp.bottom).offset(50)
            }

            make.width.equalToSuperview().offset(-100)
        }

        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
//            make.height.greaterThanOrEqualTo(scrollView).offset(1)
            if user.username == notice.publisher {
                if fileList.count != 0 {
                    make.bottom.equalTo(fileView.snp.bottom).offset(7.5)
                } else if imageidList.count != 0 {
                    make.bottom.equalTo(imageView.snp.bottom).offset(7.5)
                } else {
                    make.bottom.equalToSuperview()
                }
            } else {
                make.bottom.equalTo(confirmButton.snp.bottom).offset(7.5)
//                make.bottom.equalToSuperview()
            }
        }
    }
    
    func setFileView() {
        var lastFileView = UIView()
        for i in 0..<fileList.count {
            if i == 0 {
                fileView = UIView.init()
//                fileView.backgroundColor = UIColor.green
                self.contentView.addSubview(fileView)
                fileView.snp.makeConstraints { (make) in
                    if imageidList.count == 0 {
                        make.top.equalTo(contentLabel.snp.bottom).offset(15)
                    } else {
                        make.top.equalTo(imageView.snp.bottom).offset(15)
                    }
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(50)
                }
            } else {
                fileView = UIView.init()
                self.contentView.addSubview(fileView)
                fileView.snp.makeConstraints { (make) in
                    make.top.equalTo(lastFileView.snp.bottom)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(50)
                }
            }
            
            fileView.layer.masksToBounds = true
    //        fileView.layer.cornerRadius = 12.0
            fileView.layer.borderWidth = 0.35
            fileView.layer.borderColor = UIColor.gray.cgColor
            
            fileImage = UIImageView.init()
            let type = fileList[i].name.split(separator: ".").last
            fileImage.image = UIImage(named: "\(type!)")
            fileView.addSubview(fileImage)
            fileImage.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(35)
                make.height.equalTo(35)
            }

            fileName = UILabel.init()
            fileName.text = fileList[i].name
            fileView.addSubview(fileName)
            fileName.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(fileImage.snp.right).offset(25)
            }

            download = UIButton.init()
            download.tag = i
            download.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
            download.addTarget(self, action: #selector(download(sender:)), for: .touchUpInside)
            fileView.addSubview(download)
            download.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalToSuperview()
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            
            lastFileView = fileView
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
    
    @objc func download (sender:UIButton) {
        download(fid: fileList[sender.tag].fid,fileName: fileList[sender.tag].name)
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
//MARK: Network
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
    
    func getAFile(fid:Int) {
        ClassNetwork.shared.GetAFileRequest(classID: notice.classID, fid: fid) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.file.name != "" {
                self.fileList.append(content.file)
                if self.fidList.count == self.fileList.count {
                    self.setUI()
                }
            } else {
                self.setUI()
            }
        }
    }
    func download(fid:Int,fileName:String) {
        ClassNetwork.shared.DownloadRequest(classID: notice.classID,fid: fid, fileName: fileName) {(error,info) in
            if let error = error {
                print(error)
                let alter = UIAlertController(title: "文件已存在", message: "可在手机文件中查看", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                    alter.dismiss(animated: true, completion: nil)
                }
//                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1.5)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.msg == "success" {
                let alter = UIAlertController(title: "文件保存成功", message: "可在手机文件中查看", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
//                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                    alter.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
