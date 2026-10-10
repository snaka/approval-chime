import AppKit

let version = "0.1.0"

if CommandLine.arguments.dropFirst().contains("--version") {
    print("approval-chime \(version)")
    exit(0)
}

// defaults write approval-chime delay -float 5
// defaults write approval-chime sound /System/Library/Sounds/Ping.aiff
let defaults = UserDefaults.standard
let delay = defaults.object(forKey: "delay") as? Double ?? 3
let soundPath = defaults.string(forKey: "sound") ?? "/System/Library/Sounds/Glass.aiff"
guard let sound = NSSound(contentsOfFile: soundPath, byReference: true) else {
    FileHandle.standardError.write("approval-chime: cannot load sound \(soundPath)\n".data(using: .utf8)!)
    exit(1)
}
let repeatEvery: TimeInterval = 3

setvbuf(stdout, nil, _IOLBF, 0)
print("approval-chime \(version): watching for 1Password approval dialogs")

func dialogVisible() -> Bool {
    let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
    return list.contains { w in
        let bounds = w[kCGWindowBounds as String] as? [String: Any] ?? [:]
        return isApprovalDialog(WindowInfo(
            owner: w[kCGWindowOwnerName as String] as? String ?? "",
            layer: w[kCGWindowLayer as String] as? Int ?? 0,
            width: bounds["Width"] as? Double ?? 0,
            height: bounds["Height"] as? Double ?? 0))
    }
}

var shownSince: Date?
var lastChime = Date.distantPast

Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
    let now = Date()
    guard dialogVisible() else {
        if shownSince != nil { print("\(now.formatted()) dialog closed") }
        shownSince = nil
        return
    }
    if shownSince == nil { print("\(now.formatted()) dialog shown") }
    let since = shownSince ?? now
    shownSince = since
    if now.timeIntervalSince(since) >= delay, now.timeIntervalSince(lastChime) >= repeatEvery {
        sound.stop()
        sound.play()
        lastChime = now
    }
}
RunLoop.main.run()
