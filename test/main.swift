// Window geometry recorded from real 1Password 8 sessions.
// Run: swiftc -o /tmp/matcher-test Sources/Matcher.swift test/main.swift && /tmp/matcher-test
func check(_ name: String, _ w: WindowInfo, _ want: Bool) {
    let got = isApprovalDialog(w)
    print("\(got == want ? "ok  " : "FAIL") \(name)")
    if got != want { failures += 1 }
}
var failures = 0

check("approval dialog", WindowInfo(owner: "1Password", layer: 101, width: 400, height: 325), true)
check("approval dialog that also unlocks", WindowInfo(owner: "1Password", layer: 101, width: 400, height: 370), true)
check("Quick Access", WindowInfo(owner: "1Password", layer: 101, width: 550, height: 108), false)
check("main window", WindowInfo(owner: "1Password", layer: 0, width: 1154, height: 768), false)
check("same shape from another app", WindowInfo(owner: "Finder", layer: 101, width: 400, height: 325), false)

if failures > 0 { fatalError("\(failures) failed") }
print("all passed")
