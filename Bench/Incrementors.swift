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

import Foundation

// Actor incrementor
actor ActorBench {
  private var counter = 0.0

  func increment() {
    counter += 1.2
  }
}

// Lock incrementor
class Lock {
  private var lock: os_unfair_lock_t // os_unfair_lock *lock;
  private var counter = 0.0

  init() {
    lock = UnsafeMutablePointer<os_unfair_lock_s>.allocate(capacity: 1) // lock = malloc(sizeof(os_unfair_lock));
    lock.initialize(to: os_unfair_lock()) // memset(lock, 0, sizeof(os_unfair_lock));
  }

  deinit {
    lock.deallocate() // free(lock);
  }

  func increment() {
    os_unfair_lock_lock(lock)
    counter += 1.2
    os_unfair_lock_unlock(lock)
  }
}

// Queue incrementor
class Queue {
  private var counter = 0.0
  private let queue = DispatchQueue(label: "counter")

  func increment() {
    queue.sync {
      counter += 1.2
    }
  }
}
