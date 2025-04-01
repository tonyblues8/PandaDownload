#ifndef MYFRAME_H
#define MYFRAME_H

#include <wx/wx.h>
#include <wx/frame.h>
#include <wx/panel.h>
#include <wx/button.h>
#include <wx/menu.h>
#include <wx/sizer.h>
#include <wx/stattext.h>


#include <wx/hyperlink.h>
#include <wx/process.h>
#include <wx/timer.h>
#include <map>

#include "CustomButton.h"
#include "CustomGauge.h"
#include "Command.h"
#include "MyProcess.h"

#ifdef __WXMSW__
#include <windows.h>
#endif

#ifdef __WXMAC__
#import <Cocoa/Cocoa.h>
#endif

#ifdef __WXGTK__
#include <gtk/gtk.h>
#endif


extern wxPanel* content;
//extern bool isDarkMode;

class MyFrame : public wxFrame {
public:
    MyFrame();
    ~MyFrame();

private:
    wxPanel* m_titleBar;
    //wxButton* m_menuBtn;
    CustomButton* m_menuBtn;
    //wxButton* m_maximizeBtn;
    CustomButton* m_maximizeBtn;
    wxMenu* m_menu;
    //std::unique_ptr<wxMenu> m_menu;
    wxPoint m_dragStart;
    bool m_dragging;
    bool m_isMaximized;
    wxRect m_normalRect;

    void InitUI();
    void BindEvents();
    wxPanel* CreateTitleBar();
    void CreateControlButtons(wxPanel* parent, wxBoxSizer* sizer);
    void ToggleMaximize();
    void StyleButton(wxButton* btn, bool isClose = false);
    void StyleButton2(CustomButton* btn, bool isClose = false);
    void SetupMenu();
    void MinimizeWindow(id nsWindow);

    // 事件处理函数
    void OnTitleBarLeftDown(wxMouseEvent& e);
    void OnTitleBarMove(wxMouseEvent& e);
    void OnTitleBarLeftUp(wxMouseEvent& e);
    void OnMaximize(wxMaximizeEvent& e);
    void OnTitleBarDoubleClick(wxMouseEvent& e);
    void OnResize(wxSizeEvent& e);








///////////////////////////////////////////

    Command zycmd;
    void OnHelp(wxCommandEvent& event);
    void OnAbout(wxCommandEvent& event);
    void OnExit(wxCommandEvent& event);
    void OnShowHide(wxCommandEvent& event);
    void OnHyperlinkClick(wxHyperlinkEvent& event);
    void OnButtonClick(wxCommandEvent& event);
    void OnStopButtonClick(wxCommandEvent& event);
    void OnStopButtonClickbak(wxCommandEvent& event);
    void OnlookfButtonClick(wxCommandEvent& event);
    void OnSelectDirButtonClick(wxCommandEvent& event);
    void OnSelectDirButtonClickbak(wxCommandEvent& event);
    void OnSelectFileButtonClick(wxCommandEvent& event);
    void OnSelectPtButtonClick(wxCommandEvent& event);
    void OnSelectZmButtonClick(wxCommandEvent& event);
    void OnToggleButtonClick(wxCommandEvent& event);
    void OnToggleButtonClick2(wxCommandEvent& event);
    void OnToggleButtonClick3(wxCommandEvent& event);
    void OnToggleButtonClick4(wxCommandEvent& event);
    void OnToggleButtonClick5(wxCommandEvent& event);
    void OnTextCtrlKeyDown(wxKeyEvent& event);
    void OnAdBitmapClick(wxMouseEvent& event);
    void OnProcessTerminated(wxProcessEvent& event);
    void OnClose(wxCloseEvent& event);
    void OnTimer(wxTimerEvent& event);
    void OnTimer2(wxTimerEvent& event);
    void OnTimer4(wxTimerEvent& event);
    void OnTimer5(wxTimerEvent& event);
    void OnProcessEnd(wxProcessEvent& event);
    void ModifyDisplayToValueMap(const wxString& key, const wxString& newValue);
    void ModifyDisplayToValueMap2(const wxString& key, const wxString& newValue);
    void AddDisplayToValueMap(const wxString& key, const wxString& value);
    void AddDisplayToValueMap2(const wxString& key, const wxString& value);
    void AddChoice(const wxString& newChoice);
    void AddChoice2(const wxString& newChoice);
    void extractResolution(const std::string& filePath);
    void DisableChoice(wxComboBox* choice, const wxColour& bgColour, const wxColour& textColour);
    void EnableChoice(wxComboBox* choice, const wxColour& bgColour, const wxColour& textColour);
    void IgnoreClick(wxMouseEvent& event);

    // 辅助函数
    void UpdateGauge(double progress);
    //void UpdateProgress();
    double ExtractProgressPercentage(const wxString& output);
    wxString ClearAllSpace(const wxString& str);
    void ReinitializeVideoChoice();
    void RunCommandWithOutput(const wxString& command, int refreshTime, const wxString& savedir);

    wxStaticBitmap* m_adBitmap;
    wxBitmap cxBitmap;
    size_t m_currentAdIndex;
    wxTextCtrl* m_textCtrl;
    wxTextCtrl* m_textCtrl2;
    wxTextCtrl* m_textCtrl3;
    wxTextCtrl* m_dirPathTextCtrl;
    wxTextCtrl* m_dirPathTextCtrl2;
    wxTextCtrl* m_dirPathTextCtrl3;
    wxTextCtrl* m_dirPathTextCtrl4;

    CustomButton* selectDirButton;
    CustomButton* selectDirButton2;
    CustomButton* selectDirButton3;
    CustomButton* selectDirButton4;
    CustomButton* lookfButton;

    wxToggleButton* m_toggleButton;
    wxToggleButton* m_toggleButtonb;
    wxToggleButton* m_toggleButtonc;
    wxToggleButton* m_toggleButtond;
    wxToggleButton* m_toggleButtone;
    wxToggleButton* m_toggleButtonf;
    wxToggleButton* m_toggleButtong;
    wxToggleButton* m_toggleButtonh;
    wxToggleButton* m_toggleButtoni;

    wxBitmapToggleButton* m_toggleButton1;
    wxBitmapToggleButton* m_toggleButton2;
    wxBitmapToggleButton* m_toggleButton3;
    wxBitmapToggleButton* m_toggleButton4;
    wxBitmapToggleButton* m_toggleButton5;
    wxBitmapToggleButton* m_toggleButton6;
    wxBitmapToggleButton* m_toggleButton7;
    wxBitmapToggleButton* m_toggleButton8;
    wxBitmapToggleButton* m_toggleButton9;

    //wxGauge* m_gauge;
    CustomGauge* m_gauge;
    wxTextCtrl* m_outputTextCtrl;
    wxProcess* m_process;
    wxTimer* m_timer;
    wxTimer* m_timer2;
    wxTimer* m_timer4;
    bool m_downloading = false;
    bool m_ffmpeging = false;
    //wxChoice* m_qualityChoice;
    wxComboBox* m_qualityChoice;
    wxComboBox* m_qualityChoice2;
    wxComboBox* m_cookieChoice;
    CustomButton* startButton;
    CustomButton* stopButton;
    wxString m_dirPath;
    wxString zmfilePath;
    wxString ptfilePath;
    wxString cookiefilePath2;
    std::map<wxString, wxString> videoqOptions;
    wxArrayString qualityChoices;
    std::map<wxString, wxString> videoqOptions2;
    wxArrayString qualityChoices2;

    std::vector<wxBitmap> m_frames;
    int m_currentFrame;

    wxBoxSizer* mainSizer;
    wxBoxSizer* inputSizer;
    wxBoxSizer* buttonSizer;
    wxBoxSizer* controlSizer;
    wxBoxSizer* selectSizer;
    wxBoxSizer* adSizer;
    wxBoxSizer* inputSizer2;
    wxBoxSizer* checkvideoSizer;
    wxBoxSizer* checkvideoSizer2;
    wxBoxSizer* otherprm;

    MyProcess* process;
    wxTimer m_timer5;

wxBitmap bitmapbubj;
wxBitmap bitmapbubj0;
wxBitmap bitmapbubj2;

//wxString filePath;
wxColour backgroundColor;
wxColour textColor;
wxColour customColor;
wxColour customColor2;

wxBitmap bitmapOff;
wxBitmap bitmapOn;
wxBitmap bitmapicon;

bool isDarkMode;

    //wxDECLARE_EVENT_TABLE();
////////////////////////////////////////////////////
};


#endif // MYFRAME_H