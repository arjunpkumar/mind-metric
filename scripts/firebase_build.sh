#!/bin/bash

# Read the user input

echo "Enter the Build Format: 1.APK & IPA 2.APK 3.AppBundle 4.IPA 5.Web"
read buildFormatValue
echo "Flavor : 1.QA 2.Dev 3.Staging 4.Production"
read flavorValue
echo "Clean workspace? : 1.Yes 2.No"
read cleanData

projectAndroidDev='projects/111740542/apps/1:111740542:android:c537521fccb2cf637b3a2f'
projectAndroidQA='projects/111740542/apps/1:111740542:android:c64421924c9a4b497b3a2f'
projectAndroidStaging='projects/111740542/apps/1:111740542:android:dcc5146102f31ef87b3a2f'
projectAndroidProd='projects/111740542/apps/1:111740542:android:835967ea2fc042257b3a2f'
projectIOSDev='projects/111740542/apps/1:111740542:ios:ea711a127ad8e0507b3a2f'
projectIOSQA='projects/111740542/apps/1:111740542:ios:60548da7fae496f17b3a2f'
projectIOSStaging='projects/111740542/apps/1:111740542:ios:a54b947018af80bc7b3a2f'
projectIOSProd='projects/111740542/apps/1:111740542:ios:41e86d5126ea7e0c7b3a2f'

gcloud auth revoke --all
workDir=$(pwd)
gcloud auth activate-service-account --key-file="$workDir/scripts/firebase/flutterbase.json"
authToken=$(gcloud auth print-access-token)
echo "$authToken"

case $buildFormatValue in
2)
  buildFormat='apk'
  ;;
3)
  buildFormat='appbundle'
  ;;
4)
  buildFormat='ipa'
  ;;
5)
  buildFormat='web'
  ;;
esac

apiResponse=""
getCurrentBuildNumber() {
  apiResponse=$(
    curl --location --request GET "https://firebaseappdistribution.googleapis.com/v1/$1/releases?pageSize=1" \
      --header 'x-origin: https://explorer.apis.google.com' \
      --header 'x-referer: https://explorer.apis.google.com' \
      --header "Authorization: Bearer $authToken"
  )
}

case $flavorValue in
1)
  flavor='qa'
  path='lib/main_qa.dart'
  flavorName='QA'
  getCurrentBuildNumber $projectAndroidQA
  ;;
2)
  flavor='development'
  path='lib/main_dev.dart'
  flavorName='Dev'
  getCurrentBuildNumber $projectAndroidDev
  ;;
3)
  flavor='staging'
  path='lib/main_staging.dart'
  flavorName='Staging'
  getCurrentBuildNumber $projectAndroidStaging
  ;;
4)
  flavor='production'
  path='lib/main_prod.dart'
  flavorName=''
  getCurrentBuildNumber $projectAndroidProd
  ;;
esac

currentBuildNumber=$(echo "$apiResponse" | jq '.releases[0].buildVersion')

buildNumber=$(($(echo ${currentBuildNumber##[!0-9]} | sed 's/"//g') + 1))

if [ "$cleanData" -eq 1 ]; then
  flutter clean
  flutter pub get
fi

case $buildFormatValue in
1)
  echo "flutter build ipa --release -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc"
  flutter build ipa --release -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc
  echo "flutter build apk --release -t $path --flavor $flavor --build-number $buildNumber"
  flutter build apk --release -t $path --flavor $flavor --build-number $buildNumber
  ;;
2)
  echo "flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber"
  flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber
  ;;
3)
  echo "flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber"
  flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber
  ;;
4)
  echo "flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc"
  flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc
  ;;
5)
  echo "flutter build $buildFormat --release -t $path"
  flutter build $buildFormat --release -t $path
  ;;
esac

uploadFile() {
  curl --location --request POST "https://firebaseappdistribution.googleapis.com/upload/v1/$2/releases:upload" \
    --progress-bar \
    -o output.txt \
    --header 'X-Goog-Upload-Protocol: raw' \
    --header "X-Goog-Upload-File-Name: $3" \
    --header "Authorization: Bearer $authToken" \
    --header 'Content-Type: application/vnd.android.package-archive' \
    --data-binary "@$1"

  rm output.txt
}

uploadApk() {
  binaryPath="$workDir/build/app/outputs/flutter-apk/app-$1-release.apk"
  echo "Uploading APK : $binaryPath"
  uploadFile "$binaryPath" "$2" 'flutterbase-release.apk'
}

uploadAppBundle() {
  binaryPath="$workDir/build/app/outputs/flutter-apk/app-$1-release.aab"
  echo "Uploading AppBundle : $binaryPath"
  uploadFile "$binaryPath" "$2" 'flutterbase-release.aab'
}

uploadIPA() {
  binaryPath="$workDir/build/ios/ipa/FlutterBase$1.ipa"
  echo "Uploading IPA : $binaryPath"
  uploadFile "$binaryPath" "$2" 'FlutterBase.ipa'
}

case $buildFormatValue in
1)
  case $flavorValue in
  1)
    uploadApk $flavor $projectAndroidQA
    uploadIPA " $flavorName" $projectIOSQA
    ;;
  2)
    uploadApk $flavor $projectAndroidDev
    uploadIPA " $flavorName" $projectIOSDev
    ;;
  3)
    uploadApk $flavor $projectAndroidStaging
    uploadIPA ' Stage' $projectIOSStaging
    ;;
  4)
    uploadApk $flavor $projectAndroidProd
    uploadIPA '' $projectIOSProd
    ;;
  esac

  ;;
2)
  case $flavorValue in
  1)
    uploadApk $flavor $projectAndroidQA
    ;;
  2)
    uploadApk $flavor $projectAndroidDev
    ;;
  3)
    uploadApk $flavor $projectAndroidStaging
    ;;
  4)
    uploadApk $flavor $projectAndroidProd
    ;;
  esac
  ;;
3)
  case $flavorValue in
  1)
    uploadAppBundle $flavor $projectAndroidQA
    ;;
  2)
    uploadAppBundle $flavor $projectAndroidDev
    ;;
  3)
    uploadAppBundle $flavor $projectAndroidStaging
    ;;
  4)
    uploadAppBundle $flavor $projectAndroidProd
    ;;
  esac
  ;;
4)
  case $flavorValue in
  1)
    uploadIPA $flavorName $projectIOSQA
    ;;
  2)
    uploadIPA $flavorName $projectIOSDev
    ;;
  3)
    uploadIPA $flavorName $projectIOSStaging
    ;;
  4)
    uploadIPA $flavorName $projectIOSProd
    ;;
  esac
  ;;
5)
  case $flavorValue in
  1)
    echo "Uploading Web"
    ;;
  2)
    echo "Uploading Web"
    ;;
  3)
    echo "Uploading Web"
    ;;
  4)
    echo "Uploading Web"
    ;;
  esac
  echo "flutter build $buildFormat --release -t $path"
  ;;
esac
