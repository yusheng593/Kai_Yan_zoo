//
//  ViewController.swift
//  Kai Yan Zoo
//
//  Created by yusheng Lu on 2020/3/10.
//  Copyright © 2020 YushengLu. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    @IBOutlet weak var btnUpStyle: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [AllData]()
    
    func getZooDate(completeion: @escaping (Zoo) -> Void) {
        let address = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url){(data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let allData = try? decoder.decode(Zoo.self, from: data) {
                        print("zoo data is ready")
                        print(allData.result.results.count)
                        completeion(allData)
                    }else {
                        print("zoo data is not ready")
                    }
                }
            }.resume()
        } else {
            print("Invalid URL")
        }
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getZooDate { (zoo) in
            self.tableData = zoo.result.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 陰影偏移量
        btnUpStyle.layer.shadowOffset = CGSize(width: btnUpStyle.bounds.width / 10, height: btnUpStyle.bounds.width / 10)
        // 陰影透明度
        btnUpStyle.layer.shadowOpacity = 0.75
        // 陰影模糊度
        btnUpStyle.layer.shadowRadius = 5
        // 陰影顏色
        btnUpStyle.layer.shadowColor = UIColor.black.cgColor
        btnUpStyle.layer.cornerRadius = btnUpStyle.bounds.width / 2
        btnUpStyle.isHidden = true
        
    }
    @IBAction func btnUp(_ sender: UIButton) {
        //畫面回到最頂端
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    //  顯示按鈕
    func showFloatingButton() {
        UIView.animate(withDuration: 0.4) {
            self.btnUpStyle.transform = .identity
            self.btnUpStyle.alpha = 1
        }
    }
    // 隱藏按鈕
    func hideFloatingButton() {
        UIView.animate(withDuration: 0.4) {
            self.btnUpStyle.transform = CGAffineTransform(translationX: 0 , y: 50)
            self.btnUpStyle.alpha = 0
        }
    }
    // 當我們的 contentOffset.y 超過我們一個 collectionView 的高度就顯示懸浮按鈕，反之則隱藏。
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.bounds.height {
            btnUpStyle.isHidden = false
            showFloatingButton()
            
        } else {
            hideFloatingButton()
        }
    }
    
    //MARK: - 通知事件
    func sendNotificatin() {
        let content = UNMutableNotificationContent()
        content.title = "老公快下班了👨🏻‍💻"
        //content.subtitle = "subtitle:來自 Sam 的推播"
        content.body = "要買什麼東西吃要趕快告訴老公🛵"
        //紅點數字
        content.badge = 1
        //紅點數字累加
        /*
        content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
        */
        content.sound = UNNotificationSound.default
        
        // 設置通知的圖片
        let imageURL:URL = Bundle.main.url(forResource: "family", withExtension: "jpg")!
        let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
        content.attachments = [attachment]
        // 設置點擊通知後取得的資訊
        content.userInfo = ["link" : "https://www.google.com/search?q=%E5%8F%B0%E4%B8%AD+%E7%BE%8E%E9%A3%9F&rlz=1C5CHFA_enTW873TW874&oq=%E5%8F%B0%E4%B8%AD+%E7%BE%8E%E9%A3%9F&aqs=chrome..69i57j0l7.9972j0j4&sourceid=chrome&ie=UTF-8"]
        //依時間
        /*
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)*/
        //定時
        
        var date = DateComponents()
        date.hour = 17
        date.minute = 50
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print("成功建立推播")
        }
        
    }
    
}

//MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCellVC
        cell.lbAnimalName?.text = tableData[indexPath.row].A_Name_Ch
        AF.request(tableData[indexPath.row].A_Pic01_URL!).responseImage { response in
            if case .success(let image) = response.result {
                cell.imgAnimal.image = image
            }
        }
        
        switch tableData[indexPath.row].A_Name_Ch {
        case "家雞":
            cell.imgAnimal.image = UIImage(named: "chicken")
        case "家鴨":
            cell.imgAnimal.image = UIImage(named: "duck")
        default:
            break
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

//MARK: - Safari

extension ViewController: SFSafariViewControllerDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var safariVC = SFSafariViewController(url: URL(string: tableData[indexPath.row].A_Vedio_URL!)!)
        switch tableData[indexPath.row].A_Name_Ch {
        case "家雞":
            safariVC = SFSafariViewController(url: URL(string:"https://www.youtube.com/results?search_query=%E5%8B%95%E7%89%A9%E5%9C%92%E5%85%AC%E9%9B%9E")!)
        case "家鴨":
            safariVC = SFSafariViewController(url: URL(string: tableData[indexPath.row].A_Vedio_URL!)!)
        default:
            break
        }
        safariVC.delegate = self
        self.present(safariVC, animated: true)
    }
    
}
