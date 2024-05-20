#!/bin/sh

APP=gron.awk
SITE="xonixx/gron.awk"

# CREATE DIRECTORIES
if [ -z "$APP" ]; then exit 1; fi
mkdir -p "/opt/$APP/tmp" && cd "/opt/$APP/tmp" || exit 1

# ADD THE REMOVER
echo "#!/bin/sh
rm -f /usr/local/bin/$APP
rm -R -f /opt/$APP" > "/opt/$APP/remove"
chmod a+x "/opt/$APP/remove"

# DOWNLOAD AND PREPARE THE APP
# $version is also used for updates

version=$(curl -Ls https://api.github.com/repos/"$SITE"/releases/latest | jq '.' | sed 's/[()",{}]/ /g; s/ /\n/g' | grep 'https.*.gron.awk.*tarball' | head -1)
wget "$version" -O download.tar.gz
echo "$version" > "/opt/$APP/version"
tar fx ./*tar*
cd ..
mv --backup=t ./tmp/*/* ./
rm -R -f ./tmp
chmod a+x "/opt/$APP/$APP"

# LINK
ln -s "/opt/$APP/gron.awk" "/usr/local/bin/$APP"

# SCRIPT TO UPDATE THE PROGRAM
cat >> "/opt/$APP/AM-updater" << 'EOF'
#!/bin/sh
APP=gron.awk
SITE="xonixx/gron.awk"
version0=$(cat /opt/$APP/version)
version=$(curl -Ls https://api.github.com/repos/"$SITE"/releases/latest | jq '.' | sed 's/[()",{}]/ /g; s/ /\n/g' | grep 'https.*.gron.awk.*tarball' | head -1)
if [ "$version" = "$version0" ]; then
	echo "Update not needed!" && exit 0
else
	notify-send "A new version of $APP is available, please wait"
	mkdir "/opt/$APP/tmp"
	cd "/opt/$APP/tmp" || exit 1
	wget "$version" -O download.tar.gz
	tar fx ./*tar*
	cd ..
	mv --backup=t ./tmp/*/* ./
	echo "$version" > ./version
	rm -R -f ./tmp ./*~
	chmod a+x "/opt/$APP/gron.awk"
	notify-send "$APP is updated!"
fi
EOF
chmod a+x "/opt/$APP/AM-updater"
