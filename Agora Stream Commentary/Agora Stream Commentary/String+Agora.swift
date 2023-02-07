//
//  String+Agora.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import Foundation

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
