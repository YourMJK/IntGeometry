#!/bin/bash

outputPath=docs
hostingBasePath=IntGeometry
tempDerivedDataPath=.derivedData

cd $(dirname "$0")
xcodebuild docbuild -scheme IntGeometry -destination "platform=macOS" -derivedDataPath "$tempDerivedDataPath" || exit 1
doccarchive=$(find "$tempDerivedDataPath" -type d -name "*.doccarchive") || exit 1
$(xcrun --find docc) process-archive transform-for-static-hosting "$doccarchive" --output-path "$outputPath" --hosting-base-path "$hostingBasePath"
rm -r "$tempDerivedDataPath"

echo "Sorting JSON keys..."
find "$outputPath"/data "$outputPath"/index -name "*.json" -print0 | while read -d $'\0' file
do
	file_new="${file}_new"
	jq --sort-keys --compact-output . "$file" > "$file_new"
	#jq --sort-keys --compact-output . "$file" | perl -0777 -pe 's{"(?:\\.|.)*?"(\s*:)?}{ $1 ? $& : $& =~ s{/}{\\/}gr }ge' > "$file_new"  # Keep "\/" escaped forward slash in string values
	mv "$file_new" "$file"
done
