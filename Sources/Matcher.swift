// What a 1Password approval dialog looks like from the window list, without
// Screen Recording permission: owner, layer and size are readable, titles are not.
struct WindowInfo {
    var owner: String
    var layer: Int
    var width: Double
    var height: Double
}

// Measured on 1Password 8: the dialog that git signing, ssh, `op` and a
// local-env-file `.env` all raise is a 400-wide window at layer 101 (325 tall,
// 370 when it also unlocks the app). Quick Access shares layer 101 but is 550
// wide, and the main window sits at layer 0.
// ponytail: matches 1Password's current dialog geometry; if a 1Password update
// changes it, the chime goes silent. Re-measure and adjust the width here.
func isApprovalDialog(_ w: WindowInfo) -> Bool {
    w.owner == "1Password" && w.layer == 101 && abs(w.width - 400) <= 40
}
