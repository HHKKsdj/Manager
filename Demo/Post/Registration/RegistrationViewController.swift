//
//  RegistrationViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "发布签到"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var byTimeButton : UIButton!
    var byGestureButton : UIButton!
    
    
    func setUI() {
        byTimeButton = UIButton.init()
        byTimeButton.setTitle("定时签到", for: .normal)
        byTimeButton.setTitleColor(.black, for: .normal)
        byTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        byTimeButton.setImage(UIImage(systemName:"star.fill"), for: .normal)
        byTimeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        byTimeButton.addTarget(self, action: #selector(byTime(sender:)), for: .touchUpInside)
        self.view.addSubview(byTimeButton)
        byTimeButton.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        byGestureButton = UIButton.init()
        byGestureButton.setTitle("手势签到", for: .normal)
        byGestureButton.setTitleColor(.black, for: .normal)
        byGestureButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        byGestureButton.setImage(UIImage(systemName:"star.fill"), for: .normal)
        byGestureButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        byGestureButton.addTarget(self, action: #selector(byGesture(sender:)), for: .touchUpInside)
        self.view.addSubview(byGestureButton)
        byGestureButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(byTimeButton.snp.bottom).offset(200)
        }
    }
    
    @objc func byTime (sender:UIButton) {
        let byTimeVC = ByTimeViewController()
        self.navigationController?.pushViewController(byTimeVC, animated: true)
    }
    
    @objc func byGesture (sender:UIButton) {
        let byGestureVC = ByGestureViewController()
        self.navigationController?.pushViewController(byGestureVC, animated: true)
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
