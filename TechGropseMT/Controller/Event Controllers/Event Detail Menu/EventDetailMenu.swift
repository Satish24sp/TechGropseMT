//
//  EventDetailModel.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 15/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import UIKit

protocol DetailHeaderDelegate {
    func onChangeHeader(type: HeaderType)
}
class EventDetailMenu: UIView {
    // MARK: - Outlets for UIView
    @IBOutlet weak var innerHeaderView: UIView!
    @IBOutlet weak var overviewHdrBtn: UIButton!
    @IBOutlet weak var additionInfoHdrBtn: UIButton!
    @IBOutlet weak var contactHdrBtn: UIButton!
    @IBOutlet weak var commentHdrBtn: UIButton!
    @IBOutlet weak var overviewHdrBorderView: UIView!
    @IBOutlet weak var additionInfoBorderView: UIView!
    @IBOutlet weak var contactHdrBorderView: UIView!
    @IBOutlet weak var commentHdrBorderView: UIView!
    
    var delegate: DetailHeaderDelegate?
    var selectedInnerHeader: HeaderType = .overview


    // MARK: - initiate the UIView
    override init (frame : CGRect) {
        super.init(frame : frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Button Actions
    @IBAction func onClickOverviewButton(_ sender: Any) {
        self.delegate?.onChangeHeader(type: .overview)
    }
    
    private func deSelectAllInnerHeaderColor() {

        self.overviewHdrBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.additionInfoHdrBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.contactHdrBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.commentHdrBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.overviewHdrBorderView.isHidden = true
        self.additionInfoBorderView.isHidden = true
        self.contactHdrBorderView.isHidden = true
        self.commentHdrBorderView.isHidden = true
    }

    // MARK: - Update button header and state
    func updateHeader(by type: HeaderType) {
        self.deSelectAllInnerHeaderColor()
        switch type {
        case .overview:
            self.overviewHdrBtn.setTitleColor(UIColor.darkText, for: .normal)
            self.overviewHdrBorderView.isHidden = false
            break
        default: break
        }
    }
}
