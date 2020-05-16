//
//  EventModel.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 15/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import Foundation
import UIKit

class EventDetailModel{

    var isPaid :Int = 0
    var image = [imageModel]()

    var eventView : String?
    var eventLike : String?
    var eventReminder : String?
    var eventDistance : String?

    var eventId :  String?
    var eventUserId :  String?
    var eventName :  String?
    var eventTitle : String?

    var eventStartDate : String?
    var eventRemainingDays : Int = 0
    var eventEndDate : String?
    var eventStartTime : String?
    var eventEndTime : String?
    var eventLanguage : String?
    var eventGender : String?
    var eventAge : String?

    var eventTag = [EventTagModel]()
    var organisers = [EventOverviewDetailsModel]()
    var sponsors = [EventOverviewDetailsModel]()
    var performers = [EventOverviewDetailsModel]()
    var seatingPlanImages = [imageModel]()

    var importantNote: String?
    var evenrDescription : String?
    var detailDescription: String?

    var email: String?
    var phoneNo: String?
    var whatsappNo: String?
    var website: String?
    var venueName: String?
    var venueLocation: String?
    var venueGeoLocation: String?

    var eventCategoryId : String?
    var categoryName : String?
    var eventTypeColor: UIColor?
    var eventCity : String?
    var eventCountry :  String?
    var latitude : String?
    var longitude : String?



}

struct imageModel {

    var imageUrl : String?

}

struct EventTagModel {

    var eventtagID: String?
    var eventTagName_EN : String?
    var eventtagName_Ar : String?
    var eventCategoryStatus : String?
    var eventCategorycreatedAdded : String?
    var isSelected : Bool = false
    var tagColor: String = "#EC5C4D"
    var images: [PostImageModel] = []

}


struct EventOverviewDetailsModel {

    var id : String?
    var image: String?
    var name: String?
    var nameAr: String?
    var detail: String?
    var contact: String?
    var typeName: String?
    var status: String?
    var isFavorite : Bool = false
    var isSelected : Bool = false
    var images: [PostImageModel] = []

}

struct PostImageModel {
    let id : String?
    let url : String?
    var image : UIImage?
    init(id : String, url : String,image: UIImage? = nil) {
        self.id = id
        self.url = url
        self.image = image
    }
}
