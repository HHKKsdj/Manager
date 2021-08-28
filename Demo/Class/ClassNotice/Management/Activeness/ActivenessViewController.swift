//
//  ActivenessViewController.swift
//  Demo
//
//  Created by HK on 2021/8/4.
//

import UIKit

class ActivenessViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "成员活跃度"
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        if user.role != "student" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "导出", style: .plain, target: self, action: #selector(download(sender:)))
        }
        setData()
        setUI()
    }
    
    var user = UserInfo()
    var classID = ""
    
    var nameList = [UserInfo]()
//    var nameList = ["test","test","test","test","test","test"]
//    var scoreList = [95,73,64,61,55,42]
    
    func setUI() {
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
        self.tableView.register(NameListCell.self, forCellReuseIdentifier: "NameListCell")
    }
    
    @objc func download(sender:UIBarButtonItem) {
        export()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameListCell", for: indexPath) as! NameListCell
        cell.headImageView.image = UIImage(named: "test")
        cell.nameLabel.text = nameList[indexPath.row].username + nameList[indexPath.row].realName
        cell.scoreLabel.text = "\(nameList[indexPath.row].point)"
        if nameList[indexPath.row].point < 60 {
            cell.scoreLabel.textColor = UIColor.systemRed
        } else if nameList[indexPath.row].point >= 70 {
            cell.scoreLabel.textColor = UIColor.systemPurple
        } else {
            cell.scoreLabel.textColor = UIColor.systemBlue
        }
//        cell.managerLabel.isHidden = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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

extension ActivenessViewController {
    func setData() {
        ClassNetwork.shared.GetStudentRequest(classID: classID) {(error,info) in
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
                self.tableView.reloadData()
            }
        }
    }
    func export() {
        ClassNetwork.shared.ExportRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "导出成功", message: "可在班级文件中查看", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1.5)
            } else {
                let alter = UIAlertController(title: "导出失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
}
