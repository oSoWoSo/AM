#!/bin/sh

APP=SAMPLE
APPNAME=
FILENAMEBEGIN=

CATEGORIES=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -E -i categories | cut -c 17-)
ICONURL="https://appimage.github.io/database/$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -E -i icons | sed -n 2p | cut -c 5-)"
REPO=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -A1 "type: GitHub" | sed -n 2p | cut -c 10-)
FILENAMEEXTENTION=".AppImage"
URL=https://github.com/$REPO/releases/latest
COMMENT=$(curl https://api.github.com/repos/$REPO  2>/dev/null | grep description | sed 's/"description": "//' | sed 's/",//')

# CREATE THE FOLDER
mkdir /opt/$APP
cd /opt/$APP

# ADD THE REMOVER
echo '#!/bin/sh' >> /opt/$APP/remove
echo "rm -R -f /usr/share/applications/AM-$APP.desktop /opt/$APP /usr/local/bin/$APP" >> /opt/$APP/remove
chmod a+x /opt/$APP/remove

# DOWNLOAD THE APPIMAGE
mkdir tmp
cd ./tmp

wget https://github.com/$(wget https://github.com/$REPO/releases/latest -O - | egrep '/.*/.*/.*'$FILENAMEEXTENTION'' -o);

version=$(wget -q https://api.github.com/repos/$REPO/releases/latest -O - | grep -E tag_name | awk -F '[""]' '{print $4}')
echo "$version" >> /opt/$APP/version

cd ..
mv ./tmp/*mage ./$APP
chmod a+x /opt/$APP/$APP
rmdir ./tmp

# LINK
ln -s /opt/$APP/$APP /usr/local/bin/$APP

# SCRIPT TO UPDATE THE PROGRAM
cat >> /opt/$APP/AM-updater << 'EOF'
#!/usr/bin/env bash
APP=SAMPLE
version0=$(cat /opt/$APP/version)
url=https://github.com/FUNCTION2/releases/latest
if curl -L -s $url | grep -ioF "$version0"; then
  echo "Update not needed!"
else
  notify-send "A new version of $APP is available, please wait"
  mkdir /opt/$APP/tmp
  cd /opt/$APP/tmp
  URL=https://github.com/FUNCTION2/releases/latest
  wget https://github.com/$(wget https://github.com/$FUNCTION2/releases/latest -O - | egrep '/.*/.*/.*'FUNCTION4'' -o);
  version=$(wget -q https://api.github.com/repos/FUNCTION2/releases/latest -O - | grep -E tag_name | awk -F '[""]' '{print $4}')
  cd ..
  if test -f ./tmp/*mage; then rm ./version
  fi
  echo $version >> ./version
  mv --backup=t ./tmp/*mage ./$APP
  chmod a+x /opt/$APP/$APP
  rm -R -f ./tmp ./*~
fi
EOF
sed -i s/FUNCTION2/$REPO/g /opt/$APP/AM-updater
sed -i s/FUNCTION4/$FILENAMEEXTENTION/g /opt/$APP/AM-updater
chmod a+x /opt/$APP/AM-updater

# LAUNCHER
rm /usr/share/applications/AM-$APP.desktop
echo "[Desktop Entry]
Name=$APPNAME
Exec=$APP
Icon=/opt/$APP/icons/$APP
Type=Application
Terminal=false
Categories=$CATEGORIES;
Comment=$COMMENT" >> /usr/share/applications/AM-$APP.desktop

# ICON
mkdir ./icons
wget $ICONURL -O /opt/$APP/icons/$APP

# CHANGE THE PERMISSIONS
currentuser=$(who | awk '{print $1}')
chown -R $currentuser /opt/$APP

# MESSAGE
echo '

 '$APPNAME' is provided by https://github.com/'$REPO'

'
