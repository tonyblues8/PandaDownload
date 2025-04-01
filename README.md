# PandaDownload
<!-- MANPAGE: BEGIN EXCLUDED SECTION -->
<div align="center">

[![YT-DLP](https://raw.githubusercontent.com/yt-dlp/yt-dlp/master/.github/banner.svg)](#readme)

[![Pandadownload](https://raw.githubusercontent.com/tonyblues8/PandaDownload/refs/heads/main/pic/jp.png)](#readme)

</div>


本人运行环境：mac min M4 MacOS 15.3.2

实现了<a href="https://github.com/yt-dlp/yt-dlp">yt-dlp</a>图形界面功能

# 增强功能:

1:aria2c加速；

2:下载后添加字幕和片头；

3:H265编码；


# 相关依赖：

## <a href="https://www.python.org/">python3.10</a>

## <a href="https://github.com/yt-dlp/yt-dlp">yt-dlp</a>

## <a href="https://github.com/FFmpeg/FFmpeg">ffmpeg</a>

## <a href="https://github.com/aria2/aria2">aria2c</a>


以上依赖无需单独安装，都已经集成在本安装包内。

# 编译依赖如下:

#C++

CXXFLAGS += -std=c++17 -Wno-deprecated-declarations -finput-charset=UTF-8 -fexec-charset=UTF-8 \
            $(shell /opt/wxWidgets-3.2.6/build-cocoa-debug/wx-config --cxxflags) \
            -I/opt/homebrew/opt/xz/include \
            -I/opt/homebrew/opt/zstd/include \
            -I/opt/homebrew/opt/jbigkit/include \
            -I/opt/homebrew/opt/pcre2/include \
            -I/opt/liblerc/include \
            -I/opt/libtiff/include \
            -I/opt/homebrew/opt/jpeg-turbo/include \
            -I/opt/webp/include \
            -I/opt/homebrew/opt/openssl@3/include

#

LDFLAGS += $(shell /opt/wxWidgets-3.2.6/build-cocoa-debug/wx-config --libs) \
           -L/opt/homebrew/opt/xz/lib \
           -L/opt/homebrew/opt/zstd/lib \
           -L/opt/homebrew/opt/pcre2/lib \
           -L/opt/homebrew/opt/jbigkit/lib \
           -L/opt/liblerc/lib \
           -L/opt/libtiff/lib \
           -L/opt/homebrew/opt/jpeg-turbo/lib \
           -L/opt/homebrew/opt/openssl@3/lib \
           -L/opt/webp/lib


#MacOS

ifeq ($(shell uname), Darwin)

    LDFLAGS += -framework Cocoa \
    -framework QuartzCore \
    -framework AudioToolbox \
    -framework IOKit \
    -framework Security \
    -framework OpenGL \
     -framework Carbon

endif


LIBS += /opt/homebrew/opt/xz/lib/liblzma.a \
        /opt/homebrew/opt/zstd/lib/libzstd.a \
        /opt/liblerc/lib/libLerc.a \
        /opt/homebrew/opt/pcre2/lib/libpcre2-32.a \
        /opt/homebrew/opt/jpeg-turbo/lib/libjpeg.a \
        /opt/homebrew/opt/jbigkit/lib/libjbig.a \
        /opt/homebrew/opt/openssl@3/lib/libssl.a \
        /opt/homebrew/opt/openssl@3/lib/libcrypto.a \
        /opt/libtiff/lib/libtiff.a \
        /opt/webp/lib/libwebp.a \
        /opt/webp/lib/libsharpyuv.a

需要手动重新编译的，请自行安装好如上依赖项，本项目在mac min M4上编译完成。

无需编译的同学可直接下载<a href="https://github.com/tonyblues8/PandaDownload/releases">dmg文件</a>运行。


# 解决Mac安装软件提示`已损坏无法打开`,`请移到废纸篓`

在终端中输入xattr -cr ,(这里要注意后面有个空格)。

将提示已损坏，无法打开的程序图标拖到命令栏中。

[![ZPlayer](https://raw.githubusercontent.com/tonyblues8/ZPlayer/refs/heads/main/pic/jp2.png)](#解决Mac安装软件提示`已损坏无法打开`,`请移到废纸篓`)



