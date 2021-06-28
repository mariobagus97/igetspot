//
//  MKCollectionViewController.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 17/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

class MKCollectionViewController: MKViewController {
    
    var contentView: MKCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createContentView()
        
    }
    
    private func createContentView() {
        contentView = MKCollectionView(frame: .zero)
        contentView.delegate = self
        contentView.commonInit()
        
        
        self.view.addSubview(contentView)
        setupCollectionContraints()
    }
    
    private func setupCollectionContraints() {
        contentView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }
    
    func enableScrollView(_ isEnabled: Bool) {
        contentView.collectionView.isScrollEnabled = isEnabled
    }
    
    func createRows() {
        print("createRows")
    }
    
    func createSections() {
        print("createSections")
    }
    
    func registerNibs() {
        print("registerNibs")
    }
    
}

extension MKCollectionViewController: MKCollectionViewDelegate {
    func collectionViewDidCommonInit() {
        registerNibs()
        createRows()
        createSections()
    }
    
}
