#include "ThemeListener.h"
#include <wx/wx.h>
#include <wx/sysopt.h>
#include <wx/stdpaths.h>
#include <openssl/md5.h>
#include <curl/curl.h>
#include <filesystem>
#include <wx/string.h>
#include <wx/filesys.h>
#include <string>
namespace fs = std::filesystem;
#include "Command.h"
bool isDarkMode;
wxString m_filePath;
Command zycmd;
size_t WriteCallback(void* contents, size_t size, size_t nmemb, void* userp) {
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}
void CheckAndCopyDirectory(wxWindow* parent) {
    wxString homeDir = wxGetHomeDir();
    wxString myPath = homeDir + "/zsprundir";
    wxStandardPaths& stdPaths = wxStandardPaths::Get();
    wxString resourceDir = stdPaths.GetResourcesDir() + "/zsprundir";
    wxString ffmpegfile1 = stdPaths.GetResourcesDir() + "/zsprundir/bin/ffmpeg";
    std::string ffmpegfile = ffmpegfile1.ToStdString();
    wxString ffprobefle1 = stdPaths.GetResourcesDir() + "/zsprundir/bin/ffprobe";
    std::string ffprobefle = ffprobefle1.ToStdString();
    wxString ytdlpfile1 = stdPaths.GetResourcesDir() + "/zsprundir/bin/yt-dlp";
    std::string ytdlpfile = ytdlpfile1.ToStdString();
    wxString aria2cfile1 = stdPaths.GetResourcesDir() + "/zsprundir/bin/aria2c";
    std::string aria2cfile = aria2cfile1.ToStdString();
    wxString executablePath = stdPaths.GetExecutablePath();
    std::string filename = executablePath.ToStdString();
    wxString filenametemp1 = filename + ".temp";
    std::string filenametemp = filenametemp1.ToStdString();
    wxString filenamebak1 = filename + ".bak";
    std::string filenamebak = filenamebak1.ToStdString();
    std::string md5 = zycmd.getFileMD5(filename);
    #ifdef DEBUG
    std::cout << "MD5a: " << md5 << std::endl;
    #endif
    wxString logMessage = wxString::Format("MD5: %s", md5);
    CURL* curl;
    CURLcode res;
    std::string readBuffer;
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "https://mv.6deng.cn:8443/zspdl/zspdlmd52");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            #ifdef DEBUG
            std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
            #endif
        } else {
            #ifdef DEBUG
            std::cout << "MD5a2: " << readBuffer << std::endl;
            #endif
            std::string newmd5 = readBuffer;
            wxString logMessage2 = wxString::Format("MD5: %s", newmd5);
            if (logMessage2 != logMessage) {
                wxMessageDialog* dialog = new wxMessageDialog(parent,
                                                              wxT("主程序正在升级，请稍候..."),
                                                              wxT("提示"),
                                                              wxOK | wxICON_INFORMATION);
                dialog->ShowModal();  // 显示对话框
                std::string url = "https://mv.6deng.cn:8443/zspdl/ytui";
                std::string url1 = "https://mv.6deng.cn:8443/zspdl/ffmpeg";
                std::string url2 = "https://mv.6deng.cn:8443/zspdl/ffprobe";
                std::string url3 = "https://mv.6deng.cn:8443/zspdl/yt-dlp_mac";
                std::string url4 = "https://mv.6deng.cn:8443/zspdl/aria2c_mac";
                if (zycmd.downloadFile(url, filenametemp)) {
                    #ifdef DEBUG
                    std::cout << "File downloaded and saved as " << filenametemp << std::endl;
                    #endif
                    try {
                        auto fileSize = fs::file_size(filenametemp);
                        if (fileSize > 3 * 1024 * 1024) {
                            if (fs::exists(filenamebak)) {
                                fs::remove(filenamebak);
                            }
                            fs::rename(filename, filenamebak);
                            fs::rename(filenametemp, filename);
                            fs::permissions(filename, fs::perms::owner_exec | fs::perms::group_exec | fs::perms::others_exec, fs::perm_options::add);
                            #ifdef DEBUG
                            std::cout << "File renamed successfully!" << std::endl;
                            #endif
                            int result1,result2,result3,result4;
                            if (zycmd.downloadFile(url1, ffmpegfile)){
                            	std::string command = "chmod +x " + ffmpegfile;
                            	result1 = std::system(command.c_str());
                            }
                            if (zycmd.downloadFile(url2, ffprobefle)) {
                            	std::string command1 = "chmod +x " + ffprobefle;
                            	result2 = std::system(command1.c_str());
                            }
                            if (zycmd.downloadFile(url3, ytdlpfile)) {
                            	std::string command2 = "chmod +x " + ytdlpfile;
                            	result3 = std::system(command2.c_str());
                            }
                            if (zycmd.downloadFile(url4, aria2cfile)) {
                            	std::string command3 = "chmod +x " + aria2cfile;
                            	result4 = std::system(command3.c_str());
                            }
                            dialog->EndModal(wxID_OK);  // 关闭对话框
                            if(result1 == 0 && result2 == 0 && result3 == 0 && result4 == 0){
                                wxMessageBox("主程序已经升级完成，下次启动后生效。 ", "提示", wxOK | wxICON_INFORMATION);
                                zycmd.CopyDirectoryRecursive(resourceDir, myPath);
                            }else{
                                wxMessageBox("自动升级失败，请前往https://mv.6deng.cn:8443/app/熊猫下载.app下载。", "提示", wxOK | wxICON_INFORMATION);
                            }
                        }else{
                        	fs::remove(filenametemp);
                        	dialog->EndModal(wxID_OK);  // 关闭对话框
                          wxMessageBox("自动升级失败，请前往https://mv.6deng.cn:8443/app/熊猫下载.app下载。", "提示", wxOK | wxICON_INFORMATION);
                        }
                    } catch (const fs::filesystem_error& e) {
                        if (fs::exists(filenametemp)) {
                            fs::remove(filenametemp);
                        }
                        dialog->EndModal(wxID_OK);  // 关闭对话框
                        wxMessageBox("自动升级失败，请前往https://mv.6deng.cn:8443/app/熊猫下载.app下载。", "提示", wxOK | wxICON_INFORMATION);
                        #ifdef DEBUG
                        std::cerr << "Error: " << e.what() << std::endl;
                        #endif
                    }
                } else {
                    if (fs::exists(filenametemp)) {
                        fs::remove(filenametemp);
                    }
                    dialog->EndModal(wxID_OK);
                    wxMessageBox("自动升级失败，请前往https://mv.6deng.cn:8443/app/熊猫下载.app下载。", "提示", wxOK | wxICON_INFORMATION);
                }
                delete dialog;
            }
        }
       curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    if (!wxDirExists(myPath)) {
        zycmd.CopyDirectoryRecursive(resourceDir, myPath);
    }
}
wxPanel* content;
bool MyApp::OnInit()
{
    const std::string CYAN = "\033[1;36m";
    const std::string RESET = "\033[0m";
    const std::string pythonPath = "/usr/local/bin/python3"; // Homebrew Python 路径
    Command::SetupEnvironment();
    Command::CheckPythonInstallation(pythonPath);
    //std::string output;
    //if (Command::ExecCommand("command -v /usr/local/bin/python3 > /dev/null 2>&1", &output) == 0 &&
    //    Command::CheckPip(pythonPath) &&
    //    Command::CheckPythonVersion(pythonPath)) {
    //    std::cout << CYAN << "Python 3.10 found!" << RESET << std::endl;
    //} else {
    //    std::cerr << CYAN << "Python 3.10 or pip not found! Please install manually.and python3 -m ensurepip --upgrade" << RESET << std::endl;
    //    wxMessageBox("Python 3.10 or pip not found! Please install manually.and python3 -m ensurepip --upgrade", "提示", wxOK | wxICON_INFORMATION);
    //    return 1;
    //}
    std::vector<std::pair<std::string, std::string>> packages = {
        {"requests", ""},
        {"foundation", "Foundation"},
        {"ttkbootstrap", ""},
        {"localStoragePy", ""},
        {"execjs", "PyExecJS"},
        {"fake_useragent", "fake_useragent"}
    };
    for (const auto& pkg : packages) {
        try {
            Command::InstallPythonPackage(pythonPath, pkg.first, pkg.second);
        } catch (const std::exception& e) {
            std::cerr << "Error: " << e.what() << std::endl;
            wxMessageBox(e.what(), "提示", wxOK | wxICON_INFORMATION);
        }
    }

    if (m_frame) {
    	Command cmd;
      if (cmd.CheckRun(m_frame)){
      	return true;
      }
    };
//    wxSystemOptions::SetOption("msw.remap", 2);
//#ifdef _WIN32
//    m_checker = new wxSingleInstanceChecker(wxT("ytui_unique_instance_checker"));
//    if (m_checker->IsAnotherRunning())
//    {
//        HWND hwnd = FindWindow(NULL, wxT("熊猫下载v1.0.1[让一切视听自由分享]"));
//        if (m_frame)
//        {
//            m_frame->Show(true);
//            m_frame->Raise();
//        }
//        if (hwnd)
//        {
//            SetForegroundWindow(hwnd);
//            ShowWindow(hwnd, SW_RESTORE);
//        }
//        return false;
//    }
//#else
//    m_checker = new wxSingleInstanceChecker(wxT("ytui_unique_instance_checker"));
//    if (m_checker->IsAnotherRunning())
//    {
//        if (m_frame) {
//            if (m_frame->IsShown()) {
//                m_frame->Hide();
//            } else {
//                m_frame->Show(true);
//                m_frame->Raise();
//            }
//        }
//        return true;
//    }
//#endif
wxInitAllImageHandlers(); // 初始化图像处理
    wxString homeDir = wxGetHomeDir();
    wxString runtimefilePath = homeDir + "/zsprundir/zsp_f_*.txt";
    zycmd.ForceDeleteFile(runtimefilePath.ToStdString());
    wxString runtimefilePath1 = homeDir + "/zsprundir/zsp_p_*.txt";
    zycmd.ForceDeleteFile(runtimefilePath1.ToStdString());
    wxString runtimefilePath2 = homeDir + "/zsprundir/f.txt";
    zycmd.ForceDeleteFile(runtimefilePath2.ToStdString());
    wxString myPath = homeDir + "/zsprundir/bin";
    myPath = Command::NormalizePath(myPath.ToStdString());
    zycmd.AddToLibraryPath(myPath);
    #ifdef _WIN32
        wxString myPath2 = homeDir + "/zsprundir/dllpath";
        myPath2 = Command::NormalizePath(myPath2.ToStdString());
        zycmd.AddToLibraryPath(myPath2);
    #endif
    wxString filename = wxString::Format(homeDir + "/zsprundir/dark_zplayer.txt");
    filename = Command::NormalizePath(filename.ToStdString());
    if (wxFileExists(filename)) {
        std::string loadedData = zycmd.loadFromFile(filename.ToStdString());
        if (!loadedData.empty()) {
            isDarkMode =  zycmd.stringToBool(loadedData);
        }
    } else {
       isDarkMode = Command::IsDarkMode();
    }
    m_frame = new MyFrame();
    m_frame->Show(true);
    m_taskBarIcon = new MyTaskBarIcon(m_frame);
    Command::SetColorsAndStylesRecursiveN(m_frame, content);
    m_frame->SetWindowStyle(m_frame->GetWindowStyle() | wxSTAY_ON_TOP);
    ThemeListener m_themeListener;
    m_themeListener.Register();// 注册主题监听
    CheckAndCopyDirectory(m_frame);
    return true;
}
int MyApp::OnExit()
{
    delete m_checker;
    delete m_taskBarIcon;
    wxString homeDir = wxGetHomeDir();
    wxString runtimefilePath = homeDir + "/zsprundir/zsp_f_*.txt";
    zycmd.ForceDeleteFile(runtimefilePath.ToStdString());
    wxString runtimefilePath1 = homeDir + "/zsprundir/zsp_p_*.txt";
    zycmd.ForceDeleteFile(runtimefilePath1.ToStdString());
    wxString runtimefilePath2 = homeDir + "/zsprundir/f.txt";
    zycmd.ForceDeleteFile(runtimefilePath2.ToStdString());
    return wxApp::OnExit();
}
wxIMPLEMENT_APP(MyApp);;