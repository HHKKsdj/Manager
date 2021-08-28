//
//  InformationViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit
import AnyImageKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "个人信息"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        if user.role == "student" {
            self.infoList = [user.username+user.realName,"数学与计算机科学学院","计算机类","04",user.username+"@fzu.edu.cn"]
            self.labelList = ["名称","学院","专业","班级","邮箱"]
        } else {
            var role = ""
            if user.role == "teacher" {
                role = "教师"
            } else if user.role == "admin" {
                role = "管理员"
            } else {
                role = user.role
            }
            self.infoList = [user.username+user.realName,"数学与计算机科学学院",role,user.username+"@fzu.edu.cn"]
            self.labelList = ["名称","学院","类别","邮箱"]
        }
        
        setUI()
    }
    
    var user = UserInfo()
    
    var tableView : UITableView!
    var labelList = [String]()
    var infoList = [String]()
    var image = UIImage(named: "test")
    var label : UILabel!
    
    func setUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.sectionHeaderHeight = 0
        
        tableView.register(InformationHeaderCell.self, forCellReuseIdentifier: "InformationHeaderCell")
        tableView.register(InformationCell.self, forCellReuseIdentifier: "InformationCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        label = UILabel.init()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.systemGray
        label.text = "信息修改请联系\n563589126@qq.com"
        label.numberOfLines = 0
        self.tableView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tableView.snp.bottom).offset(550)
            make.width.equalTo(250)
            make.height.equalTo(200)
        }
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

extension InformationViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if user.role == "student" {
                return 4
            } else {
                return 3
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InformationHeaderCell", for: indexPath) as! InformationHeaderCell
            cell.HeadImageView.image = image
            cell.titleLabel.text = "头像"
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as! InformationCell
            if indexPath.section != 2 {
                cell.titleLabel.text = labelList[indexPath.row]
                cell.contentLabel.text = infoList[indexPath.row]
            } else {
                cell.titleLabel.text = labelList.last
                cell.contentLabel.text = infoList.last
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            var options = PickerOptionsInfo()
            options.selectLimit = 1
            let controller = ImagePickerController(options: options, delegate: self)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }
}

extension InformationViewController : ImagePickerControllerDelegate {

    func imagePickerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: ImagePickerController, didFinishPicking result: PickerResult) {
        let images = result.assets.map { $0.image }
        self.image = images[0]
        picker.dismiss(animated: true, completion: nil)
        
        self.tableView.reloadData()
    }
}
