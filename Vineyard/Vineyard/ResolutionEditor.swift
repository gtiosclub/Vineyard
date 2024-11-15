//
//  ResolutionEditor.swift
//  Vineyard
//
//  Created by Rahul on 11/12/24.
//

import SwiftUI

fileprivate enum EditField: String, CaseIterable {
    case resolutionTitle = "Resolution"
    case frequencyType = "FrequencyType"
    case frequencyQuantity = "Frequency"
}

struct ResolutionEditorResult: Equatable {
    var resolutionTitle = "run"
    var frequencyType: FrequencyType = .daily
    var frequencyQuantity: Int = 1
    var extractedQuantity: Int?
    var difficulty: DifficultyLevel = .medium

    private var frequencyText: String {
        if frequencyQuantity == 1 {
            return "[\(frequencyQuantity == 1 ? "once" : "\(frequencyQuantity) times")](\(EditField.frequencyQuantity.rawValue))"
        } else {
            return "[\(frequencyQuantity)](\(EditField.frequencyQuantity.rawValue)) times"
        }
    }

    var attributedText: AttributedString {
        try! .init(
            markdown: "I want to [\(resolutionTitle)](\(EditField.resolutionTitle.rawValue)) \(frequencyText) a [\(frequencyType.rawValue)](\(EditField.frequencyType.rawValue))"
            )
    }

    var finalResolutionTitle: String {
        NSAttributedString(attributedText).string
    }
}

struct ResolutionEditor: View {
    @Binding var result: ResolutionEditorResult
    @State private var isPresented: Bool = false
    @State private var changeResolutionTitle: Bool = false
    @State private var currentlyEditingField: EditField? = EditField.resolutionTitle

    @Binding var hasQuantity: Bool
    @State private var quantityRange: NSRange?

    @State private var height: CGFloat?
    let minHeight: CGFloat = 150

    var body: some View {
        VStack {
            TextViewWrapper(
                text: result.attributedText + ".",
                hasQuantity: hasQuantity,
                quantityRange: quantityRange
            ) { url in
                switch url.absoluteString {
                case EditField.frequencyType.rawValue:
                    return FrequencyType.allCases.map { type in
                        MenuAction(
                            title: type.rawValue,
                            image: nil
                        ) {
                            result.frequencyType = type
                        }
                    }
                default:
                    return [
                        MenuAction(
                            title: "Edit \(url.absoluteString)",
                            image: .init(systemName: "pencil")
                        ) {
                            currentlyEditingField = EditField(
                                rawValue: url.absoluteString
                            )
                            if url.absoluteString == EditField.resolutionTitle.rawValue {
                                changeResolutionTitle = true
                            } else {
                                isPresented = true
                            }
                        }
                    ]
                }
            } textDidChange: {
                self.height = max($0.contentSize.height, minHeight)
            }
            .frame(height: height ?? minHeight)
            .padding()

            Menu {
                ForEach(DifficultyLevel.allCases, id: \.self) { diff in
                    Button {
                        result.difficulty = diff
                    } label: {
                        HStack {
                            Text(diff.rawValue).tag(diff)
                            Spacer()
                            if diff == result.difficulty {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                difficultyPickerLabel
            }
        }
        .popover(
            isPresented: $changeResolutionTitle,
            attachmentAnchor: .point(.top),
            arrowEdge: .bottom
        ) {
            VStack(spacing: 24) {
                    // Title Section with decorative line
                    VStack(spacing: 8) {
                        Text("Edit Resolution")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 48, height: 4)
                            .cornerRadius(2)
                    }

                    // Input Section
                    VStack(spacing: 16) {
                        TextField("Resolution Title", text: $result.resolutionTitle)
                            .textInputAutocapitalization(.never)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                            )

                        // Toggle with better styling
                        HStack {
                            Text("Quantity")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Spacer()

                            Toggle("", isOn: $hasQuantity)
                                 .toggleStyle(SwitchToggleStyle(tint: .blue))
                                 .disabled(quantityRange == nil)
                        }

                        Button("Done") { changeResolutionTitle.toggle() }
                            .buttonStyle(.borderedProminent)
                            .disabled(result.resolutionTitle.isEmpty)
                    }
                }
                .padding(24)
                .cornerRadius(16)
                .frame(minWidth: 250, minHeight: 200)
                .ignoresSafeArea(.keyboard)
                .presentationCompactAdaptation(.popover)
                .interactiveDismissDisabled()
        }
        .alert("Edit \(currentlyEditingField?.rawValue ?? "")", isPresented: $isPresented) {
            switch currentlyEditingField {
            case .resolutionTitle:
                TextField("Resolution Title", text: $result.resolutionTitle)
            case .frequencyType:
                Picker("Frequency Type", selection: $result.frequencyType) {
                    ForEach(FrequencyType.allCases, id: \.self) { frequencyType in
                        Text(frequencyType.rawValue)
                            .tag(frequencyType)
                    }
                }
            case .frequencyQuantity:
                TextField("Edit Frequency Quantity", value: $result.frequencyQuantity, format: .number)
            default:
                Button("OK") {  }
            }
        }
        .animation(.default.speed(1.4), value: changeResolutionTitle)
        .animation(.default.speed(1.4), value: isPresented)
        .onAppear {
            getQuantity()
        }
        .onChange(of: isPresented) { _, new in
            if !new { currentlyEditingField = nil }
        }
        .onChange(of: result.resolutionTitle) { oldValue, newValue in
            getQuantity()
        }
        .onChange(of: hasQuantity) { oldValue, newValue in
            if newValue {
                getQuantity()
            } else {
                result.extractedQuantity = nil
            }
        }
    }

    func getQuantity() {
        let string = result.resolutionTitle
        let pattern = "\\d+" // Match one or more digits

        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(string.startIndex..., in: string)
            if let match = regex.firstMatch(in: string, range: range) {
                let matchRange = match.range
                if let number = Int(string[Range(matchRange, in: string)!]) {
                    if hasQuantity {
                        result.extractedQuantity = number
                    }
                    quantityRange = matchRange
                }
            } else {
                if hasQuantity {
                    result.extractedQuantity = nil
                    hasQuantity = false
                }
                quantityRange = nil
            }
        }
    }

    private var difficultyPickerLabel: some View {
        HStack {
            Text("Difficulty")
                .bold()
                .foregroundStyle(difficultyColor)

            Text(result.difficulty.rawValue)
                .foregroundStyle(difficultyColor)
        }
        .padding()
        .background(difficultyColor.opacity(0.2), in: .capsule)
        .frame(width: 250)
    }

    private var difficultyColor: Color {
        switch result.difficulty {
        case .easy:
                .green
        case .medium:
                .orange
        case .hard:
                .red
        }
    }
}

fileprivate struct MenuAction {
    let title: String
    let image: UIImage?
    let action: () -> Void
}

fileprivate struct TextViewWrapper: UIViewRepresentable {
    let text: AttributedString
    let hasQuantity: Bool
    let quantityRange: NSRange?
    let actionsForURL: ((URL) -> [MenuAction])
    let textDidChange: (UITextView) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.delegate = context.coordinator
        textView.linkTextAttributes = [:]
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(text))

        // Set font size and bold style for the entire text
        let font = UIFont.boldSystemFont(ofSize: 50)
        attributedText.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedText.length))

        // Center align the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))

        // Customize link appearance to be gray and underlined
        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length)) { value, range, _ in
            if value != nil {
                attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: range)
                attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }

        // Highlight quantity if hasQuantity is true and we have a valid range
        if hasQuantity, let quantityRange = quantityRange {
            // Find the range of the resolutionTitle link
            attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length)) { value, range, _ in
                if let url = value as? URL, url.absoluteString == EditField.resolutionTitle.rawValue {
                    // Calculate the offset within the link text
                    let highlightRange = NSRange(location: range.location + quantityRange.location, length: quantityRange.length)
                    attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: highlightRange)
                    // attributedText.addAttribute(.backgroundColor, value: UIColor.systemBlue.withAlphaComponent(0.2), range: highlightRange)
                }
            }
        }

        uiView.attributedText = attributedText
        context.coordinator.actionsForURL = actionsForURL

        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        .init(actionsForURL: actionsForURL, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UITextViewDelegate, UITextDragDelegate {
        var actionsForURL: ((URL) -> [MenuAction])
        let textDidChange: (UITextView) -> Void

        init(
            actionsForURL: @escaping (URL) -> [MenuAction],
            textDidChange: @escaping (UITextView) -> Void
        ) {
            self.actionsForURL = actionsForURL
            self.textDidChange = textDidChange
        }

        func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
            guard case let .link(url) = textItem.content else { return nil }

            if url.absoluteString ==
                EditField.frequencyType.rawValue {
                return nil
            }

            return actionsForURL(url).map { action in
                UIAction(
                    title: action.title,
                    image: action.image
                ) { _ in
                    action.action()
                }
            }.first
        }

        func textView(_ textView: UITextView, menuConfigurationFor textItem: UITextItem, defaultMenu: UIMenu) -> UITextItem.MenuConfiguration? {
            guard case let .link(url) = textItem.content else { return nil }
            return .init(
                preview: nil,
                menu: UIMenu(
                    children: actionsForURL(url).map { action in
                        UIAction(
                            title: action.title,
                            image: action.image
                        ) { _ in
                            action.action()
                        }
                    })
            )
        }

        func textViewDidChange(_ textView: UITextView) {
            self.textDidChange(textView)
        }
    }
}

#Preview {
    @Previewable @State var res = ResolutionEditorResult()
    ResolutionEditor(
        result: $res,
        hasQuantity: .constant(true)
    )
}
