# PandaDownload
<!-- MANPAGE: BEGIN EXCLUDED SECTION -->
<div align="center">

[![YT-DLP](https://raw.githubusercontent.com/yt-dlp/yt-dlp/master/.github/banner.svg)](#readme)

[![Release version](https://img.shields.io/github/v/release/yt-dlp/yt-dlp?color=brightgreen&label=Download&style=for-the-badge)](#installation "Installation")
[![PyPI](https://img.shields.io/badge/-PyPI-blue.svg?logo=pypi&labelColor=555555&style=for-the-badge)](https://pypi.org/project/yt-dlp "PyPI")
[![Donate](https://img.shields.io/badge/_-Donate-red.svg?logo=githubsponsors&labelColor=555555&style=for-the-badge)](Collaborators.md#collaborators "Donate")
[![Discord](https://img.shields.io/discord/807245652072857610?color=blue&labelColor=555555&label=&logo=discord&style=for-the-badge)](https://discord.gg/H5MNcFW63r "Discord")
[![Supported Sites](https://img.shields.io/badge/-Supported_Sites-brightgreen.svg?style=for-the-badge)](supportedsites.md "Supported Sites")
[![License: Unlicense](https://img.shields.io/badge/-Unlicense-blue.svg?style=for-the-badge)](LICENSE "License")
[![CI Status](https://img.shields.io/github/actions/workflow/status/yt-dlp/yt-dlp/core.yml?branch=master&label=Tests&style=for-the-badge)](https://github.com/yt-dlp/yt-dlp/actions "CI Status")
[![Commits](https://img.shields.io/github/commit-activity/m/yt-dlp/yt-dlp?label=commits&style=for-the-badge)](https://github.com/yt-dlp/yt-dlp/commits "Commit History")
[![Last Commit](https://img.shields.io/github/last-commit/yt-dlp/yt-dlp/master?label=&style=for-the-badge&display_timestamp=committer)](https://github.com/yt-dlp/yt-dlp/pulse/monthly "Last activity")

</div>

本人运行环境：mac min M4 MacOS 15.3.2

实现了<a href="https://github.com/yt-dlp/yt-dlp">yt-dlp</a>图形界面功能

<b>增强功能：</b>

1:aria2c加速；

2:下载后添加字幕和片头；

3:H265编码；


<b>相关依赖：</b>

1:<a href="https://github.com/yt-dlp/yt-dlp">yt-dlp</a>

2:<a href="https://github.com/FFmpeg/FFmpeg">ffmpeg</a>

3:<a href="https://github.com/aria2/aria2">aria2c</a>

以上依赖无需单独安装，都已经集成在本安装包内。

<b>编译依赖如下</b>

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

