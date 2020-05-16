//
//  EventDetailModel.swift
//  TechGropseMT
//
//  Created by Satish Thakur on 15/05/20.
//  Copyright © 2020 Satish Thakur. All rights reserved.
//

import Foundation
import UIKit

class EventDetailModelClass{

    class func convertObjectWithData(object : [String: Any]) -> EventDetailModel{

        let modelData = EventDetailModel()
        var categoryName =  "\(object["category_name"]!)"
        categoryName = (categoryName == "<null>") ? "" : categoryName
        let isFav =  object["ev_is_fav"] as? String ?? "0"

        var eventTypeColor =  object["category_color"] as? String ?? "#ED4A02"
        eventTypeColor = (eventTypeColor == "<null>") ? "" : eventTypeColor
        let eventName =  "\(object["ev_name"]!)"
        let eventUserId =  "\(object["ev_user_id"]!)"
        let isPaid =  object["ev_event_fee"] as? String ?? "0"
        let eventTitle =  "\(object["ev_title"]!)"
        let eventCity =  "\(object["ev_city"] ?? "")"
        let eventCountry =  "\(object["ev_country"]!)"
        let eventStartDate =  "\(object["ev_start_date"]!)"
        let eventEndDate = "\(object["ev_end_date"]! )"
        let eventStartTime =  "\(object["ev_start_time"]!)"
        let eventEndTime = "\(object["ev_end_time"]! )"
        let eventView =  "\(object["ev_views"]!)"
        let eventLike =  "\(object["ev_like"]!)"
        let eventReminder =  "\(object["ev_reminder"]!)"
        let eventDistance =  "\(object["distance"]!)"
        let evenrDescription =  "\(object["ev_description"]!)"
        let eventVenueName =  "\(object["ev_address"]!)"

        let eventGender =  "\(object["ev_gender"]!)"
        let eventLanguage =  "\(object["ev_language"]!)"
        let eventAge =  "\(object["ev_age_id"]!)"

        if let eventImage = object["ev_image"] as? [[String:Any]] {
            for object in eventImage{
                var imageSingleModel = imageModel()
                let imageUrl = "\(object["image"]!)"
                imageSingleModel.imageUrl = imageUrl
                modelData.image.append(imageSingleModel)
            }
        }
        if let eventOragniserList = object["event_organizer"] as? [[String:Any]] {
            var tempArr = [OSPModel]()
            for object in eventOragniserList {
                var model = OSPModel()
                model.id = "\(object["organizer_id"]!)"
                model.name = object["o_name"] as? String ?? ""
                model.nameAr = object["o_name_ar"] as? String ?? ""
                model.image = object["o_logo"] as? String ?? ""
                model.detail = object["o_detail"] as? String ?? ""
                model.contact = object["o_contact"] as? String ?? ""
                model.typeName = object["o_type_name"] as? String ?? ""
                model.status = "\(object["o_status"]!)"
                tempArr.append(model)
            }
            modelData.organisers = tempArr
        }
        if let eventSponsorList = object["event_sponser"] as? [[String:Any]] {
            var tempArr = [OSPModel]()
            for object in eventSponsorList {
                var model = OSPModel()
                model.id = "\(object["sponsor_id"]!)"
                model.name = object["s_name"] as? String ?? ""
                model.nameAr = object["s_name_ar"] as? String ?? ""
                model.image = object["s_logo"] as? String ?? ""
                model.detail = object["s_detail"] as? String ?? ""
                model.contact = object["s_contact"] as? String ?? ""
                model.typeName = object["s_type_name"] as? String ?? ""
                model.status = "\(object["s_status"]!)"
                tempArr.append(model)
            }
            modelData.sponsors = tempArr
        }
        if let eventPerformerList = object["event_performer"] as? [[String:Any]] {
            var tempArr = [OSPModel]()
            for object in eventPerformerList {
                var model = OSPModel()
                model.id = "\(object["performer_id"]!)"
                model.name = object["p_name"] as? String ?? ""
                model.nameAr = object["p_name_ar"] as? String ?? ""
                model.image = object["p_logo"] as? String ?? ""
                model.detail = object["p_detail"] as? String ?? ""
                model.contact = object["p_contact"] as? String ?? ""
                model.typeName = object["p_type_name"] as? String ?? ""
                model.status = "\(object["p_status"]!)"
                tempArr.append(model)
            }
            modelData.performers = tempArr
        }
        if let eventSeatingPlan = object["ev_seating_map_image"] as? [[String:Any]] {
            for object in eventSeatingPlan{
                var imageSingleModel = imageModel()
                let imageUrl = "\(object["image"] ?? "")"
                imageSingleModel.imageUrl = imageUrl
                modelData.seatingPlanImages.append(imageSingleModel)
            }
        }

        if let EventTagData = object["event_tag"] as? [[String:Any]] {
            for object in EventTagData{
                var eventTagSingleModel = EventTagModel()

                let id = object["et_id"] as! String
                let idName = object["et_name_en"] as! String
                let color = object["et_color"] as? String ?? "#EC5C4D"

                eventTagSingleModel.eventTagName_EN = idName
                eventTagSingleModel.eventtagID = id
                eventTagSingleModel.tagColor = color
                modelData.eventTag.append(eventTagSingleModel)
            }
        }

        modelData.eventUserId = eventUserId

        modelData.eventTypeColor = UIColor(hexString: eventTypeColor)
        modelData.eventCity =  eventCity
        modelData.eventCountry = eventCountry

        modelData.evenrDescription =  evenrDescription
        modelData.importantNote = "\(object["ev_imp_notes"] ?? "")"
        modelData.detailDescription = "\(object["ev_detail"] ?? "")"
        modelData.email = "\(object["ev_email"] ?? "")"
        modelData.phoneNo = "\(object["ev_contact"] ?? "")"
        modelData.whatsappNo = "\(object["ev_whatsapp_no"] ?? "")"
        modelData.website = "\(object["ev_website"] ?? "")"
        modelData.venueName = "\(object["ev_vennue_name"] ?? "")"
        modelData.venueLocation = "\(eventCity),\(eventCountry)"
        modelData.venueGeoLocation = eventVenueName //"\(object["ev_city"] ?? "")" //Correct Later

        modelData.categoryName =  categoryName
        modelData.isFav = isFav == "0" ? false : true

        modelData.latitude = "\(object["ev_lat"]!)"
        modelData.longitude = "\(object["ev_long"]!)"

        modelData.isPaid = Int(isPaid)!
        if let attending = object["ev_is_reminder"] as? String {
            modelData.isAttending = attending == "0" ? false : true
        }
        modelData.isNew = ("\(object["ev_new"] ?? "")" == "1") ? true : false
        modelData.isFeatured = ("\(object["ev_featured"] ?? "")" == "1") ? true : false

        modelData.eventView = eventView
        modelData.eventLike =  eventLike
        modelData.eventReminder = eventReminder
        modelData.eventDistance = eventDistance
        modelData.eventName = eventName
        modelData.eventTitle = eventTitle

        let formatterDiff = DateFormatter()
        formatterDiff.dateFormat = "yyyy-MM-dd"
        let startDateD = formatterDiff.date(from: eventStartDate) ?? Date()
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: startDateD).day
        modelData.eventRemainingDays = diffInDays ?? 0

        let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")

        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: eventStartDate) {
            formatter.dateFormat = "dd MMM yyyy"
            modelData.eventStartDate =  formatter.string(from: date)
        }
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: eventEndDate) {
            formatter.dateFormat = "dd MMM yyyy"
            modelData.eventEndDate =  formatter.string(from: date)
        }
        formatter.dateFormat = "HH:mm:ss"
        if let date = formatter.date(from: eventStartTime) {
            formatter.dateFormat = "hh:mm a"
            modelData.eventStartTime =  formatter.string(from: date)
        }
        formatter.dateFormat = "HH:mm:ss"
        if let date = formatter.date(from: eventEndTime) {
            formatter.dateFormat = "hh:mm a"
            modelData.eventEndTime =  formatter.string(from: date)
        }

        modelData.eventLanguage = getLanguage(by: eventLanguage)
        modelData.eventAge = getAge(by: eventAge)
        modelData.eventGender = getGender(by: eventGender)

        return modelData
    }

    private class func getGender(by id:String) -> String {
        let arr = id.components(separatedBy: ",")
        var strArr = [String]()
        for object in arr {
            if object == "1" {
                strArr.append("Male")
            } else if object == "2" {
                strArr.append("Female")
            } else if object == "3" {
                strArr.append("Children")
            } else {
                strArr.append("Male, Female & Children")
            }
        }
        return strArr.joined(separator: ",")
    }
    private class func getLanguage(by id:String) -> String {

        let arr = id.components(separatedBy: ",")
        var strArr = [String]()
        for object in arr {
            if object == "1" {
                strArr.append("English")
            } else if object == "2" {
                strArr.append("Arabic")
            } else if object == "3" {
                strArr.append("NA")
            } else {
                strArr.append("English & Arabic")
            }
        }
        return strArr.joined(separator: ",")
    }
    private class func getAge(by id:String) -> String {

        let arr = id.components(separatedBy: ",")
        var strArr = [String]()
        var last: String = "9"
        for object in arr {
            if object == "1" {
                strArr.append("0-5")
            } else if object == "2" {
                if ((Int(object)! - Int(last)!) == 1) {
                    strArr[strArr.count - 1] = "0-12"
                } else {
                    strArr.append("6-12")
                }
            } else if object == "3" {
                if ((Int(object)! - Int(last)!) == 1) {
                    strArr[strArr.count - 1] = "\(strArr[strArr.count - 1].components(separatedBy: "-").first ?? "6")-18"
                } else {
                    strArr.append("13-18")
                }
            } else if object == "4" {
                if ((Int(object)! - Int(last)!) == 1) {
                    strArr[strArr.count - 1] = "\(strArr[strArr.count - 1].components(separatedBy: "-").first ?? "13")-25"
                } else {
                    strArr.append("19-25")
                }
            } else if object == "5" {
                if ((Int(object)! - Int(last)!) == 1) {
                    strArr[strArr.count - 1] = "\(strArr[strArr.count - 1].components(separatedBy: "-").first ?? "19")-50"
                } else {
                    strArr.append("26-50")
                }
            } else if object == "6" {
                if ((Int(object)! - Int(last)!) == 1) {
                    strArr[strArr.count - 1] = "\(strArr[strArr.count - 1].components(separatedBy: "-").first ?? "26")-50+"
                } else {
                    strArr.append("50+")
                }
            } else {
                strArr.append("0-50")
            }
            last = object
        }
        var str = strArr.joined(separator: ",")
        str = str + " \("Years")"
        return str
    }
}
