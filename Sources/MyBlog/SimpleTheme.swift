//  Created by dasdom on 19.07.20.
//  
//

import Publish

extension Theme {
  static var simple: Self {
    Theme(htmlFactory: SimpleHTMLFactory(), resourcePaths: ["Resources/Simple/styles.css"])
  }
}
