#!/bin/bash

xcodebuild test \
  -project TestingTools.xcodeproj \
  -scheme TestingToolsExtension \
  -destination 'platform=macOS,arch=x86_64' \
  CODE_SIGNING_ALLOWED=NO