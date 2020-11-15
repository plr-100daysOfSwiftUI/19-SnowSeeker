
//
//  ResortsView.swift
//  SnowSeeker
//
//  Created by Paul Richardson on 12/11/2020.
//

import SwiftUI

enum PriceFilter {
	case none, low, medium, high
}

enum SizeFilter {
	case none, small, average , large
}

enum CountryFilter: String {
	case none
	case austria
	case canada
	case france
	case italy
	case unitedStates
}

struct ResortsView: View {
	@ObservedObject var favorites = Favorites()
	@State private var isShowingFilter = false
	@State private var isShowingSorter = false
	@State private var priceFilter = PriceFilter.none
	@State private var sizeFilter = SizeFilter.none
	@State private var countryFilter = CountryFilter.none
	@Binding var sortBy: SortType
	
	let resorts: [Resort] = Bundle.main.decode("resorts.json")
	let filterType: FilterType
	
	var filteredResorts: [Resort] {
		switch filterType {
		case .none:
			return resorts
		case .price:
			return filteredByPrice
		case .size:
			return filteredBySize
		case .country:
			return filteredByCountry
		}
	}
	
	var filteredByPrice: [Resort] {
		switch priceFilter {
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
	
	var filteredBySize: [Resort] {
		switch sizeFilter {
		case .none:
			return resorts
		case .small:
			return resorts.filter { $0.size == 1 }
		case .average:
			return resorts.filter { $0.size == 2 }
		case .large:
			return resorts.filter { $0.size == 3 }
		}
	}
	
	var filteredByCountry: [Resort] {
		switch countryFilter {
		case .none:
			return resorts
		case .austria:
			return resorts.filter { $0.country == "Austria"}
		case .canada:
			return resorts.filter { $0.country == "Canada"}
		case .france:
			return resorts.filter { $0.country == "France" }
		case .italy:
			return resorts.filter { $0.country == "Italy"}
		case .unitedStates:
			return resorts.filter { $0.country == "United States"}
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
	
	func filterActionSheetTitle(_ filter: FilterType) -> Text {
		return Text("Filter resorts by \(filter.rawValue):")
	}
	
	var priceFilterAction: ActionSheet {
		return ActionSheet(title: filterActionSheetTitle(.price), buttons: [
			.default(Text("Low")) {
				self.priceFilter = .low
			},
			.default(Text("Medium")) {
				self.priceFilter = .medium
			},
			.default(Text("High")) {
				self.priceFilter = .high
			},
			.cancel()
		])
	}
	
	var sizeFilterAction: ActionSheet {
		return ActionSheet(title: filterActionSheetTitle(.size), buttons: [
			.default(Text("Small")) {
				self.sizeFilter = .small
			},
			.default(Text("Average")) {
				self.sizeFilter = .average
			},
			.default(Text("Large")) {
				self.sizeFilter = .large
			},
			.cancel()
		])
	}
	
	var countryFilterAction: ActionSheet {
		return ActionSheet(title: filterActionSheetTitle(.country), buttons: [
			.default(Text("Austria")) {
				self.countryFilter = .austria
			},
			.default(Text("Canada")) {
				self.countryFilter = .canada
			},
			.default(Text("France")) {
				self.countryFilter = .france
			},
			.default(Text("Italy")) {
				self.countryFilter = .italy
			},
			.default(Text("United States")) {
				self.countryFilter = .unitedStates
			},
			.cancel()
		])
	}
	
	var leadingButton: some View {
		Button(action: {
			self.isShowingFilter = true
		}) {
			Image(systemName: "pin")
			Text("Filter")
		}
		.actionSheet(isPresented: $isShowingFilter) {
			switch filterType {
			case .none:
				return priceFilterAction // none
			case .price:
				return priceFilterAction
			case .size:
				return sizeFilterAction
			case .country:
				return countryFilterAction
			}
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
			.navigationBarItems(
				leading: filterType == .none ? AnyView(EmptyView()) : AnyView(leadingButton),
				trailing: Button(action: {
					self.isShowingSorter = true
				}) {
					Image(systemName: "arrow.up.arrow.down")
					Text("Sort")
				}
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
				})
			
			WelcomeView()
		}
		.phoneOnlyStackNavigationView()
		.environmentObject(favorites)
	}
	
}

struct ResortsView_Previews: PreviewProvider {
	static var previews: some View {
		ResortsView(sortBy: .constant(.none), filterType: .none)
	}
}
