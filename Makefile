#  C++ 
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

# 
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


#  macOS 
ifeq ($(shell uname), Darwin)
    LDFLAGS += -framework Cocoa \
               -framework QuartzCore \
               -framework AudioToolbox \
               -framework IOKit \
               -framework Security \
               -framework OpenGL \
               -framework Carbon
endif

# 
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

SRC_CPP = CustomButton.cpp ImageButton.cpp \
          AutoCloseDialog.cpp MyProcess.cpp CustomGauge.cpp \
          MyTaskBarIcon.cpp TransparentText.cpp \
          pic/imageon.cpp pic/imageoff.cpp \
          pic/imageon1.cpp pic/imageoff1.cpp \
          pic/yybj.cpp pic/yybj2.cpp pic/xz1024.cpp \
          pic/bubj0.cpp pic/bubj.cpp pic/bubj2.cpp pic/icon.cpp

SRC_MM = main.mm Command.mm MyFrame.mm ThemeListener.mm

#OBJ = $(SRC:.cpp=.o)
OBJ = $(SRC_CPP:.cpp=.o) $(SRC_MM:.mm=.o)
TARGET = ytui

$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) $(OBJ) $(LDFLAGS) $(LIBS) -o $(TARGET)
	@echo "Build successful: $(TARGET)"

#  C++ 
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

#  Objective-C++ 
%.o: %.mm
	$(CXX) $(CXXFLAGS) -ObjC++ -c $< -o $@

# 
clean:
	rm -f $(OBJ) $(TARGET)

