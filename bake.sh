#!/bin/zsh

# enter the project directory
cd ~/private_repo/sourcecode/BBP
# project name
App_Name="BBP"
# provision file
APP_Provision="0824-deep-night"





Folder_A="$PWD/../archives/$App_Name" 

last_file=0
max_file=0

for file_a in ${Folder_A}/*; do  
    temp_file=`basename $file_a` 
    if [[ temp_file -gt last_file ]]; then
     	max_file=$temp_file
     	last_file=$temp_file 
     	echo $max_file
     fi
done 

max_file=$(($max_file+1))
echo "new directory:$max_file created"

sleep 1

xcodebuild -workspace $App_Name.xcworkspace -sdk iphoneos -scheme $App_Name -configuration Release clean
xcodebuild -archivePath ./../archives/$App_Name/$max_file/$App_Name.xcarchive -workspace $App_Name.xcworkspace -sdk iphoneos -scheme $App_Name -configuration Release archive
xcodebuild -exportArchive -exportFormat IPA -archivePath ./../archives/$App_Name/$max_file/$App_Name.xcarchive -exportPath ./../archives/$App_Name/$max_file/$App_Name.ipa -exportProvisioningProfile $APP_Provision

cp -R ./../archives/$App_Name/$max_file/$App_Name.xcarchive/dSYMs/$App_Name.app.dSYM ./../archives/$App_Name/$max_file/$App_Name.app.dSYM