import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    
    // Get the main screen size
    guard let screen = NSScreen.main else {
      super.awakeFromNib()
      return
    }
    
    let screenFrame = screen.visibleFrame
    
    // Calculate 85% of screen width and height
    let windowWidth = screenFrame.width * 0.85
    let windowHeight = screenFrame.height * 0.85
    
    // Center the window on screen
    let windowX = screenFrame.origin.x + (screenFrame.width - windowWidth) / 2
    let windowY = screenFrame.origin.y + (screenFrame.height - windowHeight) / 2
    
    let windowFrame = NSRect(x: windowX, y: windowY, width: windowWidth, height: windowHeight)
    
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
