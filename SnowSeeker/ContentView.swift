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

struct ContentView: View {
	@ObservedObject var favorites = Favorites()
	@State private var isShowingSorter = false
	@State private var sortBy = SortType.none
	
	let resorts: [Resort] = Bundle.main.decode("resorts.json")
	
	var sortedResorts: [Resort] {
		switch sortBy {
		case .none:
			return resorts
		case .name:
			return resorts.sorted() { $0.name < $1.name }
		case .country:
			return resorts.sorted() { $0.country < $1.country }
		}
	}
	
	var body: some View {
		NavigationView {
			List(sortedResorts) { resort in
				NavigationLink(
					destination: ResortView(resort: resort)) {
					Image(resort.country)
						.resizable()
						.scaledToFill()
						.frame(width: 40, height: 25)
						.clipShape(
							RoundedRectangle(cornerRadius: 5)
						)
						.overlay(
							RoundedRectangle(cornerRadius: 5)
								.stroke(Color.black, lineWidth: 1)
						)
					VStack(alignment: .leading) {
						Text(resort.name)
							.font(.headline)
						Text("\(resort.runs) runs")
							.foregroundColor(.secondary)
					}
					.layoutPriority(1)
					
					if self.favorites.contains(resort) {
						Spacer()
						Image(systemName: "heart.fill")
							.accessibility(label: Text("This is a favorite resort"))
							.foregroundColor(.red)
							.padding(.trailing)
					}
				}
			}
			.navigationBarTitle("Resorts")
			.navigationBarItems(trailing: Button(action: {
				self.isShowingSorter = true
			}) {
				Image(systemName: "arrow.up.arrow.down")
				Text("Sort")
			})
			.actionSheet(isPresented: $isShowingSorter) {
				ActionSheet(title: Text("Sort resorts by:"), buttons: [
					.default(Text("Name")) {
						self.sortBy = .name
					},
					.default(Text("Country")) {
						self.sortBy = .country
					}
				])
			}
			
			WelcomeView()
		}
		.phoneOnlyStackNavigationView()
		.environmentObject(favorites)
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
