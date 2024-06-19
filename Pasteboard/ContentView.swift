//
//  ContentView.swift
//  Pasteboard
//
//  Created by Eche on 18/06/2024.
//

import SwiftUI
import Cocoa
import Foundation

var store: [String] = []

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Paste Board Manager")
                .font(.largeTitle)
                .padding()
            .padding()
            Table(dataBuilder()) {
                TableColumn("S/N") { item in
                    Text("\(item.column1 + 1)")
                }
                TableColumn("content", value: \.column2)
                TableColumn("Action") { item in
                    Button("Copy") {
                        print("Copied")
                    }
                }
            }
        }
        .padding()
    }
}

struct Item: Identifiable {
    let id = UUID()
    let column1: Int
    let column2: String
}

func readSysPb() -> String {
    var content = ""
    if let str = NSPasteboard.general.string(forType: .string) {
        content = str
    }

    return content
}

func dataBuilder() -> Array<Item> {
    var data: [Item] = []
    var isPastebinChanged: Bool
    
    isPastebinChanged = store.last?.lowercased() != readSysPb().lowercased()
    
    if (!readSysPb().isEmpty && isPastebinChanged) {
        store.append(readSysPb())
    }
    
    for (index, item) in store.reversed().enumerated() {
        data.append(Item(column1: index, column2: item))
    }
    
    return data
}

#Preview {
    ContentView()
}
