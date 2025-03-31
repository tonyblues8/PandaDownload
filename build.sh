#!/bin/bash
#set -x
shellpath=`pwd`
[[ -f ./ytui ]] && echo "Deleting ytui..." && rm ./ytui
#c++ -std=c++1z -DEBUG hello.mm CustomButton.cpp ImageButton.cpp pic/imageon.cpp pic/imageoff.cpp pic/imageon1.cpp pic/imageoff1.cpp pic/yybj.cpp pic/yybj2.cpp pic/bubj.cpp pic/bubj2.cpp MacWindowUtils.mm -o ytui `/opt/wxWidgets-3.2.6/build-cocoa-debug/wx-config --cxxflags --libs` -I/opt/homebrew/opt/openssl@3/include -L/opt/homebrew/opt/openssl@3/lib /opt/homebrew/opt/openssl@3/lib/libssl.a /opt/homebrew/opt/openssl@3/lib/libcrypto.a -lcurl -framework Cocoa -Wno-deprecated-declarations
#c++ -std=c++1z hello.mm CustomButton.cpp ImageButton.cpp pic/imageon.cpp pic/imageoff.cpp pic/imageon1.cpp pic/imageoff1.cpp pic/yybj.cpp pic/yybj2.cpp pic/bubj.cpp pic/bubj2.cpp MacWindowUtils.mm -o ytui `/opt/wxWidgets-3.2.6/build-cocoa-debug/wx-config --cxxflags --libs` -I/opt/homebrew/opt/openssl@3/include -L/opt/homebrew/opt/openssl@3/lib /opt/homebrew/opt/openssl@3/lib/libssl.a /opt/homebrew/opt/openssl@3/lib/libcrypto.a -framework Cocoa -Wno-deprecated-declarations

#c++ -std=c++1z -Wno-deprecated-declarations -finput-charset=UTF-8 -fexec-charset=UTF-8 hello.cpp CustomButton.cpp ImageButton.cpp pic/imageon.cpp pic/imageoff.cpp pic/imageon1.cpp pic/imageoff1.cpp pic/yybj.cpp pic/yybj2.cpp pic/bubj.cpp pic/bubj2.cpp MacWindowUtils.mm -o ytui `/opt/wxWidgets-3.2.6/build-cocoa-debug/wx-config --cxxflags --libs` -I/opt/liblerc/include -L/opt/liblerc/lib /opt/liblerc/lib/libLerc.a -I/opt/homebrew/opt/jbigkit/include -L/opt/homebrew/opt/jbigkit/lib /opt/homebrew/opt/jbigkit/lib/libjbig.a -I/opt/homebrew/opt/pcre2/include -L/opt/homebrew/opt/pcre2/lib /opt/homebrew/opt/pcre2/lib/libpcre2-32.a -I/opt/libtiff/include -L/opt/libtiff/lib /opt/libtiff/lib/libtiff.a -I/opt/homebrew/opt/jpeg-turbo/include -I/opt/homebrew/opt/xz/include -I/opt/homebrew/opt/zstd/include -L/opt/homebrew/opt/jpeg-turbo/lib -L/opt/homebrew/opt/xz/lib -L/opt/homebrew/opt/zstd/lib /opt/homebrew/opt/zstd/lib/libzstd.a /opt/homebrew/opt/jpeg-turbo/lib/libjpeg.a /opt/homebrew/opt/xz/lib/liblzma.a -I/opt/homebrew/opt/openssl@3/include -L/opt/homebrew/opt/openssl@3/lib /opt/homebrew/opt/openssl@3/lib/libssl.a /opt/homebrew/opt/openssl@3/lib/libcrypto.a -I/opt/webp/include -L/opt/webp/lib /opt/webp/lib/libwebp.a /opt/webp/lib/libsharpyuv.a -framework Cocoa -Wno-deprecated-declarations

#c++ -std=c++1z -Wno-deprecated-declarations -finput-charset=UTF-8 -fexec-charset=UTF-8 hello.cpp CustomButton.cpp ImageButton.cpp pic/imageon.cpp pic/imageoff.cpp pic/imageon1.cpp pic/imageoff1.cpp pic/yybj.cpp pic/yybj2.cpp pic/bubj.cpp pic/bubj2.cpp -o ytui `/opt/wxWidgets-3.2.6/build-cocoa-debug/wx-config --cxxflags --libs` -I/opt/liblerc/include -L/opt/liblerc/lib /opt/liblerc/lib/libLerc.a -I/opt/homebrew/opt/jbigkit/include -L/opt/homebrew/opt/jbigkit/lib /opt/homebrew/opt/jbigkit/lib/libjbig.a -I/opt/homebrew/opt/pcre2/include -L/opt/homebrew/opt/pcre2/lib /opt/homebrew/opt/pcre2/lib/libpcre2-32.a -I/opt/libtiff/include -L/opt/libtiff/lib /opt/libtiff/lib/libtiff.a -I/opt/homebrew/opt/jpeg-turbo/include -I/opt/homebrew/opt/xz/include -I/opt/homebrew/opt/zstd/include -L/opt/homebrew/opt/jpeg-turbo/lib -L/opt/homebrew/opt/xz/lib -L/opt/homebrew/opt/zstd/lib /opt/homebrew/opt/zstd/lib/libzstd.a /opt/homebrew/opt/jpeg-turbo/lib/libjpeg.a /opt/homebrew/opt/xz/lib/liblzma.a -I/opt/homebrew/opt/openssl@3/include -L/opt/homebrew/opt/openssl@3/lib /opt/homebrew/opt/openssl@3/lib/libssl.a /opt/homebrew/opt/openssl@3/lib/libcrypto.a -I/opt/webp/include -L/opt/webp/lib /opt/webp/lib/libwebp.a /opt/webp/lib/libsharpyuv.a -framework Cocoa -Wno-deprecated-declarations

make clean && make && [[ -f ./ytui ]] || { echo "编译失败"; exit 1; }
chmod a+x ./ytui

echo "ytui编译成功"

[[ -d "/Applications/熊猫下载.app/Contents/MacOS" ]] && mv -f ./ytui "/Applications/熊猫下载.app/Contents/MacOS/" || { echo "拷贝失败"; exit 1; }
echo "mv ytui /Applications/熊猫下载.app/Contents/MacOS/ oKKKKK"

APP="/Applications/熊猫下载.app"
#FRAMEWORKS_PATH="$APP/Contents/Frameworks"
FRAMEWORKS_PATH="$APP/Contents/MacOS"
EXECUTABLE_PATH="$APP/Contents/MacOS/ytui"
EXECUTABLE_PATH2="$APP/Contents/Resources/zsprundir/bin/yt-dlp"
EXECUTABLE_PATH3="$APP/Contents/Resources/zsprundir/bin/ffmpeg"
EXECUTABLE_PATH4="$APP/Contents/Resources/zsprundir/bin/ffprobe"
EXECUTABLE_PATH5="$APP/Contents/Resources/zsprundir/bin/aria2c"

# 使用 otool 获取非系统依赖列表
echo "分析可执行文件的动态库依赖..."
#DEPENDENCIES=$(otool -L "$EXECUTABLE_PATH" | tail -n +2 | awk '/\// {print $1}' | grep -Ev '^/usr/lib|^/System/Library')
DEPENDENCIES=$(otool -L "$EXECUTABLE_PATH" | sed -n '2,$p' | awk '/\// {print $1}' | grep -Ev '^/usr/lib|^/System/Library')


if [ -z "$DEPENDENCIES" ]; then
    echo "没有非系统库依赖。"
    #exit 0
fi

echo "非系统库依赖列表:"
echo "$DEPENDENCIES"
for DEP in $DEPENDENCIES; do
    LIB_BASENAME=$(basename "$DEP")
    TARGET_PATH="$FRAMEWORKS_PATH/$LIB_BASENAME"
    if [ ! -f "$TARGET_PATH" ]; then
        echo "复制: $DEP -> $TARGET_PATH"
        cp "$DEP" "$FRAMEWORKS_PATH/"
        echo "更新动态库路径:$DEP -> @executable_path"
        install_name_tool -change "$DEP" @executable_path/$LIB_BASENAME "$EXECUTABLE_PATH"
    fi
done
echo "所有动态库处理完成"

# 定义变量
PASSWORD="yuxiang"
#LOCAL_FILE="$APP/Contents/MacOS/ytui"
REMOTE_USER="root"
REMOTE_HOST="192.168.3.5"
REMOTE_PATH="/home/ubuntu/zspcms/afile/opt/lampp/htdocs/tp/public/zspdl/ytui"
REMOTE_PATH2="/home/ubuntu/zspcms/afile/opt/lampp/htdocs/tp/public/zspdl/yt-dlp_mac"
REMOTE_PATH3="/home/ubuntu/zspcms/afile/opt/lampp/htdocs/tp/public/zspdl/ffmpeg"
REMOTE_PATH4="/home/ubuntu/zspcms/afile/opt/lampp/htdocs/tp/public/zspdl/ffprobe"
REMOTE_PATH5="/home/ubuntu/zspcms/afile/opt/lampp/htdocs/tp/public/zspdl/aria2c_mac"

# 使用 sshpass 和 scp 进行文件传输
sshpass -p "$PASSWORD" scp "$EXECUTABLE_PATH" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
# 等待 scp 传输完成
wait
echo "$EXECUTABLE_PATH 文件上传成功"
sshpass -p "$PASSWORD" scp "$EXECUTABLE_PATH2" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH2"
# 等待 scp 传输完成
wait
echo "$EXECUTABLE_PATH2 文件上传成功"
sshpass -p "$PASSWORD" scp "$EXECUTABLE_PATH3" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH3"
# 等待 scp 传输完成
wait
echo "$EXECUTABLE_PATH3 文件上传成功"
sshpass -p "$PASSWORD" scp "$EXECUTABLE_PATH4" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH4"
# 等待 scp 传输完成
wait
echo "$EXECUTABLE_PATH4 文件上传成功"
sshpass -p "$PASSWORD" scp "$EXECUTABLE_PATH5" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH5"
# 等待 scp 传输完成
wait
echo "$EXECUTABLE_PATH5 文件上传成功"
# 使用 sshpass 和 ssh 连接到远程服务器并执行命令
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" << EOF
    /usr/bin/md5sum $REMOTE_PATH | /usr/bin/awk '{printf "%s", \$1}' > /home/ubuntu/zspcms/afile/opt/lampp/htdocs/tp/public/zspdl/zspdlmd52
    exit
EOF

echo "文件传输和MD5计算完成"

cd /Users/tony/Desktop/installer
#./b.sh

cd $shellpath
#./ytui
#sudo mv zspdl /usr/bin/
#sudo chown root:wheel /usr/bin/zspdl
#sudo chmod -Rf 4755 /usr/bin/zspdl
#echo "#!/bin/bash" > app.sh
#echo "zspdl" >> app.sh
#chmod +x app.sh
#2app app.sh "周视频"