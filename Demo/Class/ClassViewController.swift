//
//  ClassViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit

class ClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "加入班级", style: .plain, target: self, action: #selector(join(sender:)))
        self.navigationItem.title = "班级"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        if user.role != "student" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "创建班级", style: .plain, target: self, action: #selector(creat(sender:)))
        }
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    var user = UserInfo()
    
    var tableView : UITableView!
//    var classList = ["周四一二节","周五七八节","周一三四节"]
    var classList = [ClassInfo]()
    
    func setUI() {
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.register(SectionCell.self, forCellReuseIdentifier: "SectionCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func creat (sender:UIBarButtonItem) {
        let CreatClassVC = CreatClassViewController()
        let naviVC = UINavigationController(rootViewController: CreatClassVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    
    @objc func join (sender:UIBarButtonItem) {
        let joinClassVC = JoinClassViewController()
        let naviVC = UINavigationController(rootViewController: joinClassVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
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

extension ClassViewController : UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
        cell.titleLabel.text = classList[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classNoticeVC = ClassNoticeViewController()
        classNoticeVC.className = classList[indexPath.row].name
        classNoticeVC.classID = classList[indexPath.row].classId
        let naviVC = UINavigationController(rootViewController: classNoticeVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
}

extension ClassViewController {
    func setData() {
        if self.user.role == "student" {
            ClassNetwork.shared.MyClassRequest {(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.classList = content.classList
                    self.tableView.reloadData()
                }
            }
        } else if self.user.role == "teacher" {
            ClassNetwork.shared.MyCreatedClassRequest{(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.classList = content.classList
                    self.tableView.reloadData()
                }
            }
        }
    }
}
