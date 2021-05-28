//
//  ContentView.swift
//  BetterRest
//
//  Created by Waihon Yew on 26/05/2021.
//

import SwiftUI

struct ContentView: View {
  @State private var wakeUp = Date()
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 1
  
  var body: some View {
    NavigationView {
      VStack {
        Text("When do you want to wake up?")
          .font(.headline)
        DatePicker("Please enter a time",
                   selection: $wakeUp,
                   displayedComponents: .hourAndMinute)
          .labelsHidden()
        
        Text("Desired amount of sleep")
          .font(.headline)
        Stepper(value: $sleepAmount,
                in: 4...12,
                step: 0.25) {
          Text("\(sleepAmount, specifier: "%g") hours")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
