//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Paul Richardson on 10/11/20.
//

import SwiftUI

class Favorites: ObservableObject {
	private var resorts: Set<String>
	private let saveKey = "Favorites"
	
	init () {
		self.resorts = []

		// load our saved data
		if let data = UserDefaults.standard.data(forKey: saveKey) {
			if let decoded = try? JSONDecoder().decode([String].self, from: data) {
				decoded.forEach { resort in self.resorts.insert(resort) }
			}
		}
				
	}

	func contains(_ resort: Resort) -> Bool {
		resorts.contains(resort.id)
	}

	func add(_ resort: Resort) {
		objectWillChange.send()
		resorts.insert(resort.id)
		save()
	}
	
	func remove(_ resort: Resort) {
		objectWillChange.send()
		resorts.remove(resort.id)
		save()
	}
	
	func save() {
		// write out our data
		if let data = try? JSONEncoder().encode(self.resorts) {
			UserDefaults.standard.set(data, forKey: self.saveKey)
		}
	}
}
