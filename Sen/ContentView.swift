import SwiftUI

// TODO: Root tab view — Today, Plan, Calendar tabs

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }
            PlanView()
                .tabItem { Label("Plan", systemImage: "mic") }
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
        }
    }
}
