import SwiftUI

struct TodayScreen: View {
    @State private var selectedDayIndex = Calendar.current.component(.weekday, from: Date()) - 1

    let days = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            TodayView(selectedDayIndex: selectedDayIndex)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                ForEach(0..<days.count, id: \.self) { index in
                    Button(action: {
                        selectedDayIndex = index
                    }) {
                        Text(days[index])
                            .fontWeight(.bold)
                            .frame(width: 40, height: 40)
                            .background(selectedDayIndex == index ? Color.customSwitchBlue : Color(.systemGray5))
                            .foregroundColor(selectedDayIndex == index ? .white : .black)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 20) // Gives enough space above the Tab Bar
            .background(Color.white)
        }
    }
}



extension Color {
    static let customSwitchBlue = Color(red: 94/255, green: 167/255, blue: 219/255)
}
