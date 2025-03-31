#ifndef TRANSPARENTTEXT_H
#define TRANSPARENTTEXT_H

#include <wx/wx.h>

class TransparentText : public wxWindow
{
public:
    TransparentText(wxWindow* parent, const wxString& text, const wxSize& size, const wxColour& textColour, int fontSize, bool isBold, bool isItalic);
    void OnPaint(wxPaintEvent& event);

private:
    wxString m_text;
    wxColour m_textColour; // 字体颜色
    wxFont   m_font;       // 字体
};

#endif // TRANSPARENTTEXT_H