//
//  Zoo.swift
//  Kai Yan Zoo
//
//  Created by yusheng Lu on 2020/3/12.
//  Copyright © 2020 YushengLu. All rights reserved.
//

import Foundation

struct Zoo: Decodable {
    let result: ZooData
}

struct ZooData: Decodable {
    let results:[AllData]
}

struct AllData:Decodable {
    let A_Behavior: String?
    let A_Distribution: String?
    let A_Pic01_URL: String?
    let A_Pic02_URL: String?
    let A_Name_Ch: String?
    let A_Vedio_URL: String?
    let A_Diet: String?
    let A_Feature: String?
    let A_Habitat: String?
    let A_Interpretation: String?
    
}
