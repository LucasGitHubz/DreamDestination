//
//  String+extension.swift
//  DreamDestination
//
//  Created by kuroro on 30/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import Foundation

extension String {
    func uppercaseMaker() -> String {
        // String array created with each characters
        var stringTab = self.compactMap { String($0) }

        // Change the first one automatically to an uppercase
        stringTab[0] = stringTab[0].uppercased()

        for index in 0...stringTab.count - 1 {
            // If there is a space character " ", change the next one to an uppercase:
            // "N","e","w"," ","y","o","r","k"," ","c","i","t","y" ->
            // "N","e","w"," ","Y","o","r","k"," ","C","i","t","y"
            if stringTab[index] == " ", index < stringTab.count - 1 {
                stringTab[index + 1] = stringTab[index + 1].uppercased()
            }
            // If the last one is a space delete it:
            // "N","i","c","e"," " -> "N","i","c","e"
             else if stringTab[index] == " ", index == stringTab.count - 1 {
                stringTab.remove(at: index)
            }
        }

        // Join all string array's characters:
        // "N","i","c","e" -> "Nice"
        let finalString = stringTab.joined(separator: "")

        return finalString
    }
}
