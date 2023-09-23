//
//  ContentView.swift
//  StringFormatter
//
//  Created by Zachary Burk on 9/23/23.
//

import SwiftUI

struct ConvertCaseOption {
    var title: String
    var conversion: (_ text: String) -> String
}

func uppercaseConversion (_ text: String) -> String {
    return text.capitalized
}

struct ContentView: View {
    var allConversionOptions: [ConvertCaseOption] = [
        ConvertCaseOption(title: "Plain Text", conversion: { (_ text: String) -> String in
            return NSAttributedString(string: text).string
        }),
        ConvertCaseOption(title: "Sentence case", conversion: { (_ text: String) -> String in
            let sentenceCase = text.prefix(1).capitalized + text.dropFirst().lowercased()
            return sentenceCase
        }),
        ConvertCaseOption(title: "lower case", conversion: { (_ text: String) -> String in
            return text.lowercased()
        }),
        ConvertCaseOption(title: "UPPER CASE", conversion: { (_ text: String) -> String in
            return text.uppercased()
        }),
        ConvertCaseOption(title: "Capitalized Case", conversion: { (_ text: String) -> String in
            return text.capitalized(with: .autoupdatingCurrent)
        }),
        ConvertCaseOption(title: "AlTeRnAtInG cAsE", conversion: { (_ text: String) -> String in
            var result = ""
            var shouldCapitalizeNext = true
            
            for character in text {
                if character == " " {
                    result.append(character)
                } else {
                    if shouldCapitalizeNext {
                        result.append(character.uppercased())
                    } else {
                        result.append(character.lowercased())
                    }
                    
                    shouldCapitalizeNext.toggle()
                }
            }

            return result
        })
    ]

    func readClipboard() -> String {
        return NSPasteboard.general.string(forType: .string) ?? ""
    }
    
    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    var body: some View {
        Group {
            ForEach(Array(allConversionOptions.enumerated()), id: \.element.title) { index, conversionOption in
                Button(conversionOption.title) {
                    copyToClipboard(conversionOption.conversion(readClipboard()))
                }
                .keyboardShortcut(KeyboardShortcut(KeyEquivalent(Character("\(index + 1)"))))
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
}

#Preview {
    ContentView()
}
