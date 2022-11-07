//
//  String.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 7/11/22.
//

import Foundation

extension String {
    
    // Func for get a date String
    func formatBirthDateStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = formatter.date(from: self) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            
            return outputFormatter.string(from: date)
        }
        return ""
    }
    
    func formatISODateString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if let date = formatter.date(from: self) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            return outputFormatter.string(from: date)
        }
        return nil

    }
}
