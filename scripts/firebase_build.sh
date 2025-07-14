#!/bin/bash

workDir=$(pwd)

version=$(grep -E '^version:' pubspec.yaml | sed -E 's/version: ([0-9.]+).*/\1/')

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
  getIOSBuildType
  buildFormat='ipa'
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

echo "Clean workspace? : 1.Yes 2.No"
read cleanData

#Getting Firebase Access Token
if [ "$buildFormatValue" != "6" ] && [ "$buildFormatValue" != "5" ] && [ "$buildFormatValue" != "7" ]; then

  projectAndroidDev='projects/111740542/apps/1:111740542:android:c537521fccb2cf637b3a2f'
  projectAndroidQA='projects/111740542/apps/1:111740542:android:c64421924c9a4b497b3a2f'
  projectAndroidStage='projects/111740542/apps/1:111740542:android:dcc5146102f31ef87b3a2f'
  projectAndroidProd='projects/111740542/apps/1:111740542:android:835967ea2fc042257b3a2f'
  projectIOSDev='projects/111740542/apps/1:111740542:ios:ea711a127ad8e0507b3a2f'
  projectIOSQA='projects/111740542/apps/1:111740542:ios:60548da7fae496f17b3a2f'
  projectIOSStage='projects/111740542/apps/1:111740542:ios:a54b947018af80bc7b3a2f'
  projectIOSProd='projects/111740542/apps/1:111740542:ios:41e86d5126ea7e0c7b3a2f'

  gcloud auth revoke --all
  gcloud auth activate-service-account --key-file="$workDir/scripts/firebase/flutterbase.json"
  authToken=$(gcloud auth print-access-token)
  echo "$authToken"
fi

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
  macAppName=' $flavorName'
  if [ "$buildFormatValue" != "6" ] && [ "$buildFormatValue" != "5" ] && [ "$buildFormatValue" != "7" ]; then
    getCurrentBuildNumber $projectAndroidQA
  fi

#  if [ "$buildFormatValue" -eq "7" ]; then
#    AWS_ACCESS_KEY=$AWS_ACCESS_KEY_QA
#    AWS_SECRET_KEY=$AWS_SECRET_KEY_QA
#    AWS_REGION=$AWS_REGION_QA
#    S3_BUCKET=$S3_BUCKET_QA
#  fi

  ;;
2)
  flavor='development'
  path='lib/main_dev.dart'
  flavorName='Dev'
  macAppName=' $flavorName'
  if [ "$buildFormatValue" != "6" ] && [ "$buildFormatValue" != "5" ] && [ "$buildFormatValue" != "7" ]; then
    getCurrentBuildNumber $projectAndroidDev
  fi
#  if [ "$buildFormatValue" -eq "7" ]; then
#    AWS_ACCESS_KEY=$AWS_ACCESS_KEY_DEV
#    AWS_SECRET_KEY=$AWS_SECRET_KEY_DEV
#    AWS_REGION=$AWS_REGION_DEV
#    S3_BUCKET=$S3_BUCKET_DEV
#  fi
  ;;
3)
  flavor='staging'
  path='lib/main_staging.dart'
  flavorName='Stage'
  macAppName=' $flavorName'
  if [ "$buildFormatValue" != "6" ] && [ "$buildFormatValue" != "5" ] && [ "$buildFormatValue" != "7" ]; then
    getCurrentBuildNumber $projectAndroidStage
  fi
#  if [ "$buildFormatValue" -eq "7" ]; then
#    AWS_ACCESS_KEY=$AWS_ACCESS_KEY_STAGE
#    AWS_SECRET_KEY=$AWS_SECRET_KEY_STAGE
#    AWS_REGION=$AWS_REGION_STAGE
#    S3_BUCKET=$S3_BUCKET_STAGE
#  fi
  ;;
4)
  flavor='production'
  path='lib/main_prod.dart'
  flavorName='Prod'
  macAppName=''
  if [ "$buildFormatValue" != "6" ] && [ "$buildFormatValue" != "5" ] && [ "$buildFormatValue" != "7" ]; then
    getCurrentBuildNumber $projectAndroidProd
  fi
#  if [ "$buildFormatValue" -eq "7" ]; then
#    AWS_ACCESS_KEY=$AWS_ACCESS_KEY_PROD
#    AWS_SECRET_KEY=$AWS_SECRET_KEY_PROD
#    AWS_REGION=$AWS_REGION_PROD
#    S3_BUCKET=$S3_BUCKET_PROD
#  fi
  ;;
esac

generatePreSignedUrl() {
  # Set the expiration time in seconds

  FILE_NAME="$1"
  METHOD="$2"
  CONTENT_TYPE="$3"

  # $4 has values 0 or 1, 0 for Regular S3 Url & 1 for Build S3 Url
  if [ "$4" -eq 1 ]; then
    ACCESS_KEY=$THINKPALM_BUILD_AWS_ACCESS_KEY
    SECRET_KEY=$THINKPALM_BUILD_AWS_SECRET_KEY
    REGION=$THINKPALM_BUILD_AWS_REGION
    BUCKET=$THINKPALM_BUILD_S3_BUCKET
  else
    ACCESS_KEY=$AWS_ACCESS_KEY
    SECRET_KEY=$AWS_SECRET_KEY
    REGION=$AWS_REGION
    BUCKET=$S3_BUCKET
  fi

  # URL of the POST API
  #    URL="http://localhost:8080"
  URL="$S3_PRE_SIGNER"

  # Data to be sent in the POST request (if any)
  DATA="{
    \"access_key_id\":\"$ACCESS_KEY\",
    \"secret_access_key\":\"$SECRET_KEY\",
    \"region\":\"$REGION\",
    \"bucket\":\"$BUCKET\",
    \"content_type\":\"$CONTENT_TYPE\",
    \"object_key\":\"$FILE_NAME\",
    \"method\":\"$METHOD\"
    }"

  # Send the POST request and save the response to the variable
  RESPONSE=$(curl -X POST \
    -H "Content-Type: application/json" \
    -d "$DATA" \
    "$URL")

  echo "$RESPONSE"
}

# Function to check if a value is an integer
is_integer() {
  [[ $1 =~ ^[0-9]+$ ]]
}

if [ "$buildFormatValue" != "6" ] && [ "$buildFormatValue" != "5" ] && [ "$buildFormatValue" != "7" ]; then
  currentBuildNumber=$(echo "$apiResponse" | jq '.releases[0].buildVersion')
  buildNumber=$(($(echo ${currentBuildNumber##[!0-9]} | sed 's/"//g') + 1))
fi

if [ "$buildFormatValue" -eq "7" ]; then
  echo "Getting lastBuild"
  last_build_file="last_build"
  preSignedLastBuildUrl=$(generatePreSignedUrl "$last_build_file" "GET" "text/plain" 0)

  curl -o "$last_build_file" "$preSignedLastBuildUrl"
  echo "Last Build from S3 : $(<"$last_build_file")"

  if is_integer "$(<"$last_build_file")"; then
    currentBuildNumber=$(<"$last_build_file")
  else
    currentBuildNumber=0
  fi

  buildNumber=$(($(echo ${currentBuildNumber##[!0-9]} | sed 's/"//g') + 1))
fi

if [ "$cleanData" -eq 1 ]; then
  flutter clean
  flutter pub get
fi

generateIPA() {
  if [ "$iOSBuildType" -eq 1 ]; then
    echo "flutter build ipa --release -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc"
    flutter build ipa --release -t $path --flavor $flavor --build-number $buildNumber --export-method ad-hoc
  else
    echo "flutter build ipa --release -t $path --flavor $flavor --build-number $buildNumber"
    flutter build ipa --release -t $path --flavor $flavor --build-number $buildNumber
  fi
}

generateAPK() {
  echo "flutter build apk --release -t $path --flavor $flavor --build-number $buildNumber"
  flutter build apk --release -t $path --flavor $flavor --build-number $buildNumber
}

generateAppBundle() {
  echo "flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber"
  flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber
}

generateDMG() {

  notaryProfile="NOTARY_PROFILE_SYNERGY"

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
  echo "flutter build $buildFormat --release -t $path --build-number $buildNumber"
  flutter build $buildFormat --release -t $path --build-number $buildNumber
  ;;
6)
  echo "flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber"
  flutter build $buildFormat --release -t $path --flavor $flavor --build-number $buildNumber
  ;;
7)
  echo "flutter build $buildFormat --release -t $path --build-number $buildNumber"
  flutter build $buildFormat --release -t $path --build-number $buildNumber
  ;;
esac

uploadToFirebase() {
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

uploadToBrowserStack() {
  echo "Uploading $2 to Browser Stack: $1"
  curl -u "$BROWSER_STACK_USERNAME:$BROWSER_STACK_ACCOUNT_KEY" \
    -X POST "https://api-cloud.browserstack.com/app-live/upload" \
    --progress-bar \
    -o output.txt \
    -F "file=@$1"

  rm output.txt
}

uploadToS3() {

  echo "Uploading $3 to S3: $1"

  preSignedUrl=$(generatePreSignedUrl "$2" "PUT" "application/zip" 1)

  echo "PreSigned URL : $preSignedUrl"
  # Upload the file
  curl -X PUT "$preSignedUrl" \
    --upload-file "$1" \
    --progress-bar \
    -o output.txt \
    -H "Content-Type: application/zip"

  rm output.txt
}

uploadApk() {
  binaryPath="$workDir/build/app/outputs/flutter-apk/app-$1-release.apk"
  echo "Uploading APK to Firebase: $binaryPath"
  fileName="Maridock-$flavorName-$buildNumber-$(date +'%Y%m%d').apk"
  uploadToFirebase "$binaryPath" "$2" "$fileName"
  renamedFile="$workDir/build/app/outputs/flutter-apk/$fileName"
  cp "$binaryPath" "$renamedFile"
  uploadToBrowserStack "$renamedFile" "APK"
  key="Maridock/$flavorName/$version/Android/$fileName"
  uploadToS3 "$renamedFile" "$key" "APK"
}

uploadAppBundle() {
  binaryPath="$workDir/build/app/outputs/bundle/$1Release/app-$1-release.aab"
  echo "Uploading AppBundle to Firebase: $binaryPath"
  fileName="Maridock-$flavorName-$buildNumber-$(date +'%Y%m%d').aab"
  uploadToFirebase "$binaryPath" "$2" "$fileName"
  renamedFile="$workDir/build/app/outputs/flutter-apk/$fileName"
  mkdir -p "$workDir/build/app/outputs/flutter-apk"
  cp "$binaryPath" "$renamedFile"
  uploadToBrowserStack "$renamedFile" "AAB"
  key="Maridock/$flavorName/$version/Android/$fileName"
  uploadToS3 "$renamedFile" "$key" "AAB"
}

uploadIPA() {
  binaryPath="$workDir/build/ios/ipa/Maridock$1.ipa"
  echo "Uploading IPA to Firebase: $binaryPath"
  fileName="Maridock-$flavorName-$buildNumber-$(date +'%Y%m%d').ipa"
  uploadToFirebase "$binaryPath" "$2" "$fileName"
  renamedFile="$workDir/build/ios/ipa/$fileName"
  cp "$binaryPath" "$renamedFile"
  uploadToBrowserStack "$renamedFile" "IPA"
  key="Maridock/$flavorName/$version/iOS/$fileName"
  uploadToS3 "$renamedFile" "$key" "IPA"
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
    uploadApk $flavor $projectAndroidStage
    uploadIPA " $flavorName" $projectIOSStage
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
    uploadApk $flavor $projectAndroidStage
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
    uploadAppBundle $flavor $projectAndroidStage
    ;;
  4)
    uploadAppBundle $flavor $projectAndroidProd
    ;;
  esac
  ;;
4)
  case $flavorValue in
  1)
    uploadIPA " $flavorName" $projectIOSQA
    ;;
  2)
    uploadIPA " $flavorName" $projectIOSDev
    ;;
  3)
    uploadIPA " $flavorName" $projectIOSStage
    ;;
  4)
    uploadIPA '' $projectIOSProd
    ;;
  esac
  ;;

7)

  webBuildDir="$workDir/build/Web Builds/$flavorName"
  webBuildOutput="$workDir/build/Web Builds/$flavorName/Maridock-Web-$flavorName-$buildNumber-$(date +'%Y%m%d').zip"
  #  opFileName="/$flavorName/Maridock-Web-$flavorName-$buildNumber-$(date +'%Y%m%d').zip"
  opFileName="Maridock-Web-$flavorName-$buildNumber-$(date +'%Y%m%d').zip"

  mkdir -p -- "$webBuildDir"
  # shellcheck disable=SC2164
  cd "$workDir/build/web"
  case "$OSTYPE" in
  darwin*)
    echo "zip -r $webBuildOutput ./*"
    zip -r "$webBuildOutput" ./*
    ;;
  linux*)
    echo "zip -r $webBuildOutput./*"
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

echo "Press Any Key To Exit"
read key
