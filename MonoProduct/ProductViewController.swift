//
//  ProductViewController.swift
//  MonoProduct
//
//  Created by IT Kratos on 16/3/2564 BE.
//

import UIKit
import Foundation
import MapleBacon

class ProductViewController: UIViewController {
    
    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbDescriptionTitle: UILabel!
    @IBOutlet weak var lbNameProduct: UILabel!
    var TotalPrice = 0
    var priceUnit = 0
    private let scrollView = UIScrollView()
    private let lbCount = UILabel()
    private var amount = 0
    private var numberOfPages = 0
    private var urlProduct = [String]()
    
    private let pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = .clear
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let localData = self.readLocalFile(forName: "data") {
            self.parse(jsonData: localData)
            
        }
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageDidChange(_:)), for: .valueChanged)
        btnMinus.addTarget(self, action: #selector(minusDidChange(_:)), for: .touchUpInside)
        btnPlus.addTarget(self, action: #selector(plusDidChange(_:)), for: .touchUpInside)
        
        viewScroll.addSubview(scrollView)
        viewScroll.addSubview(pageControl)
        viewScroll.addSubview(lbCount)
        lbCount.text = "\(pageControl.currentPage+1)/\(pageControl.numberOfPages)"
        
       
    }
    
    @objc private func minusDidChange(_ sender : UIPageControl) {
        if amount <= 1 {
            lbAmount.text = "1"
            lbPrice.text = "Payment total : \(priceUnit) THB"

        }else{
            amount-=1
            TotalPrice-=priceUnit
            lbAmount.text = String(amount)
            lbPrice.text = "Payment total : \(TotalPrice) THB"

        }
    }
    
    @objc private func plusDidChange(_ sender : UIButton) {
        amount+=1
        lbAmount.text = String(amount)
        TotalPrice+=priceUnit
        lbPrice.text = "Payment total : \(TotalPrice) THB"

    }
    
    @objc private func pageDidChange(_ sender : UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    override func viewDidLayoutSubviews() {
        btnOrder.layer.cornerRadius = 10
        scrollView.frame = CGRect(x: 0, y: 0, width:  view.frame.size.width, height:  view.frame.size.height / 2 - 100)
        lbNameProduct.frame = CGRect(x: 5, y:  scrollView.frame.height + 8, width:  view.frame.size.width, height:  21)
        lbDescriptionTitle.frame = CGRect(x: 5, y:  lbNameProduct.frame.maxY + 7, width:  view.frame.size.width, height:  21)
        lbDescription.frame = CGRect(x: 5, y:  lbDescriptionTitle.frame.maxY + 5 , width:  view.frame.size.width, height:  21)
        scrollView.frame = CGRect(x: 0, y: 0, width:  view.frame.size.width, height:  view.frame.size.height / 2 - 100)
        pageControl.frame = CGRect(x: 0, y: scrollView.frame.height - 50, width:  viewScroll.frame.size.width , height: 50)
        lbCount.frame = CGRect(x: view.frame.size.width - 40, y: 7, width: 35, height: 20)
        
        if scrollView.subviews.count == 2 {
            configScrollView()
        }
    }
    
    private func configScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width*CGFloat(urlProduct.count), height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<urlProduct.count {
            let page = UIImageView(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width , height: scrollView.frame.size.height))
            if let url = URL(string: urlProduct[i]) {
                
                page.setImage(with : url)
                
            }
            
            scrollView.addSubview(page)
        }
    }
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(DemoData.self, from: jsonData)
            pageControl.numberOfPages = decodedData.url.count
            urlProduct = decodedData.url
            lbNameProduct.text = "\(decodedData.name_product) : \(decodedData.price) THB"
            lbDescription.text = decodedData.description
            lbPrice.text = "Payment total : \(decodedData.price ) THB"
            priceUnit = decodedData.price
        } catch {
            print("decode error")
        }
    }
    

}
extension ProductViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        lbCount.text = "\(Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))) + 1)/\(urlProduct.count)"
    }
}
