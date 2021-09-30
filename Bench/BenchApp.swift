// Copyright (c) 2021 - present Marin Todorov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI

@main
struct BenchApp: App {
  @State var duration: TimeInterval = 0
  @State var actor = ActorBench()
  @State var lock = Lock()
  @State var queue = Queue()

  struct DurationButton: View {
    let title: String
    @Binding var duration: TimeInterval
    let block: () async -> Void

    var body: some View {
      Button {
        Task {
          let start = Date().timeIntervalSinceReferenceDate
          for _ in 0...10_000 {
            await block()
          }
          duration = Date().timeIntervalSinceReferenceDate - start
        }
      } label: {
        HStack {
          Spacer()
          Text(title)
          Spacer()
        }
      }
      .buttonStyle(.borderedProminent)
    }
  }
  
  var body: some Scene {
    WindowGroup {
      VStack(spacing: 10) {
        Text(String(format: "Duration: %.3fs", duration))
          .padding()

        HStack { Spacer() }

        DurationButton(title: "Actor", duration: $duration) {
          await actor.increment()
        }

        DurationButton(title: "DispatchQueue", duration: $duration) {
          queue.increment()
        }

        DurationButton(title: "Lock", duration: $duration) {
          lock.increment()
        }
      }
      .padding()
    }
  }
}
