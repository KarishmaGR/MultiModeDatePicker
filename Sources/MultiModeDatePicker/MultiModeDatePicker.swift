// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI


@MainActor
public class MultiModeDatePicker {
   public class func showDatePicker(
        from presenter: UIViewController? = UIApplication.topViewController(),
        title: String,
        initialDate: Date = Date(),
        minDate: Date? = nil,
        maxDate: Date? = nil,
        timeSystem: TimeSystem = .tweleHours,
        pickerType: CustomPickerType = .date,
        completion: @escaping (Date?) -> Void
    ) {
        guard let presenter = presenter else { return }

        let wrapper = DatePickerPopup(
            title: title,
            initialDate: initialDate,
            minDate: minDate,
            maxDate: maxDate,
            pickerType: pickerType,
            timeSystem: timeSystem,
            onDone: { completion($0) },
            onCancel: {  },

        )

        let host = UIHostingController(rootView: wrapper)
        host.modalPresentationStyle = .overFullScreen
        host.view.backgroundColor = .clear

        presenter.present(host, animated: true)
    }
}



struct MultiModeDatePickerPreview: View {
    @State private var selectedDate: Date?
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 20) {
            if let date = selectedDate {
                Text("Selected Date: \(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.headline)
            } else {
                Text("No date selected")
                    .foregroundColor(.gray)
            }

            Button("Show Date Picker") {
                showPicker.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .onChange(of: showPicker) { newValue in
            if newValue {
                MultiModeDatePicker.showDatePicker(
                    title: "Select Date & Time",
                    initialDate: Date(),
                    minDate: Date().addingTimeInterval(-86400),
                    maxDate: Date().addingTimeInterval(86400 * 30),
                    timeSystem: .twentyFourHours,
                    pickerType: .time
                ) { selected in
                    selectedDate = selected
                }

                // reset after presenting
                showPicker = false
            }
        }
        .padding()
    }
}

#Preview {
    MultiModeDatePickerPreview()
}
