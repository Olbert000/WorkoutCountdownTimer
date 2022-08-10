//
//  LandingPage.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 6/8/22.
//

import SwiftUI

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct LandingView: View {
    let cities = [
        City(name: "Melbourne"),
        City(name: "Sydney"),
        City(name: "Brisbane"),
        City(name: "Canberra"),
        City(name: "Hobart"),
        City(name: "Perth"),
        City(name: "Adelaide"),
        City(name: "Darwin"),
        City(name: "Goulburn"),
        City(name: "Launceston"),
        City(name: " ")
    ]
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: CountDownView()) {
                Text("Start Counting")
            }
            List (cities){ city in
                NavigationLink(value: city) {
                    Label(city.name, systemImage: "car")
                }
            }
            .navigationDestination(for: City.self) { city in
                CountDownView()
            }
        }
    }
}


struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
