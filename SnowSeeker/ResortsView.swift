
//
//  ResortsView.swift
//  SnowSeeker
//
//  Created by Paul Richardson on 12/11/2020.
//

import SwiftUI

enum SortType {
	case none, name, country
}


enum FilterType {
	case none, price, size, country
}

enum PriceFilter {
	case none, low, medium, high
}

struct ResortsView: View {
	@ObservedObject var favorites = Favorites()
	@State private var isShowingFilter = false
	@State private var isShowingSorter = false
	@State private var filterBy = PriceFilter.none
	@State private var sortBy = SortType.none
	
	let resorts: [Resort] = Bundle.main.decode("resorts.json")
	let filter: FilterType
	
	var filteredResorts: [Resort] {
		switch filterBy {
		case .none:
			return resorts
		case .low:
			return resorts.filter { $0.price == 1 }
		case .medium:
			return resorts.filter { $0.price == 2 }
		case .high:
			return resorts.filter { $0.price == 3 }
		}
	}
	
	var sortedResorts: [Resort] {
		switch sortBy {
		case .none:
			return filteredResorts
		case .name:
			return filteredResorts.sorted() { $0.name < $1.name }
		case .country:
			return filteredResorts.sorted() { $0.country < $1.country }
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
			.navigationBarItems(leading: Button(action: {
				self.isShowingFilter = true
			}) {
				Image(systemName: "pin")
				Text("Filter")
			},
				trailing: Button(action: {
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
					},
					.cancel()
				])
			}
			
			WelcomeView()
		}
		.phoneOnlyStackNavigationView()
		.environmentObject(favorites)
	}
	
}

struct ResortsView_Previews: PreviewProvider {
    static var previews: some View {
			ResortsView(filter: .none)
    }
}
