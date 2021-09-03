//
//  PostViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit
import SnapKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "发布"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var announcement : UIButton!
    var vote : UIButton!
    var draw : UIButton!
    var askQuestion : UIButton!
    var registrationByTime : UIButton!
    var registrationByGesture : UIButton!
    
    func setUI() {
        announcement = UIButton.init()
        announcement.setTitle("发布公告", for: .normal)
        announcement.setTitleColor(.black, for: .normal)
        announcement.titleLabel?.font = UIFont.systemFont(ofSize: 22.5)
        announcement.setImage(UIImage(named:"Announcement"), for: .normal)
        announcement.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        announcement.addTarget(self, action: #selector(announcement(sender:)), for: .touchUpInside)
        self.view.addSubview(announcement)
        announcement.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
        
        vote = UIButton.init()
        vote.setTitle("发布投票", for: .normal)
        vote.setTitleColor(.black, for: .normal)
        vote.titleLabel?.font = UIFont.systemFont(ofSize: 22.5)
        vote.setImage(UIImage(named:"Vote"), for: .normal)
        vote.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        vote.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        self.view.addSubview(vote)
        vote.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(announcement).offset(100)
        }
        
        askQuestion = UIButton.init()
        askQuestion.setTitle("课堂问答", for: .normal)
        askQuestion.setTitleColor(.black, for: .normal)
        askQuestion.titleLabel?.font = UIFont.systemFont(ofSize: 22.5)
        askQuestion.setImage(UIImage(named:"AskQuestion"), for: .normal)
        askQuestion.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        askQuestion.addTarget(self, action: #selector(askQuestion(sender:)), for: .touchUpInside)
        self.view.addSubview(askQuestion)
        askQuestion.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(vote).offset(100)
        }
        
        draw = UIButton.init()
        draw.setTitle("活动抽签", for: .normal)
        draw.setTitleColor(.black, for: .normal)
        draw.titleLabel?.font = UIFont.systemFont(ofSize: 22.5)
        draw.setImage(UIImage(named:"Draw"), for: .normal)
        draw.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        draw.addTarget(self, action: #selector(draw(sender:)), for: .touchUpInside)
        self.view.addSubview(draw)
        draw.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(askQuestion).offset(100)
        }
        
        registrationByTime = UIButton.init()
        registrationByTime.setTitle("定时签到", for: .normal)
        registrationByTime.setTitleColor(.black, for: .normal)
        registrationByTime.titleLabel?.font = UIFont.systemFont(ofSize: 22.5)
        registrationByTime.setImage(UIImage(named:"ByTime"), for: .normal)
        registrationByTime.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        registrationByTime.addTarget(self, action: #selector(registrationByTime(sender:)), for: .touchUpInside)
        self.view.addSubview(registrationByTime)
        registrationByTime.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(draw).offset(100)
        }
        
        registrationByGesture = UIButton.init()
        registrationByGesture.setTitle("手势签到", for: .normal)
        registrationByGesture.setTitleColor(.black, for: .normal)
        registrationByGesture.titleLabel?.font = UIFont.systemFont(ofSize: 22.5)
        registrationByGesture.setImage(UIImage(named:"ByGesture"), for: .normal)
        registrationByGesture.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        registrationByGesture.addTarget(self, action: #selector(registrationByGesture(sender:)), for: .touchUpInside)
        self.view.addSubview(registrationByGesture)
        registrationByGesture.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(registrationByTime).offset(100)
        }
    }
    
    @objc func announcement (sender:UIButton) {
        let announcementVC = AnnouncementViewController()
        let naviVC = UINavigationController(rootViewController: announcementVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    @objc func vote (sender:UIButton) {
        let voteVC = VoteViewController()
        let naviVC = UINavigationController(rootViewController: voteVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    @objc func askQuestion (sender:UIButton) {
        let askQuestionVC = AskQuestionViewController()
        let naviVC = UINavigationController(rootViewController: askQuestionVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    @objc func draw (sender:UIButton) {
        let drawVC = DrawViewController()
        let naviVC = UINavigationController(rootViewController: drawVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    @objc func registrationByTime (sender:UIButton) {
        let byTimeVC = ByTimeViewController()
        let naviVC = UINavigationController(rootViewController: byTimeVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
    }
    @objc func registrationByGesture (sender:UIButton) {
        let byGestureVC = ByGestureViewController()
        let naviVC = UINavigationController(rootViewController: byGestureVC)
        naviVC.modalPresentationStyle = .fullScreen
        naviVC.modalTransitionStyle = .crossDissolve
        self.present(naviVC, animated: true, completion: nil)
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
