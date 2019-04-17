//
//  SuggestionCell.swift
//  RusEdit
//
//  Created by Maxim Reshetov on 13/04/2019.
//  Copyright © 2019 Maxim Reshetov. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {
    
    let underView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.customBlue.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    let suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.customBlue
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(underView)
        addSubview(suggestionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
