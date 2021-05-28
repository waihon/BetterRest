//
//  ContentView.swift
//  BetterRest
//
//  Created by Waihon Yew on 26/05/2021.
//

import SwiftUI
import CoreML

struct ContentView: View {
  @State private var wakeUp = defaultWakeTime
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 0
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("When do you want to wake up?")
          .font(.headline)) {
          DatePicker("Please enter a time",
                     selection: $wakeUp,
                     displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
        }
        
        Section(header: Text("Desired amount of sleep")
          .font(.headline)) {
          Stepper(value: $sleepAmount,
                  in: 4...12,
                  step: 0.25) {
            Text("\(sleepAmount, specifier: "%g") hours")
          }
        }
               
         Section(header: Text("Daily coffee intake")
          .font(.headline)) {
            Picker("Please select daily coffee intake",
                   selection: $coffeeAmount) {
              ForEach(1 ..< 21) { number in
                if number == 1 {
                  Text("1 cup")
                } else {
                  Text("\(number) cups")
                }
              }
            }
        }
        
        Section(header: Text("Your ideal bedtime is")
          .font(.headline)) {
          Text(bedtime)
            .font(.largeTitle)
        }
      }
      .navigationBarTitle("BetterRest")
    }
  }
  
  static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
  }

  var bedtime: String {
    let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    let hour = (components.hour ?? 0) * 60 * 60
    let minute = (components.minute ?? 0) * 60
    let coffee = coffeeAmount + 1
    
    do {
      // https://www.hackingwithswift.com/forums/swiftui/betterrest-init-deprecated/2593
      let model: SleepCalculator = try SleepCalculator(configuration: MLModelConfiguration())
      let prediction = try model.prediction(wake: Double(hour + minute),
                                            estimatedSleep: sleepAmount,
                                            coffee: Double(coffee))
      let sleepTime = wakeUp - prediction.actualSleep
      
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      
      return formatter.string(from: sleepTime)
    } catch {
      return "Sorry, there was a problem calculating your bedtime."
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
