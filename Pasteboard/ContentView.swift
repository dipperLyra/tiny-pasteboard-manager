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
    @State private var items: [Item] = dataBuilder()
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("Paste Board Manager")
                .font(.largeTitle)
                .padding()
            Table(items) {
                TableColumn("S/N") { item in
                    Text("\(item.column1 + 1)")
                }
                TableColumn("content", value: \.column2)
                TableColumn("Action") { item in
                    Button("Copy") {
                        writeSysPb(item.column2)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            checkPasteboard()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func checkPasteboard() {
        let curPbContent = readSysPb()
        let isPbContentChanged = store.last?.lowercased() != curPbContent.lowercased()
        
        if !curPbContent.isEmpty && isPbContentChanged {
            store.append(curPbContent)
            items = dataBuilder()
        }
    }
    
    func readSysPb() -> String {
        var content = ""
        if let str = NSPasteboard.general.string(forType: .string) {
            content = str
        }

        return content
    }
    
    func writeSysPb(_ content: String) {
        let pastboard = NSPasteboard.general
        pastboard.clearContents()
        pastboard.setString(content, forType: .string)
    }
}

struct Item: Identifiable {
    let id = UUID()
    let column1: Int
    let column2: String
}

func dataBuilder() -> Array<Item> {
    var data: [Item] = []
    
    for (index, item) in store.reversed().enumerated() {
        data.append(Item(column1: index, column2: item))
    }
    
    return data
}

#Preview {
    ContentView()
}
