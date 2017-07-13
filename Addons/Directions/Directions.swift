//
//  Directions.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class Directions {
    
    typealias NavigateObject = (uri: String, name: String, url: String)
    let appleMapsUrl = "http://maps.apple.com/maps?saddr=Current%20Location&daddr=#LAT#,#LON#"
    let googleMapsUrl = "comgooglemaps://?saddr=&daddr=#LAT#,#LON#&directionsmode=driving"
    let wazeUrl = "waze://?ll=#LAT#,#LON#&navigate=yes"
    let taxi99Url = "taxis99://call?endLat=#LAT#&endLng=#LON#&endName=#ADDRESS#"
    let lyftUrl = [
            "lyft://ridetype?id=lyft_line&destination[latitude]=#LAT#",
            "&destination[longitude]=#LON#"
    ].joined()
    let uberUrl = [
            "uber://?action=setPickup&client_id=ES9w742-vWWr6yzKEWkAY7veLzO_8cKz",
            "&pickup=my_location&dropoff[formatted_address]=#ADDRESS#",
            "&dropoff[latitude]=#LAT#&dropoff[longitude]=#LON#"
    ].joined()
    let cabifyUrl = [
            "cabify://cabify/journey?json=%7B%22stops%22%3A%5B%22current",
            "%22%2C%7B%22loc%22%3A%7B%22latitude%22%3A#LAT#%2C%20%22longitude",
            "%22%3A#LON#%7D%2C%22name%22%3A%22#ADDRESS#%22%7D%5D%7D"
    ].joined()
    func open(_ viewCtrl: UIViewController,
              _ lat: Float,
              _ lon: Float,
              _ address: String,
              _ sender: UIButton) {
        let possibles: [NavigateObject] = [("http://", "Apple Maps", appleMapsUrl),
                                           ("comgooglemaps://", "Google Maps", googleMapsUrl),
                                           ("waze://", "Waze", wazeUrl),
                                           ("uber://", "Uber", uberUrl),
                                           ("lyft://", "Lyft", lyftUrl),
                                           ("cabify://", "Cabify", cabifyUrl),
                                           ("taxis99://", "99 Taxis", taxi99Url)]
        var canOpen: [NavigateObject] = []
        for test in possibles {
            if UIApplication.shared.canOpenURL(URL(string: test.uri)!) {
                canOpen.append(test)
            }
        }
        if canOpen.count == 0 {
            let alert = Alert.ok(title: "Directions",
                                 message: "Sorry, this device doesn't have any app to perform this action.")
            DispatchQueue.main.async(execute: {
                viewCtrl.present(alert, animated: true)
            })
        } else {
            if canOpen.count == 1 {
                self.openWith(canOpen[0].url, lat, lon, address)
            } else {
                let alert = UIAlertController(title: "Directions",
                                              message: nil,
                                              preferredStyle: UIAlertControllerStyle.actionSheet)
                for navigationApp in canOpen {
                    let action = UIAlertAction(title: navigationApp.name,
                                               style: UIAlertActionStyle.default,
                                               handler: { _ in
                        self.openWith(navigationApp.url, lat, lon, address)
                    })
                    let icon = UIImage(named: navigationApp.name)
                    action.setValue(icon, forKey: "image")
                    alert.addAction(action)
                }
                alert.addAction(UIAlertAction(title: "Dismiss",
                                              style: UIAlertActionStyle.cancel,
                                              handler: { _ in }))
                if let popoverPresentationController = alert.popoverPresentationController {
                    popoverPresentationController.sourceView = sender
                    popoverPresentationController.sourceRect = sender.bounds
                }
                DispatchQueue.main.async(execute: {
                    viewCtrl.present(alert, animated: true)
                })
            }
        }
    }
    private func openWith(_ url: String,
                          _ lat: Float,
                          _ lon: Float,
                          _ address: String) {
        let curl = url
            .replacingOccurrences(of: "#LAT#", with: "\(lat)")
            .replacingOccurrences(of: "#LON#", with: "\(lon)")
            .replacingOccurrences(of: "#ADDRESS#",
                                  with: address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        UIApplication.shared.open(URL(string: curl)!)
    }
}
