//
//  ResultViewController.swift
//  SpeechImageSearch
//
//  Created by ChAe on 03/12/2018.
//  Copyright © 2018 ChAe. All rights reserved.
//

import UIKit
import SwiftyAttributes

class ResultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!              // 결과 테이블뷰
    @IBOutlet weak var indicator: UIActivityIndicatorView!  // 로딩 인디케이터
    
    var keyword: String?    // 검색 키워드
    
    private var rowViewModels: [RowViewModel] = [RowViewModel]()    // 테이블뷰 셀 표현 뷰모델 정보
    private var lastImageSearchRequestInfo: ImageSearchRequestInfo? // 마지막 이미지 요청 정보 기록
    private var isExistMore: Bool = false                           // 결과에 따른 추가 Page 존재 유무
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .done, target: self, action: #selector(backBarButtonItemAction(button:)))
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.bounds.width
        
        if let keyword = keyword, keyword.isEmpty == false {
            requestImageSearch(keyword: keyword)
            
            let sharpAttri = "#".withAttributes([
                .textColor(.darkText),
                .font(.systemFont(ofSize: 18.0, weight: .semibold))
                ])
            
            let keywordAttri = "\(keyword)".withAttributes([
                .textColor(.red),
                .font(.systemFont(ofSize: 18.0, weight: .semibold))
                ])
            let finalString = sharpAttri + keywordAttri
            
            let navLabel = UILabel()
            navLabel.attributedText = finalString
            self.navigationItem.titleView = navLabel
        }
    }
    
    @objc func backBarButtonItemAction(button: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Search Methods
    // 이미지 검색 요청
    func requestImageSearch(keyword: String, page: Int = 1) {
        let imageSearchRequestInfo = ImageSearchRequestInfo(keyword: keyword, page: page)
        let isRequst = NetworkManager.shared.requestKakaoImageSearchAPI(imageSearchRequestInfo, success: { (imageSearchInfo) in
            self.lastImageSearchRequestInfo = imageSearchRequestInfo
            self.isExistMore = !imageSearchInfo.meta.is_end
            
            self.rowViewModels.removeAll()
            print("total count: \(imageSearchInfo.meta.total_count)")
            if imageSearchInfo.meta.total_count > 0 && imageSearchInfo.documents.count > 0 {
                self.rowViewModels.append(contentsOf: imageSearchInfo.documents)
            } else {
                self.rowViewModels.append(DescriptionInfo(keyword: imageSearchRequestInfo.keyword, desc: "해당하는 이미지가 존재하지 않습니다.", height: self.tableView.bounds.height))
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.rowViewModels.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                
                self.hideIndicator()
            }
        }) { (error) in
            print(error.localizedDescription)
            
            self.rowViewModels.removeAll()
            self.rowViewModels.append(DescriptionInfo(desc: "데이터 통신에 실패하였습니다.", height: self.tableView.bounds.height))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideIndicator()
            }
        }
        
        if isRequst == true {
            showIndicator()
        }
    }
    
    // MARK: - Indicator Methods
    private func showIndicator() {
        indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func hideIndicator() {
        indicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 이미지 검색 정보가 존재하고, 추가 Page가 있고, 마지막 셀을 본다면..
        if let lastImageSearchRequestInfo = lastImageSearchRequestInfo, isExistMore == true && indexPath.row == rowViewModels.count - 1 {
            // 키워드는 같고 다음페이지를 요청
            let imageSearchRequestInfo = ImageSearchRequestInfo(keyword: lastImageSearchRequestInfo.keyword, page: lastImageSearchRequestInfo.page + 1)
            let _ = NetworkManager.shared.requestKakaoImageSearchAPI(imageSearchRequestInfo, success: { (imageSearchInfo) in
                self.lastImageSearchRequestInfo = imageSearchRequestInfo
                self.isExistMore = !imageSearchInfo.meta.is_end
                
                if imageSearchInfo.meta.total_count > 0 && imageSearchInfo.documents.count > 0 {
                    self.rowViewModels.append(contentsOf: imageSearchInfo.documents)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }) { (error) in
                // 첫 페이지 요청시 실패에 대한 안내는 테이블뷰의 설명 문구 표시로 했지만,
                // 더보기 실패시 이전 표시 이미지 결과를 설명 문구로 표시로 대체할수 없기에 별도의 처리는 하지 않음
                // 추후 개선이 필요하면 Toast나 추가 Interaction 없이 사라지는 형태로 표현
                print(error.localizedDescription)
            }
        }
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = rowViewModels[indexPath.row]
        
        let identifier: String
        switch rowViewModel {
        case is DocumentInfo:
            identifier = "imageCell"
        default:
            identifier = "descCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? CellConfig {
            cell.setup(rowViewModel: rowViewModel)
        }
        
        return cell
    }
}
