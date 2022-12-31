#!/bin/sh
set -e
wget -q --show-progress http://reaper.fm/"$(wget -qO- http://reaper.fm/download.php|grep _linux_x86_64.tar.xz|cut -d '"' -f2)"
tar fx reaper*_linux_x86_64.tar.xz
REAPER_VER="$(wget -qO- http://reaper.fm| grep VERSION|cut -d '>' -f2|cut -d ':' -f1|sed 's/VERSION //g')"
cp -r reaper*_linux_x86_64/REAPER cockos-reaper-"$REAPER_VER".AppDir
wget -q --show-progress https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
cat <<EOF |tee cockos-reaper-"$REAPER_VER".AppDir/AppRun>/dev/null
#!/bin/sh
APP_DIR="\$(cd \$(dirname \$0);pwd)"
exec "\$APP_DIR/reaper"
EOF
chmod +x cockos-reaper-"$REAPER_VER".AppDir/AppRun
cat <<EOF |tee cockos-reaper-"$REAPER_VER".AppDir/cockos-reaper.desktop>/dev/null
[Desktop Entry]
Name=REAPER
Comment=REAPER is a complete digital audio production application for computers, offering a full multitrack audio and MIDI recording, editing, processing, mixing and mastering toolset.
Type=Application
Categories=AudioVideo;
Icon=main
EOF
cp cockos-reaper-"$REAPER_VER".AppDir/Resources/main.png cockos-reaper-"$REAPER_VER".AppDir/
wget -qO cockos-reaper-"$REAPER_VER".AppDir/libSwell.colortheme --show-progress https://stash.reaper.fm/41334/libSwell.colortheme
./appimagetool-x86_64.AppImage cockos-reaper-"$REAPER_VER".AppDir
rm -r appimagetool* *.AppDir reaper*_linux_x86_64.tar.xz reaper_linux_x86_64
mv REAPER-x86_64.AppImage cockos-reaper-"$REAPER_VER".AppImage