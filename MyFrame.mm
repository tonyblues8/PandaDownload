#include "MyFrame.h"
#include "TransparentText.h"
#include <wx/dirdlg.h>
#include <wx/display.h>
#include <wx/filedlg.h>
#include <wx/statbmp.h>
#include <wx/bitmap.h>
#include <wx/mstream.h>
#include <filesystem>
#include <wx/stdpaths.h>
#include <wx/regex.h>
#include <memory>
#include <wx/wx.h>
#include <wx/sysopt.h>
#include <wx/gauge.h>
#include <wx/process.h>
#include <wx/tglbtn.h>
#include <wx/dialog.h>
#include <wx/timer.h>
#include <wx/file.h>
#include <wx/menu.h>
#include <wx/dir.h>
#include <wx/filename.h>
#include <wx/filefn.h>
#include <wx/taskbar.h>
#include <wx/image.h>
#include <wx/icon.h>
#include <wx/arrstr.h>
#include <vector>
#include <string>
#include <thread>
#include <chrono>
#include <map>
#include <wx/uri.h>
#include <wx/utils.h>
#include <wx/snglinst.h>
#ifdef _WIN32
    #include <windows.h>
#else
    #include <iostream>
    #include <string>
    #include <unistd.h>
    #include <sys/types.h>
    #include <sys/wait.h>
#endif
#ifdef __WXMAC__
#include <wx/osx/private.h>
#endif
#include <fstream>
#include <wx/textfile.h>
#include <cstdio>
#include <algorithm>
#include <cstdlib>
#include "pic/image1.h"
#include "pic/image2.h"
#include "pic/image3.h"
#include "pic/icon.h"
#include "pic/yybj.h"
#include "pic/yybj2.h"
#include "pic/bubj.h"
#include "pic/bubj0.h"
#include "pic/bubj2.h"
#include "pic/imageon.h"
#include "pic/imageoff.h"
#include "pic/imageon1.h"
#include "pic/imageoff1.h"
#include "pic/cx.h"
#include "pic/cx1.h"
#include "pic/cx2.h"
#include "pic/cx3.h"
#include "pic/cx4.h"
#include "pic/cx5.h"
#include "pic/cx6.h"
#include "pic/cx7.h"
#include "pic/loading.h"
#include "pic/loading1.h"
#include "pic/loading2.h"
#include "pic/loading3.h"
#include "pic/loading4.h"
#include "pic/xz1024.h"
#include <utility>
#include <tuple>
#include <wx/dcclient.h>
#include <wx/graphics.h>
#include <wx/hyperlink.h>
#include "ImageButton.h"
#include "CustomButton.h"
#include "AutoCloseDialog.h"
#include "Command.h"
#include "MyProcess.h"
#include "CustomGauge.h"
#include <algorithm>
#include <cctype>
#include <openssl/md5.h>
#include <curl/curl.h>
#include <wx/msgdlg.h>
#include <sstream>
#include <array>
#include <stdexcept>
#ifdef __APPLE__
#include <CoreFoundation/CoreFoundation.h>
#elif _WIN32
#include <windows.h>
#elif __linux__
#include <gio/gio.h>
#endif
#include <wx/txtstrm.h>
#include <objc/objc.h>
#include <objc/message.h>
#include <objc/runtime.h>
#include <regex>

namespace fs = std::filesystem;
const std::vector<std::tuple<const unsigned char*, size_t, wxString>> adImages = {
    { image1_png, image1_png_len, wxString("https://mv.6deng.cn:8443/mobile/app") },
    { image2_png, image2_png_len, wxString("https://mv.6deng.cn:8443/mobile/app") },
    { image3_png, image3_png_len, wxString("https://www.youtube.com/@tonyblues8") }
};
MyFrame::MyFrame()
    : wxFrame(nullptr, wxID_ANY, wxString::FromUTF8("熊猫下载v2.0.0[让一切视听自由分享]"),
              wxDefaultPosition, wxSize(800, 800),
              wxDEFAULT_FRAME_STYLE & ~(wxRESIZE_BORDER | wxMAXIMIZE_BOX)),
      m_menu(new wxMenu()), m_dragging(false), m_isMaximized(false),
      m_currentAdIndex(0), m_downloading(false), m_ffmpeging(false),
      process(nullptr), m_timer5(this) {
    InitUI();
    BindEvents();
}
MyFrame::~MyFrame() {
    delete m_menu;
    if (m_timer2) {
        m_timer2->Stop();
        delete m_timer2;
    }
    if (m_timer4) {
        m_timer4->Stop();
        delete m_timer4;
    }
    if (process) {
        if (process->IsAlive()) {
            long pid = process->GetPid();
            if (pid > 0) {
                wxString cmd;
#ifdef __WXMSW__
                cmd = wxString::Format("taskkill /PID %d /F", pid);
#else
                if (m_toggleButton8->GetValue()) {
                    cmd = wxString::Format("sh -c \"ps -ef | grep yt-dlp | grep -v grep | awk '{print \\\"kill -15 \\\" $2}' | ps -ef | grep -i aria2 | grep -v grep | awk '{print \\\"kill -9 \\\" $2 %ld}'| sh\"", pid);
                } else {
                    cmd = wxString::Format("sh -c \"ps -ef | grep yt-dlp | grep -v grep | awk '{print \\\"kill -15 \\\" $2 %ld}' | sh\"", pid);
                }
#endif
                wxExecute(cmd, wxEXEC_SYNC | wxEXEC_HIDE_CONSOLE);
            }
        }
        delete process;
    }
    if (m_adBitmap) {
        delete m_adBitmap;
    }
    if (m_textCtrl) {
        delete m_textCtrl;
    }
    if (m_textCtrl2) {
        delete m_textCtrl2;
    }
    if (m_dirPathTextCtrl) {
        delete m_dirPathTextCtrl;
    }
    if (m_dirPathTextCtrl2) {
        delete m_dirPathTextCtrl2;
    }
    if (m_dirPathTextCtrl3) {
        delete m_dirPathTextCtrl3;
    }
    if (m_dirPathTextCtrl4) {
        delete m_dirPathTextCtrl4;
    }
    if (selectDirButton) {
        delete selectDirButton;
    }
    if (selectDirButton2) {
        delete selectDirButton2;
    }
    if (selectDirButton3) {
        delete selectDirButton3;
    }
    if (selectDirButton4) {
        delete selectDirButton4;
    }
    if (lookfButton) {
        delete lookfButton;
    }
    if (startButton) {
        delete startButton;
    }
    if (stopButton) {
        delete stopButton;
    }
    if (m_toggleButton1) {
        delete m_toggleButton1;
    }
    if (m_toggleButton2) {
        delete m_toggleButton2;
    }
    if (m_toggleButton3) {
        delete m_toggleButton3;
    }
    if (m_toggleButton4) {
        delete m_toggleButton4;
    }
    if (m_toggleButton5) {
        delete m_toggleButton5;
    }
    if (m_toggleButton6) {
        delete m_toggleButton6;
    }
    if (m_toggleButton7) {
        delete m_toggleButton7;
    }
    if (m_toggleButton8) {
        delete m_toggleButton8;
    }
    if (m_cookieChoice) {
        delete m_cookieChoice;
    }
    if (m_qualityChoice) {
        delete m_qualityChoice;
    }
    if (m_qualityChoice2) {
        delete m_qualityChoice2;
    }
    if (m_gauge) {
        delete m_gauge;
    }
    if (m_outputTextCtrl) {
        delete m_outputTextCtrl;
    }
    if (content) {
        delete content;
    }
}
void MyFrame::InitUI() {
    wxBoxSizer* mainSizer = new wxBoxSizer(wxVERTICAL);
    m_titleBar = CreateTitleBar();
    mainSizer->Add(m_titleBar, 0, wxEXPAND);
    content = new wxPanel(this, wxID_ANY);
    wxBoxSizer* mainSizer2 = new wxBoxSizer(wxVERTICAL);
    inputSizer = new wxBoxSizer(wxHORIZONTAL);
    buttonSizer = new wxBoxSizer(wxHORIZONTAL);
    controlSizer = new wxBoxSizer(wxHORIZONTAL);
    selectSizer = new wxBoxSizer(wxHORIZONTAL);
    adSizer = new wxBoxSizer(wxHORIZONTAL);
    inputSizer2 = new wxBoxSizer(wxHORIZONTAL);
    checkvideoSizer = new wxBoxSizer(wxHORIZONTAL);
    checkvideoSizer2 = new wxBoxSizer(wxHORIZONTAL);
    wxString homeDir = wxGetHomeDir();
    wxString filename = wxString::Format(homeDir + "/zsprundir/dark_zplayer.txt");
    filename = Command::NormalizePath(filename.ToStdString());
    if (wxFileExists(filename)) {
        std::string loadedData = zycmd.loadFromFile(filename.ToStdString());
        if (!loadedData.empty()) {
            isDarkMode = zycmd.stringToBool(loadedData);
        }
    } else {
        isDarkMode = Command::IsDarkMode();
    }
    backgroundColor = isDarkMode ? wxColour(36, 36, 36) : wxColour(242, 242, 242);
    textColor = isDarkMode ? wxColour(242, 242, 242) : wxColour(36, 36, 36);
    customColor = isDarkMode ? wxColour(128, 128, 128) : wxColour(230, 230, 230);
    customColor2 = isDarkMode ? wxColour(168, 168, 168) : wxColour(242, 242, 242);
    content->SetBackgroundColour(backgroundColor);
    wxInitAllImageHandlers();
    wxMemoryInputStream memStreamCx(cx_png, cx_png_len);
    wxMemoryInputStream memStreamCx1(loading_png, loading_png_len);
    wxMemoryInputStream memStreamCx2(loading1_png, loading1_png_len);
    wxMemoryInputStream memStreamCx3(loading2_png, loading2_png_len);
    wxMemoryInputStream memStreamCx4(loading3_png, loading3_png_len);
    wxMemoryInputStream memStreamCx5(loading4_png, loading4_png_len);
    wxImage imageCx(memStreamCx, wxBITMAP_TYPE_PNG);
    wxImage imageCx1(memStreamCx1, wxBITMAP_TYPE_PNG);
    wxImage imageCx2(memStreamCx2, wxBITMAP_TYPE_PNG);
    wxImage imageCx3(memStreamCx3, wxBITMAP_TYPE_PNG);
    wxImage imageCx4(memStreamCx4, wxBITMAP_TYPE_PNG);
    wxImage imageCx5(memStreamCx5, wxBITMAP_TYPE_PNG);
    wxBitmap cxBitmap(imageCx);
    m_frames.push_back(wxBitmap(imageCx1));
    m_frames.push_back(wxBitmap(imageCx2));
    m_frames.push_back(wxBitmap(imageCx3));
    m_frames.push_back(wxBitmap(imageCx4));
    m_frames.push_back(wxBitmap(imageCx5));
    m_currentFrame = 0;
    wxMemoryInputStream memStreambubj(bubj_png, bubj_png_len);
    wxImage imagebubj(memStreambubj, wxBITMAP_TYPE_PNG);
    if (imagebubj.IsOk()) {
        wxImage scaledImagebubj = imagebubj.Rescale(120, 30, wxIMAGE_QUALITY_HIGH);
        bitmapbubj = wxBitmap(scaledImagebubj);
    }
    wxMemoryInputStream memStreambubj2(bubj2_png, bubj2_png_len);
    wxImage imagebubj2(memStreambubj2, wxBITMAP_TYPE_PNG);
    if (imagebubj2.IsOk()) {
        wxImage scaledImagebubj2 = imagebubj2.Rescale(120, 30, wxIMAGE_QUALITY_HIGH);
        bitmapbubj2 = wxBitmap(scaledImagebubj2);
    }
    wxMemoryInputStream memStreambubj0(bubj0_png, bubj0_png_len);
    wxImage imagebubj0(memStreambubj0, wxBITMAP_TYPE_PNG);
    if (imagebubj0.IsOk()) {
        wxImage scaledImagebubj0 = imagebubj0.Rescale(120, 30, wxIMAGE_QUALITY_HIGH);
        bitmapbubj0 = wxBitmap(scaledImagebubj0);
    }
    if (isDarkMode) {
        wxMemoryInputStream memStreamOn(imageon1_png, imageon1_png_len);
        wxMemoryInputStream memStreamOff(imageoff1_png, imageoff1_png_len);
        wxImage imageOn(memStreamOn, wxBITMAP_TYPE_PNG);
        wxImage imageOff(memStreamOff, wxBITMAP_TYPE_PNG);
        if (imageOn.IsOk() && imageOff.IsOk()) {
            wxImage scaledImageOn = imageOn.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
            bitmapOn = wxBitmap(scaledImageOn);
            wxImage scaledImageOff = imageOff.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
            bitmapOff = wxBitmap(scaledImageOff);
        }
    } else {
        wxMemoryInputStream memStreamOn(imageon_png, imageon_png_len);
        wxMemoryInputStream memStreamOff(imageoff_png, imageoff_png_len);
        wxImage imageOn(memStreamOn, wxBITMAP_TYPE_PNG);
        wxImage imageOff(memStreamOff, wxBITMAP_TYPE_PNG);
        if (imageOn.IsOk() && imageOff.IsOk()) {
            wxImage scaledImageOn = imageOn.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
            bitmapOn = wxBitmap(scaledImageOn);
            wxImage scaledImageOff = imageOff.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
            bitmapOff = wxBitmap(scaledImageOff);
        }
    }
    const auto& [imageData, imageDataLen, adLink] = adImages[0];
    wxMemoryInputStream memStream(imageData, imageDataLen);
    wxImage image(memStream, wxBITMAP_TYPE_PNG);
    if (image.IsOk()) {
        m_adBitmap = new wxStaticBitmap(content, wxID_ANY, wxBitmap(image));
    } else {
#ifdef DEBUG
        std::cerr << "Failed to load image from embedded data. " << std::endl;
#endif
        m_adBitmap = new wxStaticBitmap(content, wxID_ANY, wxBitmap());
    }
    adSizer->Add(m_adBitmap, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    wxMemoryInputStream memStreamIcon(icon_png, icon_png_len);
    wxImage imageIcon(memStreamIcon, wxBITMAP_TYPE_PNG);
    if (imageIcon.IsOk()) {
        wxIcon icon;
        icon.CopyFromBitmap(wxBitmap(imageIcon));
        SetIcon(icon);
    }
    wxHyperlinkCtrl* staticText = new wxHyperlinkCtrl(content, wxID_ANY, wxString::FromUTF8("下载网址："), "", wxDefaultPosition, wxDefaultSize);
    wxFont staticTextfont = staticText->GetFont();
    staticTextfont.SetUnderlined(false);
    staticText->SetFont(staticTextfont);
    staticText->SetMinSize(wxSize(-1, 30));
    m_textCtrl = new wxTextCtrl(content, wxID_ANY);
    m_textCtrl->SetMinSize(wxSize(200, 30));
    m_textCtrl->Bind(wxEVT_KEY_DOWN, &MyFrame::OnTextCtrlKeyDown, this);
    m_dirPathTextCtrl = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, wxTE_READONLY);
    m_dirPathTextCtrl->SetMinSize(wxSize(200, 30));
    selectDirButton = new CustomButton(content, wxID_ANY, wxString::FromUTF8("保存目录"), bitmapbubj2, wxDefaultPosition, wxSize(120, 30));
    wxStaticText* staticText2 = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("代       理："));
    m_textCtrl2 = new wxTextCtrl(content, wxID_ANY);
    m_textCtrl2->SetMinSize(wxSize(200, 30));
    m_textCtrl2->Bind(wxEVT_KEY_DOWN, &MyFrame::OnTextCtrlKeyDown, this);
    lookfButton = new CustomButton(content, wxID_ANY, wxString::FromUTF8("查询片源格式质量"), bitmapbubj2, wxDefaultPosition, wxSize(120, 30));
    m_dirPathTextCtrl2 = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, wxTE_READONLY);
    m_dirPathTextCtrl2->SetMinSize(wxSize(200, 30));
    selectDirButton2 = new CustomButton(content, wxID_ANY, wxString::FromUTF8("选择cookie文件"), bitmapbubj2, wxDefaultPosition, wxSize(120, 30));
    m_dirPathTextCtrl3 = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, wxTE_READONLY);
    //m_dirPathTextCtrl3 = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize);
    //m_dirPathTextCtrl3->Enable(false);
    m_dirPathTextCtrl3->SetMinSize(wxSize(200, 30));
    selectDirButton3 = new CustomButton(content, wxID_ANY, wxString::FromUTF8("片头视频"), bitmapbubj0, wxDefaultPosition, wxSize(120, 30));
    selectDirButton3->Enable(false);
    m_dirPathTextCtrl4 = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, wxTE_READONLY);
    //m_dirPathTextCtrl4 = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize);
    //m_dirPathTextCtrl4->Enable(false);
    m_dirPathTextCtrl4->SetMinSize(wxSize(200, 30));
    selectDirButton4 = new CustomButton(content, wxID_ANY, wxString::FromUTF8("片头字幕"), bitmapbubj0, wxDefaultPosition, wxSize(120, 30));
    selectDirButton4->Enable(false);
    wxStaticText* staticTexta = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("添加封面"));
    m_toggleButton1 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOn, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTextb = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("只下载音频"));
    m_toggleButton2 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTextc = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("MP4输出"));
    m_toggleButton3 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTextd = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("列表下载"));
    m_toggleButton4 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTexte = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("添加片头"));
    staticTexte->SetMinSize(wxSize(-1, 30));
    m_toggleButton5 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTextf = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("完成后自动播放"));
    m_toggleButton6 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTextg = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("深色模式"));
    if (isDarkMode) {
        m_toggleButton7 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOn, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
        m_toggleButton7->SetValue(true);
    } else {
        m_toggleButton7 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
        m_toggleButton7->SetValue(false);
    }
    wxStaticText* staticTexth = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("aria2加速"));
    m_toggleButton8 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOn, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    wxStaticText* staticTexti = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("H265编码"));
    m_toggleButton9 = new wxBitmapToggleButton(content, wxID_ANY, bitmapOff, wxDefaultPosition, wxDefaultSize, wxBORDER_NONE);
    m_toggleButton8->SetValue(true);
    m_toggleButton9->SetValue(false);
    m_toggleButton1->SetValue(true);
    m_toggleButton2->SetValue(false);
    m_toggleButton3->SetValue(false);
    m_toggleButton4->SetValue(false);
    m_toggleButton5->SetValue(false);
    m_toggleButton6->SetValue(false);
    m_toggleButton1->SetMinSize(wxSize(30, 30));
    m_toggleButton2->SetMinSize(wxSize(30, 30));
    m_toggleButton3->SetMinSize(wxSize(30, 30));
    m_toggleButton4->SetMinSize(wxSize(30, 30));
    m_toggleButton5->SetMinSize(wxSize(30, 30));
    m_toggleButton6->SetMinSize(wxSize(30, 30));
    m_toggleButton7->SetMinSize(wxSize(30, 30));
    m_toggleButton8->SetMinSize(wxSize(30, 30));
    m_toggleButton9->SetMinSize(wxSize(30, 30));
    m_toggleButton1->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick, this);
    m_toggleButton2->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick3, this);
    m_toggleButton3->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick, this);
    m_toggleButton4->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick4, this);
    m_toggleButton5->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick2, this);
    m_toggleButton6->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick, this);
    m_toggleButton7->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick5, this);
    m_toggleButton8->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick, this);
    m_toggleButton9->Bind(wxEVT_TOGGLEBUTTON, &MyFrame::OnToggleButtonClick, this);
    wxArrayString cookieChoices;
    cookieChoices.Add(wxString::FromUTF8("游客身份"));
    cookieChoices.Add(wxString::FromUTF8("从文件获取cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取brave的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取chrome的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取chromium的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取edge的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取firefox的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取opera的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取safari的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取vivaldi的cookie"));
    cookieChoices.Add(wxString::FromUTF8("获取whale的cookie"));
    m_cookieChoice = new wxComboBox(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, cookieChoices, wxCB_READONLY);
    m_cookieChoice->SetSelection(3);
    m_cookieChoice->SetMinSize(wxSize(300, 30));
    startButton = new CustomButton(content, wxID_ANY, wxString::FromUTF8("下载"), bitmapbubj2, wxDefaultPosition, wxSize(120, 30));
    stopButton = new CustomButton(content, wxID_ANY, wxString::FromUTF8("暂停下载"), bitmapbubj2, wxDefaultPosition, wxSize(120, 30));
    m_gauge = new CustomGauge(content, wxID_ANY, 100, wxPoint(20, 20), wxSize(250, 20));
    m_outputTextCtrl = new wxTextCtrl(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, wxTE_MULTILINE | wxTE_WORDWRAP | wxTE_READONLY | wxTE_NO_VSCROLL | wxTE_NOHIDESEL);
    m_outputTextCtrl->SetMinSize(wxSize(300, 60));
    qualityChoices.Add(wxString::FromUTF8("选择片源视频格式质量"));
    qualityChoices.Add(wxString::FromUTF8("自动选优"));
    videoqOptions[std::string(wxString("选择片源视频格式质量"))] = "";
    videoqOptions[std::string(wxString("自动选优"))] = "bv+ba/b";
    m_qualityChoice = new wxComboBox(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, qualityChoices,wxCB_READONLY);
    m_qualityChoice->SetSelection(0);
    m_qualityChoice->SetMinSize(wxSize(800, 30));
    qualityChoices2.Add(wxString::FromUTF8("选择片源音频格式质量"));
    qualityChoices2.Add(wxString::FromUTF8("自动选优"));
    videoqOptions2[std::string(wxString("选择片源音频格式质量"))] = "";
    videoqOptions2[std::string(wxString("自动选优"))] = "bv+ba/b";
    m_qualityChoice2 = new wxComboBox(content, wxID_ANY, "", wxDefaultPosition, wxDefaultSize, qualityChoices2,wxCB_READONLY);
    m_qualityChoice2->SetSelection(0);
    m_qualityChoice2->SetMinSize(wxSize(500, 30));
    wxStaticText* versionTexte = new wxStaticText(content, wxID_ANY, wxString::FromUTF8("主程序版本号:v:2025.03.28[yt-dlp:2025.03.26][ffmpeg:N-117950-gf57f2a356d-tessus][ffprobe:N-117950-gf57f2a356d-tessus]."));
    wxFont versionTextefont(9, wxFONTFAMILY_SWISS, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_NORMAL);
    versionTexte->SetFont(versionTextefont);
    m_gauge->SetBackgroundAndForeground(backgroundColor, textColor);
#ifdef _WIN32
    this->SetTransparent(250);
#else
    this->SetTransparent(255);
#endif
    inputSizer->Add(staticText, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    inputSizer->Add(m_textCtrl, 1, wxALL | wxEXPAND, 5);
    inputSizer->Add(selectDirButton, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    inputSizer->Add(m_dirPathTextCtrl, 1, wxALL | wxEXPAND, 5);
    inputSizer2->Add(staticText2, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    inputSizer2->Add(m_textCtrl2, 1, wxALL | wxEXPAND, 5);
    inputSizer2->Add(selectDirButton2, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    inputSizer2->Add(m_dirPathTextCtrl2, 1, wxALL | wxEXPAND, 5);
    buttonSizer->Add(staticTexta, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    buttonSizer->Add(m_toggleButton1, 0, wxALL, 5);
    buttonSizer->Add(staticTextb, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    buttonSizer->Add(m_toggleButton2, 0, wxALL, 5);
    buttonSizer->Add(staticTextd, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    buttonSizer->Add(m_toggleButton4, 0, wxALL, 5);
    buttonSizer->Add(staticTextc, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    buttonSizer->Add(m_toggleButton3, 0, wxALL, 5);
    buttonSizer->Add(staticTextf, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    buttonSizer->Add(m_toggleButton6, 0, wxALL, 5);
    buttonSizer->Add(m_cookieChoice, 0, wxALL, 5);
    controlSizer->Add(startButton, 0, wxALL, 5);
    controlSizer->Add(stopButton, 0, wxALL, 5);
    controlSizer->Add(staticTextg, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    controlSizer->Add(m_toggleButton7, 0, wxALL, 5);
    controlSizer->Add(staticTexth, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    controlSizer->Add(m_toggleButton8, 0, wxALL, 5);
    controlSizer->Add(staticTexti, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    controlSizer->Add(m_toggleButton9, 0, wxALL, 5);
    selectSizer->Add(staticTexte, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    selectSizer->Add(m_toggleButton5, 0, wxALL, 5);
    selectSizer->Add(selectDirButton3, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    selectSizer->Add(m_dirPathTextCtrl3, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    selectSizer->Add(selectDirButton4, 0, wxALL | wxALIGN_CENTER_VERTICAL, 5);
    selectSizer->Add(m_dirPathTextCtrl4, 0, wxALL | wxEXPAND, 10);
    checkvideoSizer->Add(lookfButton, 0, wxALL, 5);
    checkvideoSizer->Add(m_qualityChoice2, 1, wxEXPAND | wxALL, 5);
    checkvideoSizer2->Add(m_qualityChoice, 1, wxEXPAND | wxALL, 5);
    mainSizer2->Add(adSizer, 0, wxALL | wxALIGN_CENTER_HORIZONTAL, 10);
    mainSizer2->Add(inputSizer, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(inputSizer2, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(buttonSizer, 0, wxALL, 10);
    mainSizer2->Add(checkvideoSizer, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(checkvideoSizer2, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(selectSizer, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(controlSizer, 0, wxALL | wxALIGN_CENTER_HORIZONTAL, 10);
    mainSizer2->Add(m_gauge, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(m_outputTextCtrl, 0, wxALL | wxEXPAND, 10);
    mainSizer2->Add(versionTexte, 0, wxALL | wxALIGN_CENTER_HORIZONTAL, 10);
    content->SetSizerAndFit(mainSizer2);
    Bind(wxEVT_BUTTON, &MyFrame::OnButtonClick, this, startButton->GetId());
    Bind(wxEVT_BUTTON, &MyFrame::OnStopButtonClick, this, stopButton->GetId());
    Bind(wxEVT_BUTTON, &MyFrame::OnlookfButtonClick, this, lookfButton->GetId());
    Bind(wxEVT_BUTTON, &MyFrame::OnSelectDirButtonClick, this, selectDirButton->GetId());
    Bind(wxEVT_BUTTON, &MyFrame::OnSelectFileButtonClick, this, selectDirButton2->GetId());
    Bind(wxEVT_BUTTON, &MyFrame::OnSelectPtButtonClick, this, selectDirButton3->GetId());
    Bind(wxEVT_BUTTON, &MyFrame::OnSelectZmButtonClick, this, selectDirButton4->GetId());
    staticText->Bind(wxEVT_HYPERLINK, &MyFrame::OnHyperlinkClick, this);
    //m_timer = new wxTimer(this);
    m_timer2 = new wxTimer(this);
    m_timer4 = new wxTimer(this);
    //Bind(wxEVT_TIMER, &MyFrame::OnTimer, this, m_timer->GetId());
    Bind(wxEVT_TIMER, &MyFrame::OnTimer2, this, m_timer2->GetId());
    Bind(wxEVT_TIMER, &MyFrame::OnTimer4, this, m_timer4->GetId());
    Bind(wxEVT_TIMER, &MyFrame::OnTimer5, this, m_timer5.GetId());
    Bind(wxEVT_CLOSE_WINDOW, &MyFrame::OnClose, this);
    m_adBitmap->Bind(wxEVT_LEFT_DOWN, &MyFrame::OnAdBitmapClick, this);
    m_timer2->Start(10000);
    CentreOnParent();
    mainSizer->Add(content, 1, wxEXPAND);
    SetSizer(mainSizer);
    SetupMenu();
    m_normalRect = GetRect();
#ifdef __WXMSW__
    LONG style = ::GetWindowLong(GetHandle(), GWL_STYLE);
    style &= ~(WS_CAPTION | WS_THICKFRAME);
    ::SetWindowLong(GetHandle(), GWL_STYLE, style);
    ::SetWindowPos(GetHandle(), nullptr, 0, 0, 0, 0,
                   SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);
#endif
#ifdef __WXMAC__
    id nsView = (id)this->GetHandle();
    id nsWindow = [(id)nsView window];
    [nsWindow setTitlebarAppearsTransparent:YES];
    [nsWindow setStyleMask:([nsWindow styleMask] & ~NSWindowStyleMaskTitled) | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable];
#endif
#ifdef __WXGTK__
    gtk_window_set_decorated(GTK_WINDOW(GetHandle()), FALSE);
#endif
}
    void MyFrame::BindEvents() {
        Bind(wxEVT_SIZE, &MyFrame::OnResize, this);
        Bind(wxEVT_MAXIMIZE, &MyFrame::OnMaximize, this);
    }

    wxPanel* MyFrame::CreateTitleBar() {
        wxPanel* panel = new wxPanel(this, wxID_ANY);
        panel->SetBackgroundColour(wxColour(0, 0, 0, 0));
        panel->Bind(wxEVT_PAINT, [this, panel](wxPaintEvent&) {
            wxPaintDC dc(panel);
            dc.SetBrush(wxColour(204, 204, 204));
            dc.SetPen(*wxTRANSPARENT_PEN);
            dc.DrawRectangle(panel->GetClientRect());
        });
        wxBoxSizer* sizer = new wxBoxSizer(wxHORIZONTAL);

        wxMemoryInputStream memStreamicon(xz1024_png, xz1024_png_len);
        wxImage imageicon(memStreamicon, wxBITMAP_TYPE_PNG);

        if (imageicon.IsOk()) {
            if (!imageicon.HasAlpha()) {
                imageicon.InitAlpha();
            }
            wxImage scaledImageicon = imageicon.Rescale(25, 25, wxIMAGE_QUALITY_HIGH);
            if (!scaledImageicon.HasAlpha()) {
                scaledImageicon.InitAlpha();
            }
            bitmapicon = wxBitmap(scaledImageicon);
        } else {
            wxImage emptyImage(25, 25);
            emptyImage.InitAlpha();
            unsigned char red = 204;
            unsigned char green = 204;
            unsigned char blue = 204;

            for (int y = 0; y < emptyImage.GetHeight(); y++) {
                for (int x = 0; x < emptyImage.GetWidth(); x++) {
                    emptyImage.SetRGB(x, y, red, green, blue);
                    emptyImage.SetAlpha(x, y, 255);
                }
            }

            bitmapicon = wxBitmap(emptyImage);
        }
        bitmapicon.UseAlpha();
        wxStaticBitmap* m_iconBitmap = new wxStaticBitmap(panel, wxID_ANY, bitmapicon);
        m_iconBitmap->SetMaxSize(wxSize(25, 25));
        m_iconBitmap->SetBackgroundColour(wxColour(204, 204, 204));
        sizer->Add(m_iconBitmap, 1, wxLEFT | wxALIGN_CENTER, 0);

        m_menuBtn = new CustomButton(panel, wxID_ANY, wxString::FromUTF8("菜单"), bitmapbubj2, wxDefaultPosition, wxSize(40, 30));
        StyleButton2(m_menuBtn);
        sizer->Add(m_menuBtn, 0, wxLEFT | wxALIGN_CENTER, 0);
        TransparentText* title = new TransparentText(panel, wxString::FromUTF8("熊猫下载v2.0.0[让一切视听自由分享]"), wxSize(300, 30), *wxBLACK, 14, true, false);
        sizer->Add(title, 1, wxLEFT | wxALIGN_CENTER, 10);
        CreateControlButtons(panel, sizer);
        panel->Bind(wxEVT_LEFT_DOWN, &MyFrame::OnTitleBarLeftDown, this);
        panel->Bind(wxEVT_LEFT_DCLICK, &MyFrame::OnTitleBarDoubleClick, this);
        panel->Bind(wxEVT_MOTION, &MyFrame::OnTitleBarMove, this);
        panel->SetSizer(sizer);
        panel->Refresh();
        return panel;
    }
    void MyFrame::MinimizeWindow(id nsWindow) {
        if (!nsWindow) {
            #ifdef DEBUG
                wxLogError("Invalid NSWindow handle!");
            #endif
            return;
        }
        @try {
            [nsWindow miniaturize:nil];
        } @catch (NSException *exception) {
            wxLogError("Exception occurred: %s", exception.reason.UTF8String);
        }
    }
    void MyFrame::CreateControlButtons(wxPanel* parent, wxBoxSizer* sizer) {

        CustomButton* minimizeBtn = new CustomButton(parent, wxID_ANY, "─", bitmapbubj2, wxDefaultPosition, wxSize(40, 30));
        minimizeBtn->Bind(wxEVT_BUTTON, [this](wxCommandEvent&) {
#ifdef __WXMSW__
            ShowWindow(GetHandle(), SW_MINIMIZE);
#elif defined(__WXMAC__)
            id nsView = (id)this->GetHandle();
            id nsWindow = [(id)nsView window];
            if (nsWindow) {
                MinimizeWindow(nsWindow);
            } else {
                wxLogError("Failed to get NSWindow handle!");
            }
#elif defined(__WXGTK__)
            gtk_window_iconify(GTK_WINDOW(GetHandle()));
#else
            Iconize(true);
#endif
        });
        m_maximizeBtn = new CustomButton(parent, wxID_ANY, "□", bitmapbubj2, wxDefaultPosition, wxSize(40, 30));
        m_maximizeBtn->Bind(wxEVT_BUTTON, [this](wxCommandEvent&) {
            ToggleMaximize();
        });
        CustomButton* closeBtn = new CustomButton(parent, wxID_ANY, "x", bitmapbubj2, wxDefaultPosition, wxSize(40, 30));
        closeBtn->Bind(wxEVT_BUTTON, [this](wxCommandEvent&) {
            Close(true);
        });
        StyleButton2(closeBtn, true);
        sizer->Add(minimizeBtn, 0, wxRIGHT, 2);
        sizer->Add(m_maximizeBtn, 0, wxRIGHT, 2);
        sizer->Add(closeBtn, 0, wxRIGHT, 0);
    }
    void MyFrame::ToggleMaximize() {
        if (m_isMaximized) {
            SetSize(m_normalRect.GetSize());
            SetPosition(m_normalRect.GetPosition());
            m_maximizeBtn->SetLabel("□");
            m_isMaximized = false;
        } else {
            m_normalRect = GetRect();
            wxRect clientArea = wxGetClientDisplayRect();
            SetSize(clientArea.GetSize());
            SetPosition(clientArea.GetPosition());
            m_maximizeBtn->SetLabel("[]");
            m_isMaximized = true;
        }
        Refresh();
    }
    void MyFrame::StyleButton(wxButton* btn, bool isClose) {
        btn->SetForegroundColour(*wxWHITE);
        btn->SetBackgroundColour(isClose ? wxColour(255, 80, 80) : wxColour(80, 80, 80));
        btn->Bind(wxEVT_ENTER_WINDOW, [btn, isClose](wxMouseEvent&) {
            btn->SetBackgroundColour(isClose ? wxColour(255, 80, 80) : wxColour(80, 80, 80));
            btn->Refresh();
        });
        btn->Bind(wxEVT_LEAVE_WINDOW, [btn, isClose](wxMouseEvent&) {
            btn->SetBackgroundColour(isClose ? wxColour(255, 80, 80) : wxColour(80, 80, 80));
            btn->Refresh();
        });
    }
    void MyFrame::StyleButton2(CustomButton* btn, bool isClose) {
        btn->SetForegroundColour(*wxWHITE);
        btn->SetBackgroundColour(isClose ? wxColour(255, 80, 80) : wxColour(80, 80, 80));
        btn->Bind(wxEVT_ENTER_WINDOW, [btn, isClose](wxMouseEvent&) {
            btn->SetBackgroundColour(isClose ? wxColour(255, 80, 80) : wxColour(80, 80, 80));
            btn->Refresh();
        });
        btn->Bind(wxEVT_LEAVE_WINDOW, [btn, isClose](wxMouseEvent&) {
            btn->SetBackgroundColour(isClose ? wxColour(255, 80, 80) : wxColour(80, 80, 80));
            btn->Refresh();
        });
    }
    void MyFrame::SetupMenu() {
        m_menu->Append(wxID_OPEN, "&Open");
        m_menu->Append(wxID_SAVE, "&Save");
        m_menu->AppendSeparator();
        m_menu->Append(wxID_EXIT, "E&xit");
        m_menu->Bind(wxEVT_MENU, [this](wxCommandEvent& e) {
            switch (e.GetId()) {
                case wxID_EXIT:
                    Close(true);
                    break;
                case wxID_OPEN:
                    wxLogMessage("Open clicked");
                    break;
                case wxID_SAVE:
                    wxLogMessage("Save clicked");
                    break;
            }
        });
        m_menuBtn->Bind(wxEVT_BUTTON, [this](wxCommandEvent&) {
            PopupMenu(m_menu, m_menuBtn->GetPosition() + wxPoint(0, m_menuBtn->GetSize().y + 5));
        });
    }
    void MyFrame::OnTitleBarLeftDown(wxMouseEvent& e) {
        if (IsMaximized()) {
            wxRect normalRect = GetRect();
            wxPoint mousePos = ClientToScreen(e.GetPosition());
            int newX = mousePos.x - (normalRect.width * e.GetX() / GetSize().x);
            int newY = mousePos.y - e.GetY();
            Maximize(false);
            SetPosition(wxPoint(newX, newY));
        }
        m_dragStart = ClientToScreen(e.GetPosition()) - GetPosition();
        m_dragging = true;
    }

    void MyFrame::OnTitleBarMove(wxMouseEvent& e) {
        if (m_dragging && e.Dragging()) {
            wxPoint current = ClientToScreen(e.GetPosition());
            wxPoint newPos = current - m_dragStart;
            wxDisplay display;
            wxRect screenRect = display.GetClientArea();
            newPos.x = wxMax(screenRect.x, wxMin(newPos.x, screenRect.x + screenRect.width - GetSize().x));
            newPos.y = wxMax(screenRect.y, wxMin(newPos.y, screenRect.y + screenRect.height - GetSize().y));
            Move(newPos);
        }
    }

    void MyFrame::OnTitleBarLeftUp(wxMouseEvent&) {
        if (m_dragging) {
            m_dragging = false;
        }
    }

    void MyFrame::OnMaximize(wxMaximizeEvent& e) {
        m_maximizeBtn->SetLabel(IsMaximized() ? "[]" : "□");
        e.Skip();
    }
    void MyFrame::OnTitleBarDoubleClick(wxMouseEvent&) {
        ToggleMaximize();
    }
    void MyFrame::OnResize(wxSizeEvent& e) {
        wxRect currentRect = GetRect();
        wxRect displayRect = wxGetClientDisplayRect();
        m_isMaximized = currentRect.GetSize() == displayRect.GetSize();
        m_maximizeBtn->SetLabel(m_isMaximized ? "[]" : "□");
        e.Skip();
    }

	  void MyFrame::OnHyperlinkClick(wxHyperlinkEvent& event) {
	  	wxString url = m_textCtrl->GetValue();
	  	wxLaunchDefaultBrowser(wxString::FromUTF8(url));
	  }
    void MyFrame::OnButtonClick(wxCommandEvent&) {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        startButton->SetLabel(wxString::FromUTF8("下载中..."));
        m_downloading = true;
        m_ffmpeging = false;
        m_gauge->SetValue(static_cast<int>(2));
        wxString ahomeDir = wxGetHomeDir();
        wxString afilePath = ahomeDir + "/zsprundir/bin/yt-dlp";
        afilePath = Command::NormalizePath(afilePath.ToStdString());
        wxString path = wxGetenv("PATH");
        wxString url = m_textCtrl->GetValue();
        url = Command::ClearAllSpace(url);
        if (url.IsEmpty()) {
        	AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载网址是必须的"), 3000);
          dlg->Show();
        	startButton->SetLabel(wxString::FromUTF8("下载"));
        	m_gauge->SetValue(static_cast<int>(0));
        	m_downloading = false;
        	return;
        }
        wxString dirPath = m_dirPathTextCtrl->GetValue();
        dirPath = Command::NormalizePath(dirPath.ToStdString());
        if (dirPath.IsEmpty()) {
        	AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("保存目录是必须的"), 3000);
          dlg->Show();
        	startButton->SetLabel(wxString::FromUTF8("下载"));
        	m_gauge->SetValue(static_cast<int>(0));
        	m_downloading = false;
        	return;
        }
        wxString saveDir = !dirPath.IsEmpty() ? wxString::Format(" -P '%s'", dirPath) : wxString::Format(" -P '%s'", ahomeDir);
        wxString aria2cpar = "";
        if (m_toggleButton8->GetValue()) {
            std::string urlmd51 = url.ToStdString();
            std::string urlmd5 = zycmd.getStringMD5(urlmd51);
            wxString aria2clogfile = ahomeDir + "/zsprundir/zsp_p_" + urlmd5 + ".txt";
            aria2clogfile = Command::NormalizePath(aria2clogfile.ToStdString());
            wxString aria2cact = ahomeDir + "/zsprundir/bin/aria2c";
            aria2cpar = wxString::Format(" --downloader '%s' --downloader-args 'aria2c:-x 16 -s 16 -k 4M -L %s'",aria2cact, aria2clogfile);
        }
        wxString myproxy0 = m_textCtrl2->GetValue();
        myproxy0 = Command::ClearAllSpace(myproxy0);
        wxString myproxy = !myproxy0.IsEmpty() ? wxString::Format(" --proxy '%s'", myproxy0) : "";
        wxString cookiefilePath0 = m_dirPathTextCtrl2->GetValue();
        cookiefilePath0 = Command::NormalizePath(cookiefilePath0.ToStdString());
        wxString cookiefilePath = !cookiefilePath0.IsEmpty() ? wxString::Format(" --cookies '%s'", cookiefilePath0) : "";
        wxString ptdirPath = m_dirPathTextCtrl3->GetValue();
        ptdirPath = Command::NormalizePath(ptdirPath.ToStdString());
        wxString ptDir = !ptdirPath.IsEmpty() && m_toggleButton5->GetValue() ? wxString::Format(" -V '%s'", ptdirPath) : "";
        wxString zmdirPath = m_dirPathTextCtrl4->GetValue();
        zmdirPath = Command::NormalizePath(zmdirPath.ToStdString());
        wxString zmDir = !zmdirPath.IsEmpty() && m_toggleButton5->GetValue() ? wxString::Format(" --ASS '%s'", zmdirPath) : "";
        wxString encodingOption = m_toggleButton1->GetValue() ? " --embed-thumbnail --embed-metadata --embed-chapters --embed-info-json --compat-options no-keep-subs" : "";
        static const std::map<wxString, wxString> cookieOptions = {
            {wxString::FromUTF8("游客身份"), " --extractor-args \"youtube:player-client=web,default;player-skip=webpage,configs;po_token=web+PO_TOKEN_VALUE_HERE;visitor_data=VISITOR_DATA_VALUE_HERE\""},
            {wxString::FromUTF8("获取brave的cookie"), " --cookies-from-browser brave"},
            {wxString::FromUTF8("获取brave的cookie"), " --cookies-from-browser brave"},
            {wxString::FromUTF8("获取chrome的cookie"), " --cookies-from-browser chrome"},
            {wxString::FromUTF8("获取chromium的cookie"), " --cookies-from-browser chromium"},
            {wxString::FromUTF8("获取edge的cookie"), " --cookies-from-browser edge"},
            {wxString::FromUTF8("获取firefox的cookie"), " --cookies-from-browser firefox"},
            {wxString::FromUTF8("获取opera的cookie"), " --cookies-from-browser opera"},
            {wxString::FromUTF8("获取safari的cookie"), " --cookies-from-browser safari"},
            {wxString::FromUTF8("获取vivaldi的cookie"), " --cookies-from-browser vivaldi"},
            {wxString::FromUTF8("获取whale的cookie"), " --cookies-from-browser whale"}
        };
        wxString cookieOption = m_cookieChoice->GetStringSelection();
        auto it = cookieOptions.find(cookieOption);
        if (it != cookieOptions.end()) {
            cookieOption = it->second;
        } else {
            cookieOption = "";
        }
        if (!cookieOption.empty() && !cookiefilePath.empty()) {
        	cookiefilePath = "";
        	m_dirPathTextCtrl2->SetValue("");
        	AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("你已经选择了从浏览器自动获取cookie选项,导致cookie文件选项将自动取消."), 3000);
          dlg->Show();
        }
        wxString audioOption = m_toggleButton2->GetValue() ? " -x" : "";
        wxString playlistOption = m_toggleButton4->GetValue() ? " --yes-playlist" : " --no-playlist";
        wxString mp4Option = m_toggleButton3->GetValue() ? " --merge-output-format mp4" : "";
        wxString ptOption = m_toggleButton5->GetValue() ? " --use-postprocessor ZycaddptPP" : "";
        wxString videoqOptiond1 = m_qualityChoice->GetStringSelection();
        wxString videoqOptiond2 = m_qualityChoice2->GetStringSelection();
        wxString videoqOptiond;
        wxString videoqOption;
        if (!videoqOptiond1.Contains(wxString::FromUTF8("视频格式质量")) &&
            videoqOptiond2.Contains(wxString::FromUTF8("音频格式质量")))
        {
            videoqOption = wxString::Format(" -f '%s'", videoqOptions[videoqOptiond1]);
        }
        else if (videoqOptiond1.Contains(wxString::FromUTF8("视频格式质量")) &&
                 !videoqOptiond2.Contains(wxString::FromUTF8("音频格式质量")))
        {
            videoqOption = wxString::Format(" -f '%s'", videoqOptions2[videoqOptiond2]);
        }
        else
        {
            videoqOptiond = videoqOptiond1 + "+" + videoqOptiond2;
            videoqOption = videoqOptiond.Contains(wxString::FromUTF8("选择片源")) ? " -S ext" : wxString::Format(" -f \"%s+%s\"", videoqOptions[videoqOptiond1], videoqOptions2[videoqOptiond2]);
        }
        if (!videoqOption.IsEmpty() && m_toggleButton4->GetValue()) {
            if (m_toggleButton3->GetValue()) {
            	  videoqOption = " -S ext";
            }else{
                videoqOption = " -f 'bv+ba/b'";
            }
        	  AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("你选择了列表模式下载，下载媒体质量将会由程序自动选择最优"), 5000);
            dlg->Show();
        }
        wxRegEx regex("webm\\s+\\d{3,4}x\\d{3,4}.*video only");
        if (regex.Matches(videoqOptiond) && m_toggleButton5->GetValue() && !m_toggleButton3->GetValue()) {
              mp4Option = " --merge-output-format mp4";
              AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("添加片头和封面功能对webm格式文件无效，你选择了下载webm格式文件，输出文件将会封装成mp4文件"), 5000);
              dlg->Show();
        }
        if (m_toggleButton2->GetValue()) {
            videoqOption = "";
        }
        if (m_toggleButton2->GetValue()) {
            ptOption = "";
            ptDir = "";
            zmDir = "";
            videoqOption = " -S ext";
            if (m_toggleButton5->GetValue()) {
                AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("添加片头功能只对视频文件有效，你选择了只下载音频此功能将会自动取消"), 5000);
                 dlg->Show();
            }
        }
        if(ptDir == "" && zmDir == ""){
        	ptOption = "";
        }

        wxString h265tag = "";
        if (m_toggleButton9->GetValue()){
            if (m_toggleButton5->GetValue()){
                h265tag = " --h265";
            } else if (m_toggleButton3->GetValue()){
                h265tag = " --postprocessor-args '-c:v libx265 -crf 28 -preset fast'";
            } else {
                h265tag = " --use-postprocessor Zych265PP";
            }
        }
        wxString startplaytag = "";
        if (m_toggleButton6->GetValue()){
            startplaytag = " --exec 'open {}'";
        }

        wxString command;
        #ifdef _WIN32
            command = wxString::Format("python3 \"%s\" \"%s\"%s%s%s%s%s%s%s%s%s%s%s%s", afilePath, url, saveDir, ptDir, zmDir, audioOption, playlistOption, encodingOption, videoqOption, cookieOption, mp4Option, myproxy, cookiefilePath, ptOption);
        #else
            if (m_toggleButton8->GetValue()) {
              command = wxString::Format("/bin/bash -c \"%s '%s'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s --compat-options no-youtube-unavailable-videos\"", afilePath, url, aria2cpar, saveDir, ptDir, zmDir, audioOption, playlistOption, encodingOption, videoqOption, cookieOption, mp4Option, myproxy, cookiefilePath, ptOption, h265tag, startplaytag);
            }else{
            	command = wxString::Format("/bin/bash -c \"%s '%s'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s --compat-options no-youtube-unavailable-videos --extractor-arg 'youtube:player_client=tv' > /dev/null 2>&1\"", afilePath, url, aria2cpar, saveDir, ptDir, zmDir, audioOption, playlistOption, encodingOption, videoqOption, cookieOption, mp4Option, myproxy, cookiefilePath, ptOption, h265tag,startplaytag);
            }
        #endif
        //wxLogError(command);
        int refreshTime = 100;
        RunCommandWithOutput(command, refreshTime, saveDir);
        wxString filePathtxtw = wxString::Format("%s/cmd.txt",dirPath);
        std::ofstream outFile(filePathtxtw.ToStdString());
        if (!outFile) {
            #ifdef DEBUG
            std::cerr << "无法打开文件 " << filePathtxtw.ToStdString() << " 进行写入。" << std::endl;
            #endif
        }else{
            const std::string content = command.ToStdString();
            outFile << content;
            outFile.close();
        }
    }

    void MyFrame::OnStopButtonClick(wxCommandEvent&) {
        if (!m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载未开始"), 3000);
        	  dlg->Show();
            return;
        }
        if (m_ffmpeging) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经完成，正在本地转码，现在不能停止下载程序."), 3000);
            dlg->Show();
            return;
        }
        if (process->IsAlive()) {
            long pid = process->GetPid();
            if (pid > 0) {
                wxString cmd;
#ifdef __WXMSW__
                cmd = wxString::Format("taskkill /PID %d /F", pid);
#else
                if (m_toggleButton8->GetValue()) {
                    cmd = wxString::Format("sh -c \"ps -ef | grep yt-dlp | grep -v grep | awk '{print \\\"kill -15 \\\" $2}' | ps -ef | grep -i aria2 | grep -v grep | awk '{print \\\"kill -9 \\\" $2 %ld}'| sh\"",pid);
                }else{
                    cmd = wxString::Format("sh -c \"ps -ef | grep yt-dlp | grep -v grep | awk '{print \\\"kill -15 \\\" $2 %ld}' | sh\"",pid);
                }
#endif
                wxExecute(cmd, wxEXEC_SYNC | wxEXEC_HIDE_CONSOLE);
            }
            m_timer5.Stop();
            //m_timer->Stop();
            wxProcess::Kill(pid);
            process = nullptr;
            m_downloading = false;
            m_ffmpeging = false;
            m_outputTextCtrl->SetValue(wxString::FromUTF8("下载已停止"));
            startButton->SetLabel(wxString::FromUTF8("继续下载"));
        }
    }
    void MyFrame::ModifyDisplayToValueMap(const wxString& key, const wxString& newValue) {
        auto it = videoqOptions.find(key);
        if (it != videoqOptions.end()) {
            it->second = newValue;
        } else {
            MyFrame::AddDisplayToValueMap(key,newValue);
        }
    }
    void MyFrame::AddDisplayToValueMap(const wxString& key, const wxString& value) {
        if (videoqOptions.find(key) != videoqOptions.end()) {
            return;
        }
        videoqOptions[key] = value;
    }
    void MyFrame::AddChoice(const wxString& newChoice) {
        if (qualityChoices.Index(newChoice) == wxNOT_FOUND) {
            qualityChoices.Add(newChoice);
            m_qualityChoice->Append(newChoice);
        }
    }
    void MyFrame::ModifyDisplayToValueMap2(const wxString& key, const wxString& newValue) {
        auto it = videoqOptions2.find(key);
        if (it != videoqOptions2.end()) {
            it->second = newValue;
        } else {
            AddDisplayToValueMap2(key,newValue);
        }
    }
    void MyFrame::AddDisplayToValueMap2(const wxString& key, const wxString& value) {
        if (videoqOptions2.find(key) != videoqOptions2.end()) {
            return;
        }
        videoqOptions2[key] = value;
    }
    void MyFrame::AddChoice2(const wxString& newChoice) {
        if (qualityChoices2.Index(newChoice) == wxNOT_FOUND) {
            qualityChoices2.Add(newChoice);
            m_qualityChoice2->Append(newChoice);
        }
    }
    void MyFrame::extractResolution(const std::string& filePath) {
        std::ifstream file(filePath);
        if (!file.is_open()) {
            std::cerr << "Error: Could not open file." << std::endl;
            return;
        }
        std::string line;
        std::regex pattern(R"((\S+)\s+(mp4|webm)\s+(\d+x\d+)\s+(\d+)\s+(.*))");
        std::smatch match;
        std::regex pattern2(R"((\S+)\s+(mp4|webm)\s+audio\sonly(.*))");
        std::smatch match2;
        while (std::getline(file, line)) {
            if (std::regex_search(line, match, pattern)) {
                std::string videoid = match[1].str();
                MyFrame::AddChoice(wxString::FromUTF8(line));
                ModifyDisplayToValueMap(wxString::FromUTF8(line), wxString::FromUTF8(videoid));
            }else if (std::regex_search(line, match2, pattern2)) {
                std::string videoid = match2[1].str();
                MyFrame::AddChoice2(wxString::FromUTF8(line));
                MyFrame::ModifyDisplayToValueMap2(wxString::FromUTF8(line), wxString::FromUTF8(videoid));
            }
        }
        file.close();
    }
    void MyFrame::ReinitializeVideoChoice() {
            videoqOptions.clear();
            qualityChoices.Clear();
            m_qualityChoice->Clear();
            qualityChoices.Add(wxString::FromUTF8("选择片源视频格式质量"));
            qualityChoices.Add(wxString::FromUTF8("自动选优"));
            videoqOptions[wxString::FromUTF8("选择片源视频格式质量")] = wxString("");
            videoqOptions[wxString::FromUTF8("自动选优")] = wxString("bv+ba/b");
            m_qualityChoice->Append(qualityChoices);
            m_qualityChoice->SetSelection(0);
            videoqOptions2.clear();
            qualityChoices2.Clear();
            m_qualityChoice2->Clear();
            qualityChoices2.Add(wxString::FromUTF8("选择片源音频格式质量"));
            qualityChoices2.Add(wxString::FromUTF8("自动选优"));
            videoqOptions2[wxString::FromUTF8("选择片源音频格式质量")] = wxString("");
            videoqOptions2[wxString::FromUTF8("自动选优")] = wxString("bv+ba/b");
            m_qualityChoice2->Append(qualityChoices2);
            m_qualityChoice2->SetSelection(0);
    }
    void MyFrame::OnlookfButtonClick(wxCommandEvent&) {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxString ahomeDir = wxGetHomeDir();
        wxString afilePath = ahomeDir + "/zsprundir/bin/yt-dlp";
        wxString ffilename = ahomeDir + "/zsprundir/f.txt";
        afilePath = Command::NormalizePath(afilePath.ToStdString());
        ffilename = Command::NormalizePath(ffilename.ToStdString());
        std::string filePath = ffilename.ToStdString();
        wxString url = m_textCtrl->GetValue();
        if (url.IsEmpty()) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("请先输入下载网址"), 3000);
            dlg->Show();
            return;
        }
        if (url.Contains(wxT("@"))) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("不支持列表查询"), 3000);
            dlg->Show();
            return;
        }
        if (m_toggleButton4->GetValue()) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("你选择了列表模式下载，不支持手动选择下载媒体质量，下载媒体质量将会由程序自动选择最优"), 5000);
            dlg->Show();
            return;
        }
        if (!wxFileExists(ffilename)) {
            wxFile file(ffilename, wxFile::write);
            if (!file.IsOpened()) {
                #ifdef DEBUG
                std::cerr << "Failed to create file: " << ffilename << std::endl;
                #endif
            }
        }
        ReinitializeVideoChoice();
    	  lookfButton->SetLabel("");
        lookfButton->SetBitmap(m_frames[m_currentFrame]);
        m_timer4->Start(200);
        lookfButton->Enable(false);
        DisableChoice(m_qualityChoice,backgroundColor,textColor);
        DisableChoice(m_qualityChoice2,backgroundColor,textColor);
        wxString cookiefilePath0 = m_dirPathTextCtrl2->GetValue();
        wxString cookiefilePath = !cookiefilePath0.IsEmpty() ? wxString::Format(" --cookies '%s'", cookiefilePath0) : "";
        static const std::map<wxString, wxString> cookieOptions = {
            {wxString::FromUTF8("获取brave的cookie"), " --cookies-from-browser brave"},
            {wxString::FromUTF8("获取chrome的cookie"), " --cookies-from-browser chrome"},
            {wxString::FromUTF8("获取chromium的cookie"), " --cookies-from-browser chromium"},
            {wxString::FromUTF8("获取edge的cookie"), " --cookies-from-browser edge"},
            {wxString::FromUTF8("获取firefox的cookie"), " --cookies-from-browser firefox"},
            {wxString::FromUTF8("获取opera的cookie"), " --cookies-from-browser opera"},
            {wxString::FromUTF8("获取safari的cookie"), " --cookies-from-browser safari"},
            {wxString::FromUTF8("获取vivaldi的cookie"), " --cookies-from-browser vivaldi"},
            {wxString::FromUTF8("获取whale的cookie"), " --cookies-from-browser whale"}
        };
        wxString cookieOption = m_cookieChoice->GetStringSelection();
        auto it = cookieOptions.find(cookieOption);
        if (it != cookieOptions.end()) {
            cookieOption = it->second;
            m_dirPathTextCtrl2->SetValue("");
            cookiefilePath = "";
        } else {
            cookieOption = "";
        }
        if (!cookieOption.empty() && !cookiefilePath.empty()) {
        	cookiefilePath = "";
        }
        AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("正在向服务器发送请求请耐心等待返回结果。"), 10000);
        dlg->Show();
        m_outputTextCtrl->Clear();
        m_outputTextCtrl->AppendText("正在向服务器发送请求请耐心等待返回结果...\n");
        #ifdef _WIN32
            wxString command = wxString::Format("cmd.exe /c \"python3 \"%s\" \"%s\"%s%s -F --no-playlist > %s 2>&1\"", afilePath, url, cookieOption, cookiefilePath, ffilename);
            wxExecute(command, wxEXEC_SYNC | wxEXEC_HIDE_CONSOLE);
        #else
            wxString command = wxString::Format("/bin/bash -c \"%s '%s'%s%s -F --no-playlist > %s 2>&1\"", afilePath, url, cookieOption, cookiefilePath, ffilename);
            wxExecute(command, wxEXEC_SYNC);
        #endif
        MyFrame::extractResolution(filePath);
        lookfButton->Enable(true);
        EnableChoice(m_qualityChoice,backgroundColor,textColor);
        EnableChoice(m_qualityChoice2,backgroundColor,textColor);
        m_timer4->Stop();
        lookfButton->SetLabel(wxString::FromUTF8("查询片源格式质量"));
        if (isDarkMode) {
            lookfButton->SetBitmap(bitmapbubj2);
        }else{
            lookfButton->SetBitmap(bitmapbubj);
        }
        m_outputTextCtrl->Clear();
        m_outputTextCtrl->AppendText("查询片源格式质量完成\n");
    }
    void MyFrame::OnSelectDirButtonClick(wxCommandEvent&) {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxDirDialog dirDlg(this, wxString::FromUTF8("选择保存目录"), "", wxDD_DIR_MUST_EXIST);
        if (dirDlg.ShowModal() == wxID_OK) {
            wxString dirPath = dirDlg.GetPath();
            m_dirPath = dirPath;
            m_dirPathTextCtrl->SetValue(dirPath);

            wxString homeDir = wxGetHomeDir();
            wxString filenamept = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\pt_zplayer.txt") : wxString::Format(homeDir + "\\zsprundir\\pt_zplayer.txt");
            wxString filenamezm = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\zm_zplayer.txt") : wxString::Format(homeDir + "\\zsprundir\\zm_zplayer.txt");
            wxString filenameookie = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\cookie_zplayer.txt") : wxString::Format(homeDir + "\\zsprundir\\cookie_zplayer.txt");
            filenamept = Command::NormalizePath(filenamept.ToStdString());
            filenamezm = Command::NormalizePath(filenamezm.ToStdString());
            filenameookie = Command::NormalizePath(filenameookie.ToStdString());
            if(!ptfilePath.IsEmpty()){
                zycmd.saveToFile(filenamept.ToStdString(), ptfilePath.ToStdString());
            }
            if(!zmfilePath.IsEmpty()){
                zycmd.saveToFile(filenamezm.ToStdString(), zmfilePath.ToStdString());
            }
            wxString cmdFilePath = wxString::Format("%s/cmd.txt", dirPath);
            cmdFilePath =	Command::NormalizePath(cmdFilePath.ToStdString());
            if (wxFileExists(cmdFilePath)) {
                wxFile cmdFile(cmdFilePath, wxFile::read);
                if (cmdFile.IsOpened()) {
                    wxString newContent;
                    wxFileOffset fileSize = cmdFile.Length();
                    newContent.Alloc(fileSize);
                    char buf[1024];
                    size_t bytesRead;
                    while ((bytesRead = cmdFile.Read(buf, sizeof(buf))) > 0) {
                        newContent.Append(wxString(buf, wxConvUTF8, bytesRead));
                    }
                    std::string stdString = newContent.ToStdString();
                    zycmd.ReplaceAll(stdString, "\r\n", "\n");
                    zycmd.ReplaceAll(stdString, "aria2c:-x", "aria2c:");
                    newContent = wxString::FromUTF8(stdString);
                    wxString firstLine = newContent.BeforeFirst('\n');
                    int zfwz;
                    #ifdef _WIN32
                        zfwz = 2;
                    #else
                        zfwz = 3;
                    #endif
                    if (!firstLine.IsEmpty()) {
                        wxArrayString parts = wxSplit(firstLine, ' ');
                        if (parts.GetCount() > zfwz) {
                            stdString = wxString::FromUTF8(parts[zfwz]);
                            zycmd.ReplaceAll(stdString, "'", "");
                            zycmd.ReplaceAll(stdString, "\"", "");
                            wxString thirdPart = wxString::FromUTF8(stdString);
                            m_textCtrl->SetValue(thirdPart);
                        }else{
                        	  #ifdef DEBUG
                        	  std::cerr << "Error: 第一行的第三部分不存在" << std::endl;
                        	  #endif
                        }
                        if (firstLine.Contains(wxT("--yes-playlist"))) {
                        	m_toggleButton4->SetValue(true);
                        	m_toggleButton4->SetBitmapLabel(bitmapOn);
                          checkvideoSizer->Show(false);
                          checkvideoSizer2->Show(false);
                          wxSize currentSize = GetSize();
                          int newWidth = currentSize.GetWidth();
                          int newHeight = currentSize.GetHeight() - 120;
                          SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
                          content->Update();
                          content->Layout();
                          content->Refresh();
                        }else{
                        	m_toggleButton4->SetValue(false);
                        	m_toggleButton4->SetBitmapLabel(bitmapOff);
                          checkvideoSizer->Show(true);
                          checkvideoSizer2->Show(true);
                          wxSize currentSize = GetSize();
                          int newWidth = currentSize.GetWidth();
                          int newHeight = currentSize.GetHeight() + 120;
                          if (newHeight > 760) {
                              newHeight = 760;
                          }
                          SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
                          content->Update();
                          content->Layout();
                          content->Refresh();
                        }
                        if (firstLine.Contains(wxT("--embed-thumbnail"))) {
                        	m_toggleButton1->SetValue(true);
                        	m_toggleButton1->SetBitmapLabel(bitmapOn);
                        }else{
                        	m_toggleButton1->SetValue(false);
                        	m_toggleButton1->SetBitmapLabel(bitmapOff);
                        }
                        if (firstLine.Contains(wxT("-x"))) {
                        	m_toggleButton2->SetValue(true);
                        	m_toggleButton2->SetBitmapLabel(bitmapOn);
                          selectSizer->Show(false);
                          wxSize currentSize = GetSize();
                          int newWidth = currentSize.GetWidth();
                          int newHeight = currentSize.GetHeight() - 60;
                          SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
                          content->Update();
                          content->Layout();
                          content->Refresh();
                        }else{
                        	m_toggleButton2->SetValue(false);
                        	m_toggleButton2->SetBitmapLabel(bitmapOff);
                          wxSize currentSize = GetSize();
                          int newWidth = currentSize.GetWidth();
                          int newHeight = currentSize.GetHeight() + 60;
                          if (newHeight > 760) {
                              newHeight = 760;
                          }
                          SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
                          content->Update();
                          content->Layout();
                          content->Refresh();
                        }
                        if (firstLine.Contains(wxT("--merge-output-format mp4"))) {
                        	m_toggleButton3->SetValue(true);
                        	m_toggleButton3->SetBitmapLabel(bitmapOn);
                        }else{
                        	m_toggleButton3->SetValue(false);
                        	m_toggleButton3->SetBitmapLabel(bitmapOff);
                        }
                        if (firstLine.Contains(wxT("--use-postprocessor ZycaddptPP"))) {
                        	m_toggleButton5->SetValue(true);
                        	m_toggleButton5->SetBitmapLabel(bitmapOn);
                        	selectDirButton3->Enable(true);
                        	selectDirButton4->Enable(true);
                        	selectDirButton3->SetBitmap(bitmapbubj);
                        	selectDirButton4->SetBitmap(bitmapbubj);
                        	//m_dirPathTextCtrl3->Enable(true);
                        	//m_dirPathTextCtrl4->Enable(true);
                        }else{
                        	m_toggleButton5->SetValue(false);
                        	m_toggleButton5->SetBitmapLabel(bitmapOff);
                        	selectDirButton3->Enable(false);
                        	selectDirButton4->Enable(false);
                        	selectDirButton3->SetBitmap(bitmapbubj0);
                        	selectDirButton4->SetBitmap(bitmapbubj0);
                        	//m_dirPathTextCtrl3->Enable(false);
                        	//m_dirPathTextCtrl4->Enable(false);
                        }
                        if (firstLine.Contains(wxT("aria2c"))) {
                        	m_toggleButton8->SetValue(true);
                        	m_toggleButton8->SetBitmapLabel(bitmapOn);
                        }else{
                        	m_toggleButton8->SetValue(false);
                        	m_toggleButton8->SetBitmapLabel(bitmapOff);
                        }
                        if (firstLine.Contains(wxT("--extractor-args \"youtube:player-client=web,default;player-skip=webpage,configs;po_token=web+PO_TOKEN_VALUE_HERE;visitor_data=VISITOR_DATA_VALUE_HERE\""))) {
                        	m_cookieChoice->SetSelection(0);
                        }else if (firstLine.Contains(wxT("--cookies-from-browser brave"))) {
                        	m_cookieChoice->SetSelection(2);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser chrome"))) {
                        	m_cookieChoice->SetSelection(3);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser chromium"))) {
                        	m_cookieChoice->SetSelection(4);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser edge"))) {
                        	m_cookieChoice->SetSelection(5);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser firefox"))) {
                        	m_cookieChoice->SetSelection(6);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser opera"))) {
                        	m_cookieChoice->SetSelection(7);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser safari"))) {
                        	m_cookieChoice->SetSelection(8);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser vivaldi"))) {
                        	m_cookieChoice->SetSelection(9);
                        } else if (firstLine.Contains(wxT("--cookies-from-browser whale"))) {
                        	m_cookieChoice->SetSelection(10);
                        } else {
    	                    m_cookieChoice->SetSelection(0);
                        }
                      if (firstLine.Contains(wxT("--use-postprocessor ZycaddptPP"))) {
                        if (wxFileExists(filenamept)) {
                            std::string loadedDatapt = zycmd.loadFromFile(filenamept.ToStdString());
                            if (!loadedDatapt.empty()) {
                            	m_dirPathTextCtrl3->SetValue(loadedDatapt);
                            }
                        }
                        if (wxFileExists(filenamezm)) {
                            std::string loadedDatazm = zycmd.loadFromFile(filenamezm.ToStdString());
                            if (!loadedDatazm.empty()) {
                            	m_dirPathTextCtrl4->SetValue(loadedDatazm);
                            }
                        }
                      }
                      if (firstLine.Contains(wxT("--cookies")) && !firstLine.Contains(wxT("--cookies-from-browser"))) {
                        if (wxFileExists(filenameookie)) {
                            std::string loadedDatacookie = zycmd.loadFromFile(filenameookie.ToStdString());
                            if (!loadedDatacookie.empty()) {
                            	m_dirPathTextCtrl2->SetValue(loadedDatacookie);
                            }
                        }
                      }
                    }
                    cmdFile.Close();
                }
            }
        } else {
            //if (wxFileExists(filenamept)) {
            //	os.remove(filenamept)
            //}
            //if (wxFileExists(filenamezm)) {
            //    os.remove(filenamezm)
            //}
            m_dirPathTextCtrl->SetValue("");
            m_dirPathTextCtrl3->SetValue("");
            m_dirPathTextCtrl4->SetValue("");
        }
    }
    void MyFrame::OnSelectFileButtonClick(wxCommandEvent& event) {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxFileDialog openFileDialog(this, wxString::FromUTF8("选择cookie文件"), "", "",
                                    "Cookie Files (*.cookie;*.txt)|*.cookie;*.txt|All files (*.*)|*.*",
                                    wxFD_OPEN | wxFD_FILE_MUST_EXIST);
        if (openFileDialog.ShowModal() == wxID_CANCEL) {
            return;
        }
        wxString filePath2 = openFileDialog.GetPath();
        cookiefilePath2 = filePath2;
        m_dirPathTextCtrl2->SetValue(filePath2);
        wxString homeDir = wxGetHomeDir();
        wxString filename = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "/cookie_zplayer.txt") : wxString::Format(homeDir + "/zsprundir/cookie_zplayer.txt");
        filename =	Command::NormalizePath(filename.ToStdString());
        zycmd.saveToFile(filename.ToStdString(), cookiefilePath2.ToStdString());
    }
    void MyFrame::OnSelectPtButtonClick(wxCommandEvent& event) {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxFileDialog openFileDialog(this, wxString::FromUTF8("选择片头文件"), "", "",
                                    wxString::FromUTF8("媒体文件 (*.mp4;*.mov)|*.mp4;*.mov"),
                                    wxFD_OPEN | wxFD_FILE_MUST_EXIST);
        m_dirPathTextCtrl3->SetValue("");
        if (openFileDialog.ShowModal() == wxID_CANCEL) {
            return;
        }
        wxString filePath3 = openFileDialog.GetPath();
        ptfilePath = filePath3;
        m_dirPathTextCtrl3->SetValue(filePath3);
        wxString homeDir = wxGetHomeDir();
        wxString filename = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\pt_zplayer.txt") : wxString::Format(homeDir + "/zsprundir/pt_zplayer.txt");
        filename =	Command::NormalizePath(filename.ToStdString());
        zycmd.saveToFile(filename.ToStdString(), ptfilePath.ToStdString());
    }
    void MyFrame::OnSelectZmButtonClick(wxCommandEvent& event) {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxFileDialog openFileDialog(this, wxString::FromUTF8("选择字幕文件"), "", "",
                                    wxString::FromUTF8("字幕文件 (*.srt;*.ass;*.sub;*.vtt)|*.srt;*.ass;*.sub;*.vtt"),
                                    wxFD_OPEN | wxFD_FILE_MUST_EXIST);
        m_dirPathTextCtrl4->SetValue("");
        if (openFileDialog.ShowModal() == wxID_CANCEL) {
            return;
        }
        wxString filePath4 = openFileDialog.GetPath();
        zmfilePath = filePath4;
        m_dirPathTextCtrl4->SetValue(filePath4);
        wxString homeDir = wxGetHomeDir();
        wxString filename = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\zm_zplayer.txt") : wxString::Format(homeDir + "/zsprundir/zm_zplayer.txt");
        filename =	Command::NormalizePath(filename.ToStdString());
        zycmd.saveToFile(filename.ToStdString(), zmfilePath.ToStdString());
    }
    void MyFrame::UpdateGauge(double progress) {
        m_gauge->SetValue(static_cast<int>(progress));
    }
    void MyFrame::OnTimer2(wxTimerEvent&) {
        m_currentAdIndex = (m_currentAdIndex + 1) % adImages.size();
        const auto& [imageData, imageDataLen, imageLink] = adImages[m_currentAdIndex];
        wxMemoryInputStream memStream(imageData, imageDataLen);
        wxImage image(memStream, wxBITMAP_TYPE_PNG);
        if (image.IsOk()) {
            m_adBitmap->SetBitmap(wxBitmap(image));
            m_adBitmap->Refresh();
        } else {
            #ifdef DEBUG
            std::cerr << "Failed to load image from embedded data." << std::endl;
            #endif
        }
    }
    void MyFrame::OnTimer4(wxTimerEvent&) {
        m_currentFrame = (m_currentFrame + 1) % m_frames.size();
        lookfButton->SetBitmap(m_frames[m_currentFrame]);
    }
    void MyFrame::RunCommandWithOutput(const wxString& command, int refreshTime, const wxString& savedir) {
        process = new MyProcess(this,&m_timer5,this,savedir);
        long pid = wxExecute(command, wxEXEC_ASYNC, process);
        if (pid == 0) {
            m_outputTextCtrl->Clear();
            m_outputTextCtrl->AppendText("下载错误。\n");
            delete process;
            process = nullptr;
        } else {
            m_outputTextCtrl->Clear();
            m_outputTextCtrl->AppendText("开始下载...\n");
            m_timer5.Start(refreshTime);
        }
    }
    void MyFrame::OnTimer5(wxTimerEvent&) {
        if (process) {
            wxInputStream* stdoutStream = process->GetInputStream();
            wxInputStream* stderrStream = process->GetErrorStream();
            if (stdoutStream && stdoutStream->CanRead()) {
                wxTextInputStream textInput(*stdoutStream);
                wxString output = textInput.ReadLine();
                m_outputTextCtrl->Clear();
                m_outputTextCtrl->AppendText(output + "\n");
                double perprogress = ExtractProgressPercentage(output);
                if (perprogress >= 0) {
                    UpdateGauge(perprogress);
                }
            }
            if (stderrStream && stderrStream->CanRead()) {
                wxTextInputStream textInput(*stderrStream);
                wxString error = textInput.ReadLine();
                m_outputTextCtrl->Clear();
                m_outputTextCtrl->AppendText(error + "\n");
                double perprogress2 = ExtractProgressPercentage(error);
                if (perprogress2 >= 0) {
                    UpdateGauge(perprogress2);
                }
            }
            if (!process->IsAlive()) {
                m_timer5.Stop();
                delete process;
                process = nullptr;
                m_downloading = false;
                m_ffmpeging = false;
                //m_timer->Stop();
                startButton->SetLabel(wxString::FromUTF8("下载"));
                m_gauge->SetValue(static_cast<int>(100));
                m_outputTextCtrl->AppendText(wxString::Format("所有任务已完成。"));
            }
        }
    }

    void MyFrame::OnAdBitmapClick(wxMouseEvent& event) {
        const auto& [imageData, imageDataLen, adLink] = adImages[m_currentAdIndex];
        wxLaunchDefaultBrowser(adLink);
    }
    void MyFrame::OnClose(wxCloseEvent& event) {
        this->SetWindowStyle(this->GetWindowStyle() & ~wxSTAY_ON_TOP);
        this->Iconize(true);
    }
    void MyFrame::OnToggleButtonClick(wxCommandEvent& event)
    {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxBitmapToggleButton* clickedButton = dynamic_cast<wxBitmapToggleButton*>(event.GetEventObject());
        if (clickedButton->GetValue()) {
            clickedButton->SetBitmapLabel(bitmapOn);
        } else {
            clickedButton->SetBitmapLabel(bitmapOff);
        }
    }
    void MyFrame::OnToggleButtonClick2(wxCommandEvent& event)
    {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxBitmapToggleButton* clickedButton = dynamic_cast<wxBitmapToggleButton*>(event.GetEventObject());
        if (clickedButton->GetValue()) {
            clickedButton->SetBitmapLabel(bitmapOn);
            selectDirButton3->Enable(true);
            selectDirButton4->Enable(true);
            selectDirButton3->SetBitmap(bitmapbubj);
            selectDirButton4->SetBitmap(bitmapbubj);
            //m_dirPathTextCtrl3->Enable(true);
            //m_dirPathTextCtrl4->Enable(true);
        } else {
            clickedButton->SetBitmapLabel(bitmapOff);
            selectDirButton3->Enable(false);
            selectDirButton4->Enable(false);
            selectDirButton3->SetBitmap(bitmapbubj0);
            selectDirButton4->SetBitmap(bitmapbubj0);
            m_dirPathTextCtrl3->SetValue("");
            m_dirPathTextCtrl4->SetValue("");

            wxString homeDir = wxGetHomeDir();
            wxString filenamept = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\pt_zplayer.txt") : wxString::Format(homeDir + "\\zsprundir\\pt_zplayer.txt");
            wxString filenamezm = !m_dirPath.IsEmpty() ? wxString::Format(m_dirPath + "\\zm_zplayer.txt") : wxString::Format(homeDir + "\\zsprundir\\zm_zplayer.txt");
            filenamept = Command::NormalizePath(filenamept.ToStdString());
            filenamezm = Command::NormalizePath(filenamezm.ToStdString());
            if (wxFileExists(filenamept)) {
                zycmd.ForceDeleteFile(filenamept.ToStdString());
            }
            if (wxFileExists(filenamezm)) {
                zycmd.ForceDeleteFile(filenamezm.ToStdString());
            }
            //m_dirPathTextCtrl3->Enable(false);
            //m_dirPathTextCtrl4->Enable(false);
        }
    }
    void MyFrame::OnToggleButtonClick3(wxCommandEvent& event)
    {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxBitmapToggleButton* clickedButton = dynamic_cast<wxBitmapToggleButton*>(event.GetEventObject());
        if (clickedButton->GetValue()) {
            clickedButton->SetBitmapLabel(bitmapOn);
            if (m_toggleButton5->GetValue()){
                wxCommandEvent event(wxEVT_TOGGLEBUTTON, m_toggleButton5->GetId());
                event.SetEventObject(m_toggleButton5);
                m_toggleButton5->SetValue(!m_toggleButton5->GetValue());
                wxPostEvent(m_toggleButton5, event);
            }
            m_toggleButton5->Enable(false);
            selectSizer->Show(false);
            wxSize currentSize = GetSize();
            int newWidth = currentSize.GetWidth();
            int newHeight = currentSize.GetHeight() - 60;
            SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
            content->Update();
            content->Layout();
            content->Refresh();
        } else {
            clickedButton->SetBitmapLabel(bitmapOff);
            m_toggleButton5->Enable(true);
            selectSizer->Show(true);
            wxSize currentSize = GetSize();
            int newWidth = currentSize.GetWidth();
            int newHeight = currentSize.GetHeight() + 60;
            if (newHeight > 760) {
                newHeight = 760;
            }
            SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
            content->Update();
            content->Layout();
            content->Refresh();
        }
    }
    void MyFrame::DisableChoice(wxComboBox* choice, const wxColour& bgColour, const wxColour& textColour)
    {
        choice->Bind(wxEVT_LEFT_DOWN, &MyFrame::IgnoreClick, this);
        choice->Bind(wxEVT_LEFT_DCLICK, &MyFrame::IgnoreClick, this);
    }
    void MyFrame::EnableChoice(wxComboBox* choice, const wxColour& bgColour, const wxColour& textColour)
    {
        choice->Unbind(wxEVT_LEFT_DOWN, &MyFrame::IgnoreClick, this);
        choice->Unbind(wxEVT_LEFT_DCLICK, &MyFrame::IgnoreClick, this);
    }
    void MyFrame::IgnoreClick(wxMouseEvent& event) {
        event.Skip(false);
    }
    void MyFrame::OnToggleButtonClick4(wxCommandEvent& event)
    {
        if (m_downloading) {
            AutoCloseDialog* dlg = new AutoCloseDialog(this, wxString::FromUTF8("下载已经开始"), 3000);
            dlg->Show();
            return;
        }
        wxBitmapToggleButton* clickedButton = dynamic_cast<wxBitmapToggleButton*>(event.GetEventObject());
        if (clickedButton->GetValue()) {
            clickedButton->SetBitmapLabel(bitmapOn);
            checkvideoSizer->Show(false);
            checkvideoSizer2->Show(false);
            wxSize currentSize = GetSize();
            int newWidth = currentSize.GetWidth();
            int newHeight = currentSize.GetHeight() - 120;
            SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
            content->Update();
            content->Layout();
            content->Refresh();
        } else {
            clickedButton->SetBitmapLabel(bitmapOff);
            checkvideoSizer->Show(true);
            checkvideoSizer2->Show(true);
            wxSize currentSize = GetSize();
            int newWidth = currentSize.GetWidth();
            int newHeight = currentSize.GetHeight() + 120;
            if (newHeight > 760) {
                newHeight = 760;
            }
            SetSize(wxMax(newWidth, 800), wxMax(newHeight, 480));
            content->Update();
            content->Layout();
            content->Refresh();
        }
    }
    void MyFrame::OnToggleButtonClick5(wxCommandEvent& event)
    {
        wxBitmapToggleButton* clickedButton = dynamic_cast<wxBitmapToggleButton*>(event.GetEventObject());
        if (clickedButton->GetValue()) {
            isDarkMode = true;
            backgroundColor = isDarkMode ? wxColour(36, 36, 36) : wxColour(242, 242, 242);
            textColor = isDarkMode ? wxColour(242, 242, 242) : wxColour(36, 36, 36);
            customColor = isDarkMode ? wxColour(128, 128, 128) : wxColour(230, 230, 230);
            customColor2 = isDarkMode ? wxColour(168, 168, 168) : wxColour(242, 242, 242);
            if (isDarkMode){
                wxMemoryInputStream memStreamOn(imageon1_png, imageon1_png_len);
                wxMemoryInputStream memStreamOff(imageoff1_png, imageoff1_png_len);
                wxImage imageOn(memStreamOn, wxBITMAP_TYPE_PNG);
                wxImage imageOff(memStreamOff, wxBITMAP_TYPE_PNG);
                if (imageOn.IsOk() && imageOff.IsOk()) {
                    wxImage scaledImageOn = imageOn.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOn = wxBitmap(scaledImageOn);
                    wxImage scaledImageOff = imageOff.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOff = wxBitmap(scaledImageOff);
                }
                Command::SetColorsAndStylesRecursive(this, textColor, backgroundColor, customColor, customColor2, true);
            }else{
                wxMemoryInputStream memStreamOn(imageon_png, imageon_png_len);
                wxMemoryInputStream memStreamOff(imageoff_png, imageoff_png_len);
                wxImage imageOn(memStreamOn, wxBITMAP_TYPE_PNG);
                wxImage imageOff(memStreamOff, wxBITMAP_TYPE_PNG);
                if (imageOn.IsOk() && imageOff.IsOk()) {
                    wxImage scaledImageOn = imageOn.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOn = wxBitmap(scaledImageOn);
                    wxImage scaledImageOff = imageOff.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOff = wxBitmap(scaledImageOff);
                }
                Command::SetColorsAndStylesRecursive(this, textColor, backgroundColor, customColor, customColor2, false);
            }
            clickedButton->SetBitmapLabel(bitmapOn);
            std::string yyyy = "true";
            wxString homeDir = wxGetHomeDir();
            wxString filename = wxString::Format(homeDir + "/zsprundir/dark_zplayer.txt");
            zycmd.saveToFile(filename.ToStdString(), yyyy);
        } else {
            isDarkMode = false;
            backgroundColor = isDarkMode ? wxColour(36, 36, 36) : wxColour(242, 242, 242);
            textColor = isDarkMode ? wxColour(242, 242, 242) : wxColour(36, 36, 36);
            customColor = isDarkMode ? wxColour(128, 128, 128) : wxColour(230, 230, 230);
            customColor2 = isDarkMode ? wxColour(36, 36, 36) : wxColour(242, 242, 242);
            if (isDarkMode){
                wxMemoryInputStream memStreamOn(imageon1_png, imageon1_png_len);
                wxMemoryInputStream memStreamOff(imageoff1_png, imageoff1_png_len);
                wxImage imageOn(memStreamOn, wxBITMAP_TYPE_PNG);
                wxImage imageOff(memStreamOff, wxBITMAP_TYPE_PNG);
                if (imageOn.IsOk() && imageOff.IsOk()) {
                    wxImage scaledImageOn = imageOn.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOn = wxBitmap(scaledImageOn);
                    wxImage scaledImageOff = imageOff.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOff = wxBitmap(scaledImageOff);
                }
                Command::SetColorsAndStylesRecursive(this, textColor, backgroundColor, customColor, customColor2, true);
            }else{
                wxMemoryInputStream memStreamOn(imageon_png, imageon_png_len);
                wxMemoryInputStream memStreamOff(imageoff_png, imageoff_png_len);
                wxImage imageOn(memStreamOn, wxBITMAP_TYPE_PNG);
                wxImage imageOff(memStreamOff, wxBITMAP_TYPE_PNG);
                if (imageOn.IsOk() && imageOff.IsOk()) {
                    wxImage scaledImageOn = imageOn.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOn = wxBitmap(scaledImageOn);
                    wxImage scaledImageOff = imageOff.Rescale(30, 30, wxIMAGE_QUALITY_HIGH);
                    bitmapOff = wxBitmap(scaledImageOff);
                }
                Command::SetColorsAndStylesRecursive(this, textColor, backgroundColor, customColor, customColor2, false);
            }
            clickedButton->SetBitmapLabel(bitmapOff);
            std::string yyyy = "false";
            wxString homeDir = wxGetHomeDir();
            wxString filename = wxString::Format(homeDir + "/zsprundir/dark_zplayer.txt");
            zycmd.saveToFile(filename.ToStdString(), yyyy);
        }
        m_gauge->SetBackgroundAndForeground(backgroundColor,textColor);
        if (m_toggleButton1->GetValue()) {
            m_toggleButton1->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton1->SetBitmapLabel(bitmapOff);
        }
        if (m_toggleButton2->GetValue()) {
            m_toggleButton2->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton2->SetBitmapLabel(bitmapOff);
        }
        if (m_toggleButton3->GetValue()) {
            m_toggleButton3->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton3->SetBitmapLabel(bitmapOff);
        }
        if (m_toggleButton4->GetValue()) {
            m_toggleButton4->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton4->SetBitmapLabel(bitmapOff);
        }
        if (m_toggleButton5->GetValue()) {
            m_toggleButton5->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton5->SetBitmapLabel(bitmapOff);
        }
        if (m_toggleButton6->GetValue()) {
            m_toggleButton6->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton6->SetBitmapLabel(bitmapOff);
        }
        if (m_toggleButton8->GetValue()) {
            m_toggleButton8->SetBitmapLabel(bitmapOn);
        }else{
            m_toggleButton8->SetBitmapLabel(bitmapOff);
        }
        content->Update();
        content->Layout();
        content->Refresh();
    }
    void MyFrame::OnTextCtrlKeyDown(wxKeyEvent& event) {
        if (event.GetModifiers() & wxMOD_CONTROL && event.GetKeyCode() == 'A') {
            wxTextCtrl* textCtrl = dynamic_cast<wxTextCtrl*>(event.GetEventObject());
            if (textCtrl) {
                textCtrl->SelectAll();
                event.Skip(false);
            }
        } else {
            event.Skip();
        }
    }

    double MyFrame::ExtractProgressPercentage(const wxString& output) {
        wxRegEx fragRegex("frag (\\d+)/(\\d+)");
        wxRegEx percentRegex("\\[download\\] .*? (\\d+\\.\\d+)%");
        wxRegEx percentRegex2("\\[(\\d+\\.\\d+)%\\]");
        wxRegEx percentRegex3("\\[EmbedThumbnail\\](.*?)");
        wxRegEx percentRegex4("\\[Metadata\\](.*?)");
        wxRegEx percentRegex5("\\[FixupM4a\\](.*?)");
        wxRegEx percentRegex6("\\[ExtractAudio\\](.*?)");
        wxRegEx percentRegex7("\\[Merger\\](.*?)");
        wxRegEx percentRegex8("\\[.*?\\((\\d+)%\\)");
        wxRegEx percentRegex9("\\[.*?\\[(\\d+\\.\\d+)%\\]");
        wxRegEx percentRegex10(".*?\\[(ffmpeg)");
        wxRegEx percentRegex11(".*?(bitrate)");
        wxString currentFragStr, totalFragStr;
        wxString percentStr;
        wxString cleanOutput = output;
        wxRegEx ansiEscapeRegex("\\x1B\\[[0-9;]*m");
        while (ansiEscapeRegex.Matches(cleanOutput)) {
            cleanOutput.Replace(ansiEscapeRegex.GetMatch(cleanOutput, 0), wxEmptyString);
        }
        m_ffmpeging = false;
        try {
            if (percentRegex10.Matches(cleanOutput) || percentRegex11.Matches(cleanOutput)) {
                m_ffmpeging = true;
                return 90.0;
            }
            if (fragRegex.Matches(cleanOutput)) {
                currentFragStr = fragRegex.GetMatch(cleanOutput, 1);
                totalFragStr = fragRegex.GetMatch(cleanOutput, 2);
                long currentFrag = wxAtol(currentFragStr);
                long totalFrag = wxAtol(totalFragStr);
                if (totalFrag > 0) {
                    return (static_cast<double>(currentFrag) / totalFrag) * 100.0;
                }
            } else if (percentRegex.Matches(cleanOutput)) {
                percentStr = percentRegex.GetMatch(cleanOutput, 1);
                return std::stod(percentStr.ToStdString());
            } else if (percentRegex8.Matches(cleanOutput)) {
                percentStr = percentRegex8.GetMatch(cleanOutput, 1);
                return std::stod(percentStr.ToStdString());
            } else if (percentRegex9.Matches(cleanOutput)) {
                m_ffmpeging = true;
                percentStr = percentRegex9.GetMatch(cleanOutput, 1);
                return std::stod(percentStr.ToStdString());
            } else if (percentRegex2.Matches(cleanOutput)) {
                m_ffmpeging = true;
                return 90.0;
            } else if (percentRegex3.Matches(cleanOutput) || percentRegex4.Matches(cleanOutput) || percentRegex5.Matches(cleanOutput) || percentRegex6.Matches(cleanOutput) || percentRegex7.Matches(cleanOutput)) {
                m_ffmpeging = true;
                return 90.0;
            }
        } catch (const std::exception& e) {
            return -1;
        }
        return -1;
    }
