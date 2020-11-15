//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Paul Richardson on 8/11/20.
//

import SwiftUI

enum SortType {
	case none, name, country
}

enum FilterType {
	case none, price, size, country
}

struct ContentView: View {
	
	@State private var sortBy = SortType.none
	
	var body: some View {
		
		TabView {
			ResortsView(sortBy: $sortBy, filterType: .none)
				.tabItem {
					Image(systemName: "lasso")
					Text("All")
				}
			
			ResortsView(sortBy: $sortBy, filterType: .price)
				.tabItem {
					Image.init(systemName: "dollarsign.circle")
					Text("$$$")
				}
			
			ResortsView(sortBy: $sortBy, filterType: .size)
				.tabItem {
					Image.init(systemName: "slider.horizontal.below.rectangle")
					Text("Size")
				}

			ResortsView(sortBy: $sortBy, filterType: .country)
				.tabItem {
					Image.init(systemName: "map")
					Text("Country")
				}

		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

extension View {
	func phoneOnlyStackNavigationView() -> some View {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
		} else {
			return AnyView(self)
		}
	}
}
