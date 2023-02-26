#!/bin/bash

outputPath=docs
hostingBasePath=IntGeometry
tempDerivedDataPath=.derivedData

cd $(dirname "$0")
xcodebuild docbuild -scheme IntGeometry -destination "platform=macOS" -derivedDataPath "$tempDerivedDataPath" || exit 1
doccarchive=$(find "$tempDerivedDataPath" -type d -name "*.doccarchive") || exit 1
$(xcrun --find docc) process-archive transform-for-static-hosting "$doccarchive" --output-path "$outputPath" --hosting-base-path "$hostingBasePath"
rm -r "$tempDerivedDataPath"
