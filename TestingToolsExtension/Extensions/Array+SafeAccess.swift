//
//  File.swift
//  TestingTools
//
//  Created by Andy Brown on 29/11/2024.
//
import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
