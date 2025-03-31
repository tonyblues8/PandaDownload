#include "TransparentText.h"

TransparentText::TransparentText(wxWindow* parent, const wxString& text, const wxSize& size, const wxColour& textColour, int fontSize, bool isBold, bool isItalic)
    : wxWindow(), m_text(text), m_textColour(textColour)
{
    // 在 Create() 之前设置透明背景
    SetBackgroundStyle(wxBG_STYLE_TRANSPARENT);

    // 创建窗口并设置大小
    Create(parent, wxID_ANY, wxDefaultPosition, size);

    // 设置字体
    m_font = wxFont(fontSize, wxFONTFAMILY_DEFAULT, isItalic ? wxFONTSTYLE_ITALIC : wxFONTSTYLE_NORMAL, isBold ? wxFONTWEIGHT_BOLD : wxFONTWEIGHT_NORMAL);

    Disable();
    // 绑定绘制事件
    Bind(wxEVT_PAINT, &TransparentText::OnPaint, this);

    // 绑定鼠标事件并传递给父窗口
    Bind(wxEVT_LEFT_DOWN, [parent](wxMouseEvent& event) {
        wxMouseEvent newEvent(event);
        newEvent.SetEventObject(parent);
        parent->ProcessWindowEvent(newEvent);
    });

    Bind(wxEVT_MOTION, [parent](wxMouseEvent& event) {
        wxMouseEvent newEvent(event);
        newEvent.SetEventObject(parent);
        parent->ProcessWindowEvent(newEvent);
    });

    Bind(wxEVT_LEFT_UP, [parent](wxMouseEvent& event) {
        wxMouseEvent newEvent(event);
        newEvent.SetEventObject(parent);
        parent->ProcessWindowEvent(newEvent);
    });
}

void TransparentText::OnPaint(wxPaintEvent&)
{
    wxPaintDC dc(this);

    // 设置文本颜色
    dc.SetTextForeground(m_textColour);

    // 设置字体
    dc.SetFont(m_font);

    // 获取文本的宽度和高度
    wxCoord textWidth, textHeight;
    dc.GetTextExtent(m_text, &textWidth, &textHeight);

    // 计算文本的起始位置（居中）
    int x = (GetSize().GetWidth() - textWidth) / 2;
    int y = (GetSize().GetHeight() - textHeight) / 2;

    // 绘制文本
    dc.DrawText(m_text, wxPoint(x, y));
}