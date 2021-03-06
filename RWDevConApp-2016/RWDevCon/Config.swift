/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

let SessionDataUpdatedNotification = "com.razeware.rwdevcon.notification.sessionDataUpdated"

class Config {

  class func applicationDocumentsDirectory() -> NSURL {
    let fileManager = FileManager.default

    if let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.razeware.rwdevcon") {
      return containerURL as NSURL
    }

    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [NSURL]
    return urls[0]
  }

  class func userDefaults() -> UserDefaults {
    return UserDefaults(suiteName: "group.com.razeware.rwdevcon") ?? UserDefaults.standard
  }

  class func favoriteSessions() -> [String: String] {
    if let favs = userDefaults().dictionary(forKey: "favoriteSessions") as? [String: String] {
      return favs
    }
    return [:]
  }
  
  class func nukeFavorites() {
    userDefaults().removeObject(forKey: "favoriteSessions")
    userDefaults().synchronize()
  }
  
  class func registerFavorite(session: Session) {
    var favs = favoriteSessions()
    favs[session.startDateTimeString] = session.identifier

    userDefaults().setValue((favs as NSDictionary), forKey: "favoriteSessions")
    userDefaults().synchronize()
  }

  class func unregisterFavorite(session: Session) {
    var favs = favoriteSessions()
    favs[session.startDateTimeString] = nil

    userDefaults().setValue((favs as NSDictionary), forKey: "favoriteSessions")
    userDefaults().synchronize()
  }
}
