//
//  CollectionViewVC.swift
//  Kai Yan Zoo
//
//  Created by yusheng Lu on 2020/4/1.
//  Copyright © 2020 YushengLu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CollectionViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    let fullScreenSize = UIScreen.main.bounds
    
    @IBOutlet weak var btnUpStyle: UIButton!
    @IBOutlet weak var lbDiet: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnDismissBtnStyle: UIButton!
    @IBOutlet weak var viewShowBigImage: UIView!
    @IBOutlet weak var imgBigImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionData = [AllData]()
    
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
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getZooDate { (zoo) in
            self.collectionData = zoo.result.results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        viewShowBigImage.backgroundColor = UIColor.black
        viewShowBigImage.isHidden = true
        /*
        btnDismissBtnStyle.layer.borderWidth = 3
        btnDismissBtnStyle.layer.borderColor = UIColor.green.cgColor
        btnDismissBtnStyle.layer.cornerRadius = 10
        */
        viewShowBigImage.backgroundColor = UIColor.darkGray
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! CollectionCellVC
        AF.request(collectionData[indexPath.row].A_Pic02_URL!).responseImage { response in
            if case .success(let image) = response.result {
                cell.collectionImage.image = image
            }
        }
        switch collectionData[indexPath.row].A_Name_Ch {
        case "家雞":
            cell.collectionImage.image = UIImage(named: "chicken")
        case "家鴨":
            cell.collectionImage.image = UIImage(named: "duck")
        default:
            break
        }
        
        cell.collectionLabel.text = collectionData[indexPath.row].A_Name_Ch
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullScreenSize.width * 0.3 , height: fullScreenSize.width * 0.3 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AF.request(collectionData[indexPath.row].A_Pic02_URL!).responseImage { response in
            if case .success(let image) = response.result {
                self.imgBigImage.image = image
            }
        }
        switch collectionData[indexPath.row].A_Name_Ch {
        case "家雞":
            imgBigImage.image = UIImage(named: "chicken")
        case "家鴨":
            imgBigImage.image = UIImage(named: "duck")
        default:
            break
        }
        
        lbName.text = collectionData[indexPath.row].A_Name_Ch
        
        if collectionData[indexPath.row].A_Diet == "" {
            lbDiet.text = "工作人員還在努力建立資料，改天再來看看吧"
        } else {
            lbDiet.text = "\(collectionData[indexPath.row].A_Name_Ch!)的飲食習慣 : \(collectionData[indexPath.row].A_Diet!)"
        }
                
        viewShowBigImage.isHidden = false
        
    }
    
    @IBAction func btnDismissImage(_ sender: UIButton) {
        viewShowBigImage.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 在動畫效果之前先進行下列操作
        // 將透明度設為 0，再把 Cell 位移到右下角，並且長寬縮小 0.5 倍。
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX:
            cell.bounds.width, y: cell.bounds.height /
            3).concatenating(CGAffineTransform(scaleX: 0.5,
                                               y: 0.5))
        // 執行動畫效果
        // 將透明度改回 1，並取消所有的變形效果，回到原樣及位置。
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func btnUp(_ sender: UIButton) {
        //畫面回到最頂端
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
