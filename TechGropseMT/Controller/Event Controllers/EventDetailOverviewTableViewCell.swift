//
//  EventDetailOverviewTableViewCell.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 15/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import UIKit
import MapKit

class EventDetailOverviewTableViewCell: UITableViewCell {

    // MARK: - Outlets for UI
    @IBOutlet weak var overviewMainView: UIView!
    @IBOutlet weak var overviewDetailCardView: UIView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLanguageLabel: UILabel!
    @IBOutlet weak var eventGenderLabel: UILabel!
    @IBOutlet weak var eventAgeLabel: UILabel!

    @IBOutlet weak var eventOrganizerView: UIView!
    @IBOutlet weak var eventOrganizerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var eventOrganizerViewTopConstraints: NSLayoutConstraint!

    @IBOutlet weak var eventOrganizerExpandLabel: UILabel!
    @IBOutlet weak var eventOrganizerListViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var eventSponsorsView: UIView!
    @IBOutlet weak var eventSponsorViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var eventSponsorViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var eventSponsorsExpandLabel: UILabel!
    @IBOutlet weak var eventSponsorsListViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var eventPerformersView: UIView!
    @IBOutlet weak var eventPerformerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var eventPerformerViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var eventPerformersExpandLabel: UILabel!
    @IBOutlet weak var eventPerformersListViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var eventSeatingPlanView: UIView!
    @IBOutlet weak var eventSeatingPlanViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var eventSeatingPlanViewTopConstraints: NSLayoutConstraint!

    @IBOutlet weak var eventSeatingPlanExpandLabel: UILabel!
    @IBOutlet weak var eventSeatingPlanListViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var addTicketButton: UIButton!
    @IBOutlet weak var promoteEventButton: UIButton!

    @IBOutlet weak var organizerCollectionView: UICollectionView!
    @IBOutlet weak var sponsorCollectionView: UICollectionView!
    @IBOutlet weak var performerCollectionView: UICollectionView!
    @IBOutlet weak var seatingPlanCollectionView: UICollectionView!

    @IBOutlet weak var venueLocationCardView: UIView!

    @IBOutlet weak var contactInfoVenueNameLabel: UILabel!
    @IBOutlet weak var contactInfoVenueLocationLabel: UILabel!
    @IBOutlet weak var contactInfoGeoLocationLabel: UILabel!
    @IBOutlet weak var contactInfoMapView: MKMapView!

    @IBOutlet weak var contactInfoVenueNameViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var contactInfoVenueLocationViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var contactInfoVenueGeoLocationViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var briefDescriptionLabel: UILabel!
    @IBOutlet weak var briefDescriptionView: UIView!

    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeTheView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Customisation methods
    func customizeTheView() {
        addTicketButton.layer.cornerRadius = 5.0
        promoteEventButton.layer.cornerRadius = 5.0
        contactInfoMapView.setBorder(color: UIColor.lightGray, width: 1.0, radius: 3.0)
        briefDescriptionView.setShadow(cornerRadius: 5.0)
        venueLocationCardView.setShadow(cornerRadius: 5.0)
        overviewDetailCardView.setShadow(cornerRadius: 5.0)
        eventOrganizerView.setShadow(cornerRadius: 5.0)
        eventSponsorsView.setShadow(cornerRadius: 5.0)
        eventPerformersView.setShadow(cornerRadius: 5.0)
        eventSeatingPlanView.setShadow(cornerRadius: 5.0)
    }

}
