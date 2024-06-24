//
//  ModelForSecondScreen.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 24.05.24.
//

import Foundation
import UIKit
struct Results : Decodable {
    var info : Info
    var results : [DataModel]
}
struct Info : Decodable {
    var pages : Int
}
struct DataModel  : Decodable {
    var id : Int
    var name : String
    var status : String
    var species : String
    var type : String
    var gender : String
    var origin : Origin?
    var image : String
    var isSaved : Bool = false
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case status
            case species
            case type
            case gender
            case origin
            case image
        }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name) 
            self.id = try container.decode(Int.self, forKey: .id)
            self.status = try container.decode(String.self, forKey: .status)
            self.species = try container.decode(String.self, forKey: .species)
            self.type = try container.decode(String.self, forKey: .type)
            self.gender = try container.decode(String.self, forKey: .gender)
            self.origin = try container.decode(Origin.self, forKey: .origin)
            self.image = try container.decode(String.self, forKey: .image)
            self.isSaved = false // Provide a default value
        }    
}
struct Origin : Decodable {
    var name : String
}
struct FilterData {
    var textLabel = ["Gender types","Classifications","Status"]
    var categories = ["Gender types","Classifications","Status"]
    var dropDownData = [["Gender Types","Male","Female","Genderless","Unknown"],["Classifications","Mythological Creature","Alien","Human","Humanoid","Animal"],["Status","Alive","Dead","Unknown"]]
    var filterQueries = ["","",""]
    init() {}
}
struct textLabelData {
    var attributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular_Bold", size: 20),NSAttributedString.Key.foregroundColor: UIColor.white]
    var genderText : NSMutableAttributedString {
        return NSMutableAttributedString(string: "Gender: ", attributes: attributes as [NSAttributedString.Key : Any])
    }
    var statusText : NSMutableAttributedString {
        return NSMutableAttributedString(string: "Status: ", attributes: attributes as [NSAttributedString.Key : Any])
    }
    var speciesText : NSMutableAttributedString {
        return NSMutableAttributedString(string: "Species: ", attributes: attributes as [NSAttributedString.Key : Any])
    }
    var typeText : NSMutableAttributedString {
        return NSMutableAttributedString(string: "Type: ", attributes: attributes as [NSAttributedString.Key : Any])
    }
    var originText : NSMutableAttributedString {
        return NSMutableAttributedString(string: "Origin: ", attributes: attributes as [NSAttributedString.Key : Any])
    }
}

struct BoolCases {
    var isLoading = false
    var isShowingSaved = false
    var isSearching = false
}
