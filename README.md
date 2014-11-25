# XcodeKit

This is a library I wrote that parses Xcode `.pbxproj` project files. While it doesn’t write the files out _exactly_ the way Xcode itself does (i.e. there are some indentation differences), it should come pretty close.

XcodeKit is an Objective-C port of [Ray Yamamoto Hilton](https://ray.sh/)’s wonderful [`xcoder`](https://github.com/rayh/xcoder) Ruby gem. Some portions are also borrowed from the CocoaPods [Xcodeproj gem](https://github.com/CocoaPods/Xcodeproj). Many thanks!

# Origin
This is a fork from
[PodBuilder/XcodeKit](https://github.com/PodBuilder/XcodeKit) which
generates the old format of `pbxproj(JSON)`. However, the JSON format is
deprecated by Cocoa while Xcode still uses this format. As Xcode also
recognizes the XML format of `pbxproj`, it seems to be unneccessary to
use custom apis to generate the JSON format of pbxproj.

The origin repo focuses on creating the `pbxproj` and this repo
modify the file.

Bugs fix.

The Apis are mostly same.

# pbxproj structure
The structure of pbxproj can be refered
[here](http://danwright.info/blog/2010/10/xcode-pbxproject-files/)

# Testing
The testing is not complete. I just test what I need: adding
buildSettings and runscript.

