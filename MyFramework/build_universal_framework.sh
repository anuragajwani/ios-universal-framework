#! /bin/sh

# create folder where we place built frameworks
mkdir build

####################### Create devices framework #############################

#build framework for devices
xcodebuild clean build \
  -project MyFramework.xcodeproj \
  -scheme MyFramework \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath derived_data \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# create folder to store compiled framework for simulator
mkdir build/devices

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphoneos/MyFramework.framework build/devices

# build framework for simulators
xcodebuild clean build \
  -project MyFramework.xcodeproj \
  -scheme MyFramework \
  -configuration Release \
  -sdk iphonesimulator \
  -derivedDataPath derived_data \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

####################### Create simulator framework #############################

# create folder to store compiled framework for simulator
mkdir build/simulator

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphonesimulator/MyFramework.framework build/simulator

####################### Create universal framework #############################

# create folder to store compiled universal framework
mkdir build/universal

# copy device framework into universal folder
cp -r build/devices/MyFramework.framework build/universal/

# create framework binary compatible with simulators and devices, and replace binary in unviersal framework
lipo -create \
  build/simulator/MyFramework.framework/MyFramework \
  build/devices/MyFramework.framework/MyFramework \
  -output build/universal/MyFramework.framework/MyFramework

# copy simulator Swift public interface to universal framework
cp -r build/simulator/MyFramework.framework/Modules/MyFramework.swiftmodule/* build/universal/MyFramework.framework/Modules/MyFramework.swiftmodule
