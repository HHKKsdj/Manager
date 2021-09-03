//
//  MineViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit

class MineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "我的"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        setUI()
    }
    
    var user = UserInfo()
    
    var tableView : UITableView!
    var labelList = ["认证","修改密码","帮助中心","关于"]
    var VCList = [InformationViewController(),IdentifyViewController(),ResetPasswordViewController(),HelpViewController(),AboutViewController()]
    
    func setUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.sectionHeaderHeight = 0
        
        tableView.register(MineHeaderCell.self, forCellReuseIdentifier: "MineHeaderCell")
        tableView.register(SectionCell.self, forCellReuseIdentifier: "SectionCell")
        tableView.register(LogoutCell.self, forCellReuseIdentifier: "LogoutCell")
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

extension MineViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineHeaderCell", for: indexPath) as! MineHeaderCell
            cell.HeadImageView.image = UIImage(named: "test")
            cell.nameLabel.text = user.username + user.realName
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as! LogoutCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
            if indexPath.row == 0 {
                cell.titleLabel.text = labelList[indexPath.section - 1]
            } else {
                cell.titleLabel.text = labelList[indexPath.section]
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
        if indexPath.section == 4 {
            logout()
        } else {
            var VC : UIViewController!
            if indexPath.row == 0 {
                VC = VCList[indexPath.section]
            } else {
                VC = VCList.last
            }
            let naviVC = UINavigationController(rootViewController: VC)
            naviVC.modalPresentationStyle = .fullScreen
            naviVC.modalTransitionStyle = .crossDissolve
            self.present(naviVC, animated: true, completion: nil)
        }
    }
}

extension MineViewController {
    func logout() {
        let alter = UIAlertController(title: "是否退出登录？", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .default, handler: nil)
        let action2 = UIAlertAction(title: "确定", style: .destructive, handler: {_ in
            self.out()
        })
        alter.addAction(action1)
        alter.addAction(action2)
        self.present(alter, animated: true, completion: nil)
    }
    func out() {
        UserNetwork.shared.LogoutRequest { (error,info) in
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
                title = "退出成功"
                self.view.window?.rootViewController = LoginViewController()
                self.dismiss(animated: true, completion: nil)
            } else {
                title = "退出失败"
                let alter = UIAlertController(title: title, message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
}
