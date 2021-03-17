//
//  Product.swift
//  MonoProduct
//
//  Created by IT Kratos on 16/3/2564 BE.
//

import Foundation

struct DemoData: Codable {
    let name_product: String
    let description: String
    let price: Int
    let url:[String]
}

enum NotificationCenterName:String{
    case calPrice
}
