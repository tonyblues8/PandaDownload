#include "MyTaskBarIcon.h"
#include "Command.h"
#include <wx/msgdlg.h>
#include <wx/utils.h>
#define MY_BASE_ID (wxID_HIGHEST + 1)
enum {
    ID_MY_CUSTOM_ACTION = MY_BASE_ID,
    ID_ANOTHER_ACTION,
    ID_HELP,
    ID_ZDELV,
    ID_ABOUT,
    ID_SHOW_HIDE,
    ID_EXIT
};

wxBEGIN_EVENT_TABLE(MyTaskBarIcon, wxTaskBarIcon)
    EVT_MENU(wxID_EXIT, MyTaskBarIcon::OnExit)
    EVT_MENU(wxID_HELP, MyTaskBarIcon::OnHelp)
    EVT_MENU(wxID_ABOUT, MyTaskBarIcon::OnUsef)
    EVT_MENU(ID_MY_CUSTOM_ACTION, MyTaskBarIcon::OnLeftClicka)
    EVT_MENU(ID_ZDELV, MyTaskBarIcon::Runpandav)
    EVT_TASKBAR_LEFT_DCLICK(MyTaskBarIcon::OnLeftDoubleClick)
wxEND_EVENT_TABLE()

MyTaskBarIcon::MyTaskBarIcon(wxFrame* frame)
    : m_frame(frame) {
    wxMemoryInputStream memStreamIcon(icon_png, icon_png_len);
    wxImage imageIcon(memStreamIcon, wxBITMAP_TYPE_PNG);
    if (imageIcon.IsOk()) {
        wxIcon icon;
        icon.CopyFromBitmap(wxBitmap(imageIcon));
        SetIcon(icon, wxString::FromUTF8("熊猫下载v1.0.0"));
    }
}

wxMenu* MyTaskBarIcon::CreatePopupMenu() {
        wxMenu* menu = new wxMenu();
        menu->Append(wxID_HELP, wxString::FromUTF8("关于"));
        menu->Append(wxID_ABOUT, wxString::FromUTF8("帮助"));
        menu->AppendSeparator(); // 添加分割线
        menu->Append(ID_MY_CUSTOM_ACTION, wxString::FromUTF8("显示/隐藏"));
        menu->AppendSeparator(); // 添加分割线
        menu->Append(ID_ZDELV, wxString::FromUTF8("熊猫剪切"));
        menu->AppendSeparator(); // 添加分割线
        menu->Append(wxID_EXIT, wxString::FromUTF8("退出"));
        return menu;
}

void MyTaskBarIcon::OnExit(wxCommandEvent& event) {
    wxMessageDialog dialog(m_frame->IsShown() ? m_frame : m_frame2,
                           "确认结束程序?", "确认信息", wxYES_NO | wxICON_QUESTION);
    dialog.SetWindowStyle(dialog.GetWindowStyle() | wxSTAY_ON_TOP);
    if (dialog.ShowModal() == wxID_YES) {
        wxApp::GetInstance()->ExitMainLoop();
    }
}

void MyTaskBarIcon::OnHelp(wxCommandEvent& event) {
    m_frame->SetWindowStyle(m_frame->GetWindowStyle() & ~wxSTAY_ON_TOP);
    wxLaunchDefaultBrowser(wxString::FromUTF8("https://mv.6deng.cn:8443/mobile/app"));
}

void MyTaskBarIcon::OnUsef(wxCommandEvent& event) {
    //wxMessageBox("ok1", "提示", wxOK | wxICON_INFORMATION);
        wxString homeDir = wxGetHomeDir();
        wxString filePath = homeDir + "/zsprundir/source/b/help.mp4";
        filePath = Command::NormalizePath(filePath.ToStdString());
        m_frame->SetWindowStyle(m_frame->GetWindowStyle() & ~wxSTAY_ON_TOP);
        Command::PlayVideo(filePath);
}



 void MyTaskBarIcon::Runpandav(wxCommandEvent& event) {
    wxStandardPaths& stdPaths = wxStandardPaths::Get();
    wxString appPath = stdPaths.GetExecutablePath();
    wxString directory = appPath.BeforeLast(wxT('/'));
    wxString PandaappPath = directory + "/zdelv";

    // 检查文件是否存在
    if (!wxFileExists(PandaappPath)) {
        wxLogError("File not found: %s", PandaappPath);
        return;
    }

    // 执行程序
    long pid = wxExecute(PandaappPath, wxEXEC_ASYNC | wxEXEC_HIDE_CONSOLE);

#ifdef _WIN32
    if (pid == -1) {
        wxLogError("Failed to launch the app on Windows.");
    }
#elif __APPLE__
    // macOS平台处理
    if (pid == -1) {
        wxLogError("Failed to launch the app on macOS.");
    } else {
        // 如果成功启动应用，尝试将其前置
        wxString script = "osascript -e 'tell application \"System Events\" to set frontmost of process \"zdelv\" to true'";
        int result = wxExecute(script, wxEXEC_SYNC);

        if (result != 0) {
            wxLogError("Failed to bring process to front: %s", script);
        }
    }

#else
    // 其他平台
    wxLogError("Unsupported platform.");
#endif
    //if (pid == 0) {
    //    wxLogError("Failed to execute: %s", PandaappPath);
    //    return;
    //}
    //
    //// 使用 osascript 将程序置顶
    //wxString script = wxString::Format("osascript -e 'tell application \"System Events\" to set frontmost of process \"%s\" to true'", "zdelv");
    //int result = wxExecute(script, wxEXEC_SYNC);
    //
    //if (result != 0) {
    //    wxLogError("Failed to bring process to front: %s", script);
    //}
}

void MyTaskBarIcon::OnLeftClicka(wxCommandEvent& event) {
    ToggleWindowVisibility();
}

void MyTaskBarIcon::OnLeftClick(wxTaskBarIconEvent&) {
    wxMessageBox("ok", "提示", wxOK | wxICON_INFORMATION);
    ToggleWindowVisibility();
}

void MyTaskBarIcon::OnLeftDoubleClick(wxTaskBarIconEvent&) {
    wxMessageBox("ok2", "提示", wxOK | wxICON_INFORMATION);
    ToggleWindowVisibility();
}

void MyTaskBarIcon::ToggleWindowVisibility() {
    if (!m_frame) return;
    bool isShown = m_frame->IsShown();
    bool isIconized = m_frame->IsIconized();
    if (isShown) {
    	if(isIconized){
    		m_frame->Iconize(false);
        m_frame->Raise();
        m_frame->SetWindowStyle(m_frame->GetWindowStyle() | wxSTAY_ON_TOP);
    	}else{
    		m_frame->Iconize(true);
    		//m_frame->Hide();
    	}
    } else {
      m_frame->Show();
      m_frame->Raise();
      m_frame->SetWindowStyle(m_frame->GetWindowStyle() | wxSTAY_ON_TOP);
    }
}


