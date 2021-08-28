//
//  ManagementViewController.swift
//  Demo
//
//  Created by HK on 2021/8/3.
//

import UIKit

class ManagementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "班级管理"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IfAutoAccept()
    }
    var user = UserInfo()
    var classID = ""
    var autoAccept = false
    
    var tableView : UITableView!
    
    func setUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.sectionHeaderHeight = 0
        
        tableView.register(InformationCell.self, forCellReuseIdentifier: "InformationCell")
        tableView.register(SectionCell.self, forCellReuseIdentifier: "SectionCell")
        tableView.register(DeleteCell.self, forCellReuseIdentifier: "DeleteCell")
        tableView.register(QuitCell.self, forCellReuseIdentifier: "QuitCell")
        tableView.register(CheckCell.self, forCellReuseIdentifier: "CheckCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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

extension ManagementViewController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if user.role == "student" {
                return 4
            } else {
                return 5
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as! InformationCell
                cell.titleLabel.text = "班级码"
                cell.contentLabel.text = classID
                cell.selectionStyle = .none
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
                cell.titleLabel.text = "无需审核"
                cell.classID = classID
                cell.checkSwitch.isOn = autoAccept
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
                if indexPath.row == 1 {
                    cell.titleLabel.text = "班级文件"
                } else if indexPath.row == 2 {
                    cell.titleLabel.text = "班级成员"
                } else {
                    cell.titleLabel.text = "成员活跃度"
                }
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath) as! DeleteCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuitCell", for: indexPath) as! QuitCell
            if user.role == "student" {
                cell.quitLabel.text = "退出班级"
            } else {
                cell.quitLabel.text = "退出并解散"
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row != 0 && indexPath.row != 4 {
            
//            var VC : UIViewController!
            if indexPath.row == 1 {
                let VC = FileViewController()
                VC.classID = classID
                self.navigationController?.pushViewController(VC, animated: true)
            } else if indexPath.row == 2 {
                let VC = NameListViewController()
                VC.classID = classID
                self.navigationController?.pushViewController(VC, animated: true)
            } else if indexPath.row == 3 {
                let VC = ActivenessViewController()
                VC.classID = classID
                self.navigationController?.pushViewController(VC, animated: true)
            }
//            self.navigationController?.pushViewController(VC, animated: true)
            
        } else if indexPath.section == 1 {
            print("delete")
        } else if indexPath.section == 2 {
            print("quit")
        }
    }
}

extension ManagementViewController : errorDelegate {
    func error() {
        let alter = UIAlertController(title: "修改失败", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alter.addAction(action)
        self.present(alter, animated: true, completion: nil)
    }
}

extension ManagementViewController {
    func IfAutoAccept() {
        ClassNetwork.shared.IfAutoAcceptRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                if content.msg == "true" {
                    self.autoAccept = true
                } else {
                    self.autoAccept = false
                }
                self.tableView.reloadData()
            }
        }
    }
}
