#!/bin/bash

#AWS_ACCESS_KEY_DEV="AKIAWWS7NHNAZPY6ULMN"
#AWS_SECRET_KEY_DEV="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"
#AWS_REGION_DEV="ap-south-1"
#S3_BUCKET_DEV="ahoy-develop"

workDir=$(pwd)

# Read the user input

echo "Enter the Build Format: 1.APK & IPA 2.APK 3.AppBundle 4.IPA 5.Windows 6.MacOS 7.Web"
read buildFormatValue
echo "Flavor : 1.QA 2.Dev 3.Staging 4.Production"
read flavorValue

iOSBuildType=1
getIOSBuildType() {
  if [ "$flavorValue" -eq 4 ]; then
    echo "Enter the iOS Build Type: 1.AdHoc 2.Distribution"
    read iOSBuildType
  else
    iOSBuildType=1
  fi
}

case $buildFormatValue in
1)
  getIOSBuildType
  ;;
2)
  buildFormat='apk'
  ;;
3)
  buildFormat='appbundle'
  ;;
4)
  buildFormat='ipa'
  getIOSBuildType
  ;;
5)
  buildFormat='windows'
  ;;
6)
  buildFormat='macos'
  ;;
7)
  buildFormat='web'
  ;;
esac

echo "Build Number :"
read buildNumber
echo "Release Type : 1.Release 2.Debug 3.Profile"
read releaseTypeValue

case $flavorValue in
1)
  flavor='qa'
  path='lib/main_qa.dart'
  flavorName='QA'
  macAppName=" $flavorName"
  flavorFileName='QA'
  ;;
2)
  flavor='development'
  path='lib/main_dev.dart'
  flavorName='Dev'
  macAppName=" $flavorName"
  flavorFileName='Dev'
  ;;
3)
  flavor='staging'
  path='lib/main_staging.dart'
  flavorName='Stage'
  macAppName=" $flavorName"
  flavorFileName='Stage'
  ;;
4)
  flavor='production'
  path='lib/main_prod.dart'
  flavorName='Prod'
  macAppName=''
  flavorFileName='Prod'
  ;;
esac

case $releaseTypeValue in
1)
  releaseType='release'
  macReleaseType='Release'
  ;;
2)
  releaseType='debug'
  macReleaseType='Debug'
  ;;
3)
  releaseType='profile'
  macReleaseType='Profile'
  ;;
esac

generateIPA() {
  if [ "$iOSBuildType" -eq 1 ]; then
    echo "flutter build ipa --$releaseType -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc"
    flutter build ipa --$releaseType -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc
  else
    echo "flutter build ipa --$releaseType -t $path --flavor $flavor --build-number $buildNumber"
    flutter build ipa --$releaseType -t $path --flavor $flavor --build-number $buildNumber
  fi
}

generateAPK() {
  echo "flutter build apk --$releaseType -t $path --flavor $flavor --build-number $buildNumber"
  flutter build apk --$releaseType -t $path --flavor $flavor --build-number $buildNumber
}

generateAppBundle() {
  echo "flutter build apk --$releaseType -t $path --flavor $flavor --build-number $buildNumber"
  flutter build apk --$releaseType -t $path --flavor $flavor --build-number $buildNumber
}

generateDMG() {

  notaryProfile="NOTARY_PROFILE"

  create-dmg \
    --volname "$1" \
    --window-pos 200 120 \
    --window-size 800 529 \
    --icon-size 130 \
    --text-size 14 \
    --icon "$2" 260 250 \
    --hide-extension "$2" \
    --app-drop-link 540 250 \
    --hdiutil-quiet \
    --codesign "$3" \
    --notarize "$notaryProfile" \
    "$4" \
    "$2"
}

case $buildFormatValue in
1)
  generateIPA
  generateAPK
  ;;
2)
  generateAPK
  ;;
3)
  generateAppBundle
  ;;
4)
  generateIPA
  ;;
5)
  echo "flutter build $buildFormat --$releaseType -t $path --build-number $buildNumber"
  flutter build $buildFormat --$releaseType -t $path --build-number $buildNumber
  ;;
6)
  echo "flutter build $buildFormat --$releaseType -t $path --flavor $flavor --build-number $buildNumber"
  flutter build $buildFormat --$releaseType -t $path --flavor $flavor --build-number $buildNumber

  signature="Developer ID Application: SYNERGY MARITIME PRIVATE LIMITED (KFG8MXBMYA)"


  macBuildDir="$workDir/build/Mac Builds"
  mkdir -p -- "$macBuildDir"
  #  hdiutil create -srcfolder "build/macos/Build/Products/$macReleaseType-$flavor" -volname "ThinkHub$macAppName" -ov -format UDZO "$macBuildDir/ThinkHub-$flavorName-$buildNumber"

  sourceDir="$workDir/build/macos/Build/Products/$macReleaseType-$flavor"
  # shellcheck disable=SC2164
  cd "$sourceDir"
  volumeName="Ahoy$macAppName"
  sourcePath="$volumeName.app"
  buildPath="$macBuildDir/Ahoy-$flavorName-$buildNumber-$(date +'%Y%m%d').dmg"

  rm -rf "$buildPath"

  echo "codesign -dv --verbose=4 $sourcePath"
  codesign -dv --verbose=4 "$sourcePath"
  codesign --deep --force --verify --verbose --options=runtime --sign "$signature" "$sourcePath"

  codesign -vvv --deep --strict "$sourcePath"

  #  xattr -cr $sourcePath

  generateDMG "$volumeName" "$sourcePath" "$signature" "$buildPath"

  echo "Stapling the notarization ticket"
  staple="$(xcrun stapler staple "$sourcePath")"
  if [ $? -eq 0 ]; then
    echo "$sourcePath is now notarized"
  else
    echo "$staple"
    echo "The notarization failed with error $?"
    exit 1
  fi

  generateDMG "$volumeName" "$sourcePath" "$signature" "$buildPath"

  codesign -dv --verbose=4 "$buildPath"

  cd "$workDir"
  ;;
7)
  echo "flutter build $buildFormat --$releaseType -t $path --build-number $buildNumber"
  flutter build $buildFormat --$releaseType -t $path --build-number $buildNumber
  
  webBuildDir="$workDir/build/Web Builds/$flavorFileName"
  webBuildOutput="$workDir/build/Web Builds/$flavorFileName/Ahoy-Web-$flavorFileName-$buildNumber-$(date +'%Y%m%d').zip"
  #  opFileName="/$flavorFileName/Ahoy-Web-$flavorFileName-$buildNumber-$(date +'%Y%m%d').zip"
  opFileName="Ahoy-Web-$flavorFileName-$buildNumber-$(date +'%Y%m%d').zip"

  mkdir -p -- "$webBuildDir"
  # shellcheck disable=SC2164
  cd "$workDir/build/web"
  case "$OSTYPE" in
  darwin*)
    echo "zip -r $webBuildOutput ./*"
    zip -r "$webBuildOutput" ./*
    ;;
  linux*)
    echo "zip -r $webBuildOutput ./*"
    zip -r "$webBuildOutput" ./*
    ;;
  msys*)
    echo "7z a -r $webBuildOutput ./*"
    7z a -r "$webBuildOutput" ./*
    ;;
  esac
  # shellcheck disable=SC2164
  cd "$workDir"
#  uploadToAmplify "$webBuildOutput" "$opFileName"
  ;;

esac
#
#if [ "$buildFormatValue" -eq 3 ]; then
#  echo "flutter build $buildFormat --$releaseType -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc"
#  flutter build $buildFormat --$releaseType -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc
#else
#  echo "flutter build $buildFormat --$releaseType -t $path --flavor $flavor --build-number $buildNumber"
#  flutter build $buildFormat --$releaseType -t $path --flavor $flavor --build-number $buildNumber
#fi


echo "Press Any Key To Exit"
read key
