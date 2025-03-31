#ifndef MY_PROCESS_H
#define MY_PROCESS_H
#include <wx/wx.h>
#include <wx/process.h>
#include <wx/timer.h>
#include <wx/frame.h>
#include <wx/msgdlg.h>

//void CenterWindow(wxWindow* window);
//void CenterWindow(wxWindow* window);

class MyProcess : public wxProcess {
public:
    MyProcess(wxEvtHandler* parent, wxTimer* timer1, wxFrame* frame, const wxString& saveDir);

    virtual void OnTerminate(int pid, int status) override;
    bool IsAlive() const;
    //pid_t GetPid() const;
    wxString m_saveDir;

private:
    void HandleSuccess(wxFrame* m_frame, wxString saveDir);
    void HandleFailure(int pid, int status);  // 处理失败终止
    void RestoreFrame();   // 还原窗口
    //void CenterWindow(wxFrame* frame);  // 窗口居中
    //wxString m_filePath;

    wxTimer* m_timer1;
    wxFrame* m_frame;
};

#endif // MY_PROCESS_H
