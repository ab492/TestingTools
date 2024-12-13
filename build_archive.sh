#!/bin/bash

xcodebuild archive \
  -project TestingTools.xcodeproj \
  -scheme TestingToolsExtension \
  -sdk macosx \
  -configuration Release \
  -derivedDataPath DerivedData \
  -archivePath DerivedData/Archive/TestingTools
