//
//  SwiftUIUtility.swift
//  Enjay CRM
//
//  Created by MacBook Pro on 18/09/25.
//  Copyright © 2025 Enjay It Solutions Ltd. All rights reserved.
//

import SwiftUI


@MainActor
public class MultiModeDatePicker {
   public class func showDatePicker(
        from presenter: UIViewController? = UIApplication.topViewController(),
        title: String,
        initialDate: Date = Date(),
        minDate: Date? = nil,
        maxDate: Date? = nil,
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
            onDone: { completion($0) },
            onCancel: {  },

        )

        let host = UIHostingController(rootView: wrapper)
        host.modalPresentationStyle = .overFullScreen
        host.view.backgroundColor = .clear

        presenter.present(host, animated: true)
    }
}

