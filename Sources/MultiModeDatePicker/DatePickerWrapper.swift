import SwiftUI

struct DatePickerPopup: View {
    @Environment(\.dismiss) private var dismiss

    var title: String
    var initialDate: Date
    var minDate: Date?
    var maxDate: Date?
    var pickerType: CustomPickerType
    var onDone: (Date) -> Void
    var onCancel: () -> Void

    @State private var selectedDate: Date

    init(
        title: String,
        initialDate: Date,
        minDate: Date? = nil,
        maxDate: Date? = nil,
        pickerType: CustomPickerType = .date,
        onDone: @escaping (Date) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.initialDate = initialDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.pickerType = pickerType
        self.onDone = onDone
        self.onCancel = onCancel
        _selectedDate = State(initialValue: initialDate)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                    onCancel()
                }

            VStack{
                Text(title)
                    .font(.headline)
                    .padding(.top)

                DatePickerView(
                    initialDate: initialDate,
                    selectedDate: $selectedDate,
                    minDate: minDate,
                    maxDate: maxDate,
                    title: title,
                    pickerStyle: pickerType
                   
                )
                .labelsHidden()
                

                HStack {
                    Button("Cancel") {
                        dismiss()
                        onCancel()
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .padding(.bottom , 20)
                    Spacer()
                    Button("Done") {
                        dismiss()
                        onDone(selectedDate)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom , 20)
                    
                }
               
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
            .shadow(radius: 12)
            .transition(.scale)
        }
    }
}
