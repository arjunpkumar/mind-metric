#!/bin/bash

workDir=$(pwd)
coverageDir="$workDir/coverage"
lcovFile="$coverageDir/lcov.info"
outputHtml="$coverageDir/output/index.html"
prevLcovFile="$coverageDir/prev_lcov.info"
newLcovFile="$coverageDir/new_lcov.info"

# Check if an argument (folder path) is provided
if [ -n "$1" ]; then
  testFolder="$1"

  # Backup existing lcov file before running tests
  if [ -f "$lcovFile" ]; then
    echo "Backing up existing coverage file..."
    cp "$lcovFile" "$prevLcovFile"
  fi

  echo "Running Unit Test Cases With Coverage on : $testFolder"
  flutter test --coverage "$testFolder"
  echo "Test Executed. Coverage Generated"

    # Move the new coverage file to a temporary location
    mv "$lcovFile" "$newLcovFile"

    # Merge previous coverage with new partial coverage
    if [ -f "$prevLcovFile" ]; then
        echo "Merging previous coverage with new test results..."
        lcov --rc branch_coverage=1 --add-tracefile "$prevLcovFile" --add-tracefile "$newLcovFile" --output-file "$lcovFile" --ignore-errors empty
        rm "$prevLcovFile" "$newLcovFile" # Clean up temp files
  else
        echo "No previous coverage found. Using new test coverage as base."
        mv "$newLcovFile" "$lcovFile"
  fi
else
  echo "Running Unit Test Cases With Coverage on : $workDir/test"
  flutter test --coverage
  echo "Test Executed. Coverage Generated"
fi

# Verify coverage file exists
if [ ! -f "$lcovFile" ]; then
  echo "Error: Coverage file not generated."
  exit 1
fi

filteredLCovFile="coverage_filtered.info"
lcov --remove "$lcovFile" '*/generated/*' '*/presentation/*' '*/app_database.g.dart' --output-file "$filteredLCovFile"

echo "Exporting Code Coverage to HTML :"
#genhtml --rc branch_coverage=1 "$lcovFile" -o "$coverageDir/output"
genhtml --rc branch_coverage=1 "$filteredLCovFile" -o "$coverageDir/output"

# Verify HTML file generation
if [ ! -f "$outputHtml" ]; then
  echo "Error: Coverage report not generated properly."
  exit 1
fi

echo "Export Completed. Opening Test Coverage in Browser"

# Determine the operating system
operating_system=$(uname -s)

# Open the index.html file in the default browser based on OS
case "$operating_system" in
Linux*)
  # Try xdg-open first (common in Linux desktop environments)
  if command -v xdg-open &>/dev/null; then
    xdg-open "$outputHtml"
  else
    # Fallback to sensible-browser, then common browsers if xdg-open is not available
    if command -v sensible-browser &>/dev/null; then
      sensible-browser "$outputHtml"
    elif command -v firefox &>/dev/null; then
      firefox "$outputHtml" "$@" &
    elif command -v google-chrome &>/dev/null; then
      google-chrome "$outputHtml" "$@" &
    elif command -v chromium-browser &>/dev/null; then
      chromium-browser "$outputHtml" "$@" &
    else
      echo "Error: No suitable browser found (xdg-open, sensible-browser, firefox, google-chrome, chromium-browser)"
      exit 1
    fi
  fi
  ;;
Darwin*) # macOS
  open "$outputHtml"
  ;;
CYGWIN* | MINGW* | MSYS*) # Windows
  start "$outputHtml"
  ;;
*)
  echo "Error: Unsupported operating system: $operating_system"
  exit 1
  ;;
esac

echo "Press Any Key To Exit"
read -r key
