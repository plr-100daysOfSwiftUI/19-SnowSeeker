//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Paul Richardson on 8/11/20.
//

import SwiftUI

struct ContentView: View {
	
	var body: some View {
		
		TabView {
			ResortsView(filterType: .none)
				.tabItem {
					Image(systemName: "lasso")
					Text("All")
				}
			
			ResortsView(filterType: .price)
				.tabItem {
					Image.init(systemName: "dollarsign.circle")
					Text("$$$")
				}
			
			ResortsView(filterType: .size)
				.tabItem {
					Image.init(systemName: "slider.horizontal.below.rectangle")
					Text("Size")
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
