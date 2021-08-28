//
//  ClassViewController.swift
//  Demo
//
//  Created by HK on 2021/8/1.
//

import UIKit

class IdentifyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "更改认证", style: .plain, target: self, action: #selector(identify(sender:)))
        self.navigationItem.title = "类别认证"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        if user.role == "teacher" {
            role = "教师"
        } else if user.role == "student" {
            role = "学生"
        } else {
            role = user.role
        }
        setUI()
    }
    
    var user = UserInfo()
    var role : String!
    var label : UILabel!
    
    func setUI() {
        label = UILabel.init()
        
        label.text = "当前类别：" + role
        label.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
    }
    
    @objc func identify (sender:UIBarButtonItem) {
        let changeVC = ChangeViewController()
        self.navigationController?.pushViewController(changeVC, animated: true)
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
