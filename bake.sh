#!/bin/zsh

# enter the project directory
cd ~/private_repo/sourcecode/BBP
# project name
App_Name="BBP"
# provision file
APP_Provision="0824-deep-night"

#蒲公英ukey
uKey="你的蒲公英uKey"

#蒲公英apiKey
apiKey="你的蒲公英apiKey"




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



function convert2JSON {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop`
    echo ${temp##*|}
}

json=`curl -F "file=@./../archives/$App_Name/$max_file/$App_Name.ipa" -F "uKey=$uKey" -F "_api_key=$apiKey" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload`

prop='appShortcutUrl'

downloadPath=`convert2JSON`

downloadLink="http://www.pgyer.com/$downloadPath"

open $downloadLink