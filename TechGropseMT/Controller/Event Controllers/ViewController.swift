//
//  ViewController.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 15/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    //MARK: - Outlets for the UI
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var eventCategoryView: UIView!
    @IBOutlet weak var eventCategoryLabel: UILabel!

    @IBOutlet weak var sliderMainView: UIView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var mainTableView: UITableView!

    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var freePaidEventLabel: UILabel!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var socialViewsLabel: UILabel!
    @IBOutlet weak var socialLikesLabel: UILabel!
    @IBOutlet weak var socialJoinedLabel: UILabel!
    @IBOutlet weak var socialDistanceLabel: UILabel!
    @IBOutlet weak var eventMainTitleLabel: UILabel!
    @IBOutlet weak var eventSubTitleLabel: UILabel!

    //MARK: - Variables and constant
    private var innerMenuHeader: EventDetailMenu = EventDetailMenu()
    public var eventDetailData = EventDetailModel()

    private var selectedInnerHeader: HeaderType = .overview
    private var isOrganizerExpand: Bool = false

    private var isSponsorExpand: Bool = false
    private var isPerformerExpand: Bool = false
    private var isSeatingPlanExpand: Bool = false

    let expandSectionHeight: CGFloat = 120.0
    var sliderHeight: CGFloat = 190.0

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.bounces = false
        sliderCollectionView.bounces = false
        sliderPageControl.numberOfPages = 0
        eventCategoryLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        eventCategoryLabel.textAlignment = .center
        setHeaderServerData()
        fetchEventDataNetworkcall()
    }

    override func viewWillLayoutSubviews() {
        self.freePaidEventLabel.layer.cornerRadius = 5.0
        self.freePaidEventLabel.clipsToBounds = true
        self.updateFirstViewFrame()
    }

    private func updateFirstViewFrame() {
        guard let headerView = self.mainTableView.tableHeaderView else {
            return
        }
        mainTableView.tableHeaderView = headerView
        mainTableView.layoutIfNeeded()
    }

    // MARK: - Button Actions
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickShareBtn(_ sender: Any) {
        let text = "Share Data"
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func onClickOrganizerExpandBtn(_ sender: Any) {
        isOrganizerExpand = !isOrganizerExpand
        updateOverviewDetails(type: .organizer)
        self.mainTableView.reloadData()
    }

    @IBAction func onClickSponsorExpandBtn(_ sender: Any) {
        isSponsorExpand = !isSponsorExpand
        updateOverviewDetails(type: .sponsor)
        self.mainTableView.reloadData()
    }

    @IBAction func onClickPerformerExpandBtn(_ sender: Any) {
        isPerformerExpand = !isPerformerExpand
        updateOverviewDetails(type: .performer)
        self.mainTableView.reloadData()
    }

    @IBAction func onClickSeatingPlanExpandBtn(_ sender: Any) {
        isSeatingPlanExpand = !isSeatingPlanExpand
        updateOverviewDetails(type: .seatingPlan)
        self.mainTableView.reloadData()
    }

    @IBAction func onClickAddTicketBtn(_ sender: Any) {
        debugPrint("Perform Add Ticket Action")
    }
    
    @IBAction func onClickPromoteEventBtn(_ sender: Any) {
        debugPrint("Perform Promote Event Action")
    }
}

// MARK: - Extensions for View Controller

// UPdate the inner header
extension ViewController : DetailHeaderDelegate {
    func onChangeHeader(type: HeaderType) {
        self.selectedInnerHeader = type
        self.mainTableView.reloadData()
    }
}

// Update the Overview on expand click
extension ViewController {
    private func updateOverviewDetails(type: ExpandableSection) {
        var contentOffset = self.mainTableView.contentSize

        switch type {
        case .organizer:
            contentOffset.height = (contentOffset.height + (!isOrganizerExpand ? 120 : -120))
            break
        case .sponsor:
            contentOffset.height = (contentOffset.height + (!isSponsorExpand ? 120 : -120))
            break
        case .performer:
            contentOffset.height = (contentOffset.height + (!isPerformerExpand ? 120 : -120))
            break
        case .seatingPlan:
            contentOffset.height = (contentOffset.height + (!isSeatingPlanExpand ? 120 : -120))
            break
        }
        self.mainTableView.contentSize = contentOffset

        let indexPath = IndexPath.init(row: 0, section: 0)
        if self.selectedInnerHeader == .overview {
            let cell: EventDetailOverviewTableViewCell = self.mainTableView.cellForRow(at: indexPath) as! EventDetailOverviewTableViewCell
            self.setOverviewServerData(on: cell)
        }
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout delegate and data source
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.sliderCollectionView {
            return self.eventDetailData.image.count
        } else if collectionView.tag == 1 {
            return self.eventDetailData.organisers.count
        } else if collectionView.tag == 2 {
            return self.eventDetailData.sponsors.count
        } else if collectionView.tag == 3 {
            return self.eventDetailData.performers.count
        } else if collectionView.tag == 4 {
            return self.eventDetailData.seatingPlanImages.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.organizerCollectionViewCell, for: indexPath) as! EventDetailOverviewCollectionViewCell
            cell.cardView.setBorder(color: UIColor.lightGray, width: 1.0, radius: 3.0)
            cell.nameLabel.text = eventDetailData.organisers[indexPath.row].name
            if let imageUrlStr = eventDetailData.organisers[indexPath.row].image {
                cell.profileImageView.imageFromServerURL(imageUrlStr, placeHolder: nil)
            }
            cell.profileImageView.setCircleCorner()
            return cell
        } else if collectionView.tag == 2 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sponsersCollectionViewCell, for: indexPath) as! EventDetailOverviewCollectionViewCell
            cell.cardView.setBorder(color: UIColor.lightGray, width: 1.0, radius: 3.0)
            cell.nameLabel.text = eventDetailData.sponsors[indexPath.row].name
            if let imageUrlStr = eventDetailData.sponsors[indexPath.row].image {
                cell.profileImageView.imageFromServerURL(imageUrlStr, placeHolder: nil)
            }
            cell.profileImageView.setCircleCorner()
            return cell
        } else if collectionView.tag == 3 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.performersCollectionViewCell, for: indexPath) as! EventDetailOverviewCollectionViewCell
            cell.cardView.setBorder(color: UIColor.lightGray, width: 1.0, radius: 3.0)
            cell.nameLabel.text = eventDetailData.performers[indexPath.row].name
            if let imageUrlStr = eventDetailData.performers[indexPath.row].image {
                cell.profileImageView.imageFromServerURL(imageUrlStr, placeHolder: nil)
            }
            cell.profileImageView.setCircleCorner()
            return cell
        } else if collectionView.tag == 4 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.seatingCollectionViewCell, for: indexPath) as! EventDetailSliderCollectionViewCell
            cell.mainImageView.setBorder(color: UIColor.lightGray, width: 1.0, radius: 3.0)
            if let imageUrl = eventDetailData.seatingPlanImages[indexPath.row].imageUrl {
                cell.mainImageView.imageFromServerURL(imageUrl, placeHolder: nil)
            }
            return cell
        } else {
            let cell =  self.sliderCollectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.eventDetailSliderCollectionViewCell, for: indexPath) as! EventDetailSliderCollectionViewCell
            if let url = URL(string: self.eventDetailData.image[indexPath.row].imageUrl!){
                cell.mainImageView.kf.setImage(with: url)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Collection cell Clicked.")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.sliderCollectionView {
            return CGSize(width: sliderCollectionView.frame.size.width, height: sliderHeight)
        } else if collectionView.tag == 1 {
            return CGSize(width: 90.0, height: 100.0)
        } else if collectionView.tag == 2{
            return CGSize(width: 90.0, height: 100.0)
        } else if collectionView.tag == 3 {
            return CGSize(width: 90.0, height: 100.0)
        } else if collectionView.tag == 4 {
            return CGSize(width: 90.0, height: 100.0)
        }
        return CGSize.zero
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.sliderCollectionView {
            let index = Int(scrollView.contentOffset.x / 320.0)
            sliderPageControl.currentPage = index
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titleYposHeight = self.eventMainTitleLabel.frame.height + self.eventMainTitleLabel.frame.origin.y
        if self.mainTableView.contentOffset.y > titleYposHeight {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerLabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerLabel.alpha = 0.0
            })
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.selectedInnerHeader {
        case .overview:
            let cell =  mainTableView.dequeueReusableCell(withIdentifier: Identifiers.eventDetailOverviewTableViewCell, for: indexPath) as! EventDetailOverviewTableViewCell
            setOverviewServerData(on: cell)
            return cell
        default: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.selectedInnerHeader {
        case .overview:
            return getOverviewHeight()
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.selectedInnerHeader {
        case .overview:
            return 300
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: self.mainTableView.bounds.width, height: 50.0)
        innerMenuHeader = EventDetailMenu.loadViewFromNib(nibNamed: Identifiers.eventDetailMenu, frame: frame) as! EventDetailMenu
        innerMenuHeader.delegate = self
        innerMenuHeader.selectedInnerHeader = self.selectedInnerHeader
        innerMenuHeader.updateHeader(by: self.selectedInnerHeader)
        return innerMenuHeader
    }

    // Update overview height
    private func getOverviewHeight() -> CGFloat {
        var height: CGFloat = 0.0

        if self.eventDetailData.organisers.count == 0 {
            height += 0
        } else {
            height += 10
            if !isOrganizerExpand {
                height += 180.0
            } else {
                height += 60.0
            }
        }

        if self.eventDetailData.sponsors.count == 0 {
            height += 0
        } else {
            height += 10
            if !isSponsorExpand {
                height += 180.0
            } else {
                height += 60.0
            }
        }

        if self.eventDetailData.performers.count == 0 {
            height += 0
        } else {
            height += 10
            if !isPerformerExpand {
                height += 180.0
            } else {
                height += 60.0
            }
        }

        if self.eventDetailData.seatingPlanImages.count == 0 {
            height += 0
        } else {
            height += 10
            if !isSeatingPlanExpand {
                height += 180.0
            } else {
                height += 60.0
            }
        }

        height += 250.0
        height += 375
        height += 120
        height += getLabelHeight()

        return height + 00.0
    }
    private func getLabelHeight() -> CGFloat {
        let font = eventMainTitleLabel.font
        let height = heightForView(text:self.eventDetailData.evenrDescription ?? "", font: font!, width: (UIScreen.main.bounds.width - 100.0))
        return height
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    private func setOverviewServerData(on cell: EventDetailOverviewTableViewCell) {

        let startDate = eventDetailData.eventStartDate ?? ""
        let endDate = eventDetailData.eventEndDate ?? ""
        let startTime = eventDetailData.eventStartTime ?? ""
        let endTime = eventDetailData.eventEndTime ?? ""

        cell.eventDateLabel.text = "\(startDate) - \(endDate)"
        cell.eventTimeLabel.text = "\(startTime) - \(endTime)"
        cell.eventLanguageLabel.text = eventDetailData.eventLanguage
        cell.eventGenderLabel.text = eventDetailData.eventGender
        cell.eventAgeLabel.text = eventDetailData.eventAge
        self.eventCategoryLabel.text = eventDetailData.categoryName
        self.eventCategoryView.backgroundColor = eventDetailData.eventTypeColor


        if self.eventDetailData.organisers.count == 0 {
            cell.eventOrganizerViewHeightConstraints.constant = 0.0
            cell.eventOrganizerViewTopConstraints.constant = 0.0
            cell.eventOrganizerView.isHidden = true
        } else {
            cell.eventOrganizerViewTopConstraints.constant = 10.0
            cell.eventOrganizerView.isHidden = false
            if !isOrganizerExpand {
                cell.eventOrganizerViewHeightConstraints.constant = 180.0
                cell.eventOrganizerListViewHeightConstraints.constant = expandSectionHeight
                cell.eventOrganizerExpandLabel.text = "-"
            } else {
                cell.eventOrganizerViewHeightConstraints.constant = 60.0
                cell.eventOrganizerListViewHeightConstraints.constant = 0.0
                cell.eventOrganizerExpandLabel.text = "+"
            }
        }
        if self.eventDetailData.sponsors.count == 0 {
            cell.eventSponsorViewHeightConstraints.constant = 0.0
            cell.eventSponsorViewTopConstraints.constant = 0.0
            cell.eventSponsorsView.isHidden = true
        } else {
            cell.eventSponsorViewTopConstraints.constant = 10.0
            cell.eventSponsorsView.isHidden = false
            if !isSponsorExpand {
                cell.eventSponsorViewHeightConstraints.constant = 180.0
                cell.eventSponsorsListViewHeightConstraints.constant = expandSectionHeight
                cell.eventSponsorsExpandLabel.text = "-"
            } else {
                cell.eventSponsorViewHeightConstraints.constant = 60.0
                cell.eventSponsorsListViewHeightConstraints.constant = 0.0
                cell.eventSponsorsExpandLabel.text = "+"
            }
        }
        if self.eventDetailData.performers.count == 0 {
            cell.eventPerformerViewHeightConstraints.constant = 0.0
            cell.eventPerformerViewTopConstraints.constant = 0.0
            cell.eventPerformersView.isHidden = true
        } else {
            cell.eventPerformerViewTopConstraints.constant = 10.0
            cell.eventPerformersView.isHidden = false
            if !isPerformerExpand {
                cell.eventPerformerViewHeightConstraints.constant = 180.0
                cell.eventPerformersListViewHeightConstraints.constant = expandSectionHeight
                cell.eventPerformersExpandLabel.text = "-"
            } else {
                cell.eventPerformerViewHeightConstraints.constant = 60.0
                cell.eventPerformersListViewHeightConstraints.constant = 0.0
                cell.eventPerformersExpandLabel.text = "+"
            }
        }
        if self.eventDetailData.seatingPlanImages.count == 0 {
            cell.eventSeatingPlanViewHeightConstraints.constant = 0.0
            cell.eventSeatingPlanViewTopConstraints.constant = 0.0
            cell.eventSeatingPlanView.isHidden = true
        } else {
            cell.eventSeatingPlanViewTopConstraints.constant = 10.0
            cell.eventSeatingPlanView.isHidden = false
            if !isSeatingPlanExpand {
                cell.eventSeatingPlanViewHeightConstraints.constant = 180.0
                cell.eventSeatingPlanListViewHeightConstraints.constant = expandSectionHeight
                cell.eventSeatingPlanExpandLabel.text = "-"
            } else {
                cell.eventSeatingPlanViewHeightConstraints.constant = 60.0
                cell.eventSeatingPlanListViewHeightConstraints.constant = 0.0
                cell.eventSeatingPlanExpandLabel.text = "+"
            }
        }
        cell.organizerCollectionView.reloadData()
        cell.sponsorCollectionView.reloadData()
        cell.performerCollectionView.reloadData()
        cell.seatingPlanCollectionView.reloadData()

        cell.briefDescriptionLabel.text = eventDetailData.evenrDescription
        cell.contactInfoVenueNameLabel.text = eventDetailData.venueName
        cell.contactInfoVenueLocationLabel.text = eventDetailData.venueLocation
        cell.contactInfoGeoLocationLabel.text = eventDetailData.venueGeoLocation

        let latitude = Double(eventDetailData.latitude ?? "")
        let longitude = Double(eventDetailData.longitude ?? "")

        if latitude != nil {
            let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
            cell.contactInfoMapView.setCenter(coordinate, animated: true)
            let point = MKPointAnnotation()
            point.title = self.eventDetailData.eventName ?? ""
            point.coordinate = coordinate
            if cell.contactInfoMapView.annotations.count == 0 {
                cell.contactInfoMapView.addAnnotation(point)
                cell.contactInfoMapView.delegate = self
            }
        }
    }

    // MARK: - MAP Preview
    func openMapForPlace() {
        let latitude: CLLocationDegrees = Double(self.eventDetailData.latitude ?? "0.0")!
        let longitude: CLLocationDegrees = Double(self.eventDetailData.longitude ?? "0.0")!

        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=30&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
        } else {
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.eventDetailData.eventName
            mapItem.openInMaps(launchOptions: options)
        }
    }
}
extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        openMapForPlace()
    }
}

// MARK: Update Header Data for Header details and reload cell
extension ViewController {
    private func setHeaderServerData() {
        let likeStr = eventDetailData.eventLike
        let peopleStr = eventDetailData.eventReminder
        let viewStr = eventDetailData.eventView
        let distanceStr = eventDetailData.eventDistance

        self.eventMainTitleLabel.text = eventDetailData.eventName
        self.eventSubTitleLabel.text = eventDetailData.eventTitle
        self.headerLabel.text = eventDetailData.eventName
        self.freePaidEventLabel.text = (eventDetailData.isPaid == 0) ?  "  Free Event  " : "  Paid Event  "

        self.socialLikesLabel.text = likeStr
        self.socialJoinedLabel.text = peopleStr

        self.socialDistanceLabel.text = "\(distanceStr ?? "") km"
        self.socialViewsLabel.text = viewStr
        self.sliderPageControl.numberOfPages = eventDetailData.image.count
        self.sliderCollectionView.reloadData()
        self.mainTableView.reloadData()
    }

    fileprivate func setModelData() {
        self.setHeaderServerData()
        self.view.layoutIfNeeded()
    }
}

// MARK: -  Extension for the network calls
extension ViewController {
    fileprivate func fetchEventDataNetworkcall() {
        let requestedURL = "http://saudicalendar.com/api/user/getEventDetail"
        let paramDIC: [String: Any] = ["user_id": 00, "event_id": 12, "latitude": 28.1245, "longitude": 78.1245]
        ActivityIndicator.shared.showProgressView(view)
        AF.request(requestedURL, method: .post, parameters: paramDIC, encoding: URLEncoding.default, headers: [:]).responseData { response in
            ActivityIndicator.shared.hideProgressView()
            switch response.result {
            case .success(_):
                let jsonResponse = try! JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                print(jsonResponse)
                let responseCode =  jsonResponse["error_code"] as! Int
                switch responseCode {
                case 100:
                    let data = jsonResponse["data"] as? [String:Any]
                    self.eventDetailData =  EventDetailModelClass.convertObjectWithData(object: data!)
                    self.eventDetailData.eventId = "\(12)"
                    self.setModelData()
                    break
                case 102:
                    break
                default:
                    print("Error fetching data")
                }
            case .failure(let error):
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
}
