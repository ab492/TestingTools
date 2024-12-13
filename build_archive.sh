#!/bin/bash

xcodebuild archive \
  -project TestingTools.xcodeproj \
  -scheme TestingToolsExtension \
  -sdk macosx \
  -configuration Release \
  -derivedDataPath DerivedData \
  -archivePath DerivedData/Archive/TestingTools

xcodebuild -exportArchive \
  -archivePath DerivedData/Archive/TestingTools.xcarchive \
  -exportOptionsPlist provisioning/App-Store.plist \
  -exportPath DerivedData/ipa
