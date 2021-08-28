//
//  ViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = UIColor.white
//        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        
        let data = UserDefaults.standard.data(forKey: "user")
        let user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        
        let noticeVC = UINavigationController(rootViewController: NoticeViewController())
        let postVC = UINavigationController(rootViewController: PostViewController())
        let classVC = UINavigationController(rootViewController: ClassViewController())
        let mineVC = UINavigationController(rootViewController: MineViewController())
        
        noticeVC.tabBarItem = UITabBarItem(title: "通知", image: UIImage(named: "Notice1"), selectedImage: UIImage(named: "Notice2"))
        postVC.tabBarItem = UITabBarItem(title: "发布", image: UIImage(named: "Post1"), selectedImage: UIImage(named: "Post2"))
        classVC.tabBarItem = UITabBarItem(title: "班级", image: UIImage(named: "Class1"), selectedImage: UIImage(named: "Class2"))
        mineVC.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "Mine1"), selectedImage: UIImage(named: "Mine2"))
        
        if user.role == "student" {
            self.viewControllers = [noticeVC,classVC,mineVC]
        } else {
            self.viewControllers = [noticeVC,postVC,classVC,mineVC]
        }
        
    }


}

