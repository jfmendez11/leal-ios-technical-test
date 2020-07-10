#!/bin/bash
set -e

function die { ( >&2 echo "$*"); exit 1; }

# CHECK PREREQUISITES
hash carthage 2>/dev/null || die "Can't find Carthage, please install from https://github.com/Carthage/Carthage"
hash xcodebuild 2>/dev/null || die "Can't find Xcode, please install from the App Store"

version=`carthage version | tail -n 1`
CARTHAGE_VERSION=( ${version//./ } )
version=`xcodebuild -version | head -n 1 | sed "s/Xcode //"`
XCODE_VERSION=( ${version//./ } )

[[ ${CARTHAGE_VERSION[0]} -gt 0 || ${CARTHAGE_VERSION[1]} -ge 35 ]] || die "Carthage should be at least version 0.35"
[[ ${XCODE_VERSION[0]} -gt 11 || ( ${XCODE_VERSION[0]} -eq 11 && ${XCODE_VERSION[1]} -ge 5 ) ]] || die "Xcode version should be at least 11.5.0. The current version is ${XCODE_VERSION}"

# SETUP
echo "ℹ️  Carthage update. This might take a while..."
carthage update

echo "✅  The project was set up, you can now open leal-ios-technical-test.xcodeproj"
