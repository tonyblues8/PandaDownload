#include "CustomButton.h"

wxBEGIN_EVENT_TABLE(CustomButton, wxPanel)
    EVT_PAINT(CustomButton::OnPaint)
    EVT_LEFT_DOWN(CustomButton::OnLeftDown)
    EVT_LEFT_UP(CustomButton::OnLeftUp)
wxEND_EVENT_TABLE()

CustomButton::CustomButton(wxWindow* parent, wxWindowID id, const wxString& label, const wxBitmap& bitmap, const wxPoint& pos, const wxSize& size)
    : wxPanel(parent, id, pos, size), m_label(label), m_bitmap(bitmap), m_pressed(false), m_position(pos), m_size(size)
{
    m_bgColour = *wxLIGHT_GREY;
    m_fgColour = *wxBLACK;
    Bind(wxEVT_LEFT_DOWN, &CustomButton::OnLeftDown, this);
    Bind(wxEVT_LEFT_UP, &CustomButton::OnLeftUp, this);
}

bool CustomButton::SetBackgroundColour(const wxColour& colour)
{
    m_bgColour = colour;
    Refresh();
    return true; // 返回 true 表示成功
}

bool CustomButton::SetForegroundColour(const wxColour& colour)
{
    m_fgColour = colour;
    Refresh();
    return true; // 返回 true 表示成功
}

void CustomButton::SetLabel(const wxString& label)
{
    m_label = label;
    Refresh();
}

void CustomButton::SetBitmap(const wxBitmap& bitmap)
{
    m_bitmap = bitmap;
    Refresh();
}

void CustomButton::SetPosition(const wxPoint& pos)
{
    m_position = pos;
    wxPanel::SetPosition(pos); // 调用基类的方法来实际设置位置
}

void CustomButton::SetSize(const wxSize& size)
{
    m_size = size;
    wxPanel::SetSize(size); // 调用基类的方法来实际设置大小
}

wxPoint CustomButton::GetPosition() const
{
    return m_position;
}

wxSize CustomButton::GetSize() const
{
    return m_size;
}

void CustomButton::OnPaint(wxPaintEvent& event)
{
    wxPaintDC dc(this);
    DrawButton(dc);
}

void CustomButton::OnLeftDown(wxMouseEvent& event)
{
    m_pressed = true;
    Refresh();
}

void CustomButton::OnLeftUp(wxMouseEvent& event)
{
    m_pressed = false;
    Refresh();

    //wxCommandEvent clickEvent(wxEVT_BUTTON, GetId());
    //GetParent()->ProcessWindowEvent(clickEvent);

    // 手动触发 wxEVT_BUTTON 事件
    wxCommandEvent evt(wxEVT_BUTTON, GetId());
    evt.SetEventObject(this);
    ProcessWindowEvent(evt);

    //event.Skip(); // 确保事件继续传递
}

void CustomButton::DrawButton(wxDC& dc)
{
    wxSize size = GetSize();

    // 绘制按钮背景
    dc.SetBrush(*wxTRANSPARENT_BRUSH);
    dc.SetPen(*wxTRANSPARENT_PEN);
    dc.DrawRectangle(0, 0, size.GetWidth(), size.GetHeight());

    // 绘制按钮图片
    if (m_bitmap.IsOk())
    {
        int bmpX = (size.GetWidth() - m_bitmap.GetWidth()) / 2;
        int bmpY = (size.GetHeight() - m_bitmap.GetHeight()) / 2;
        dc.DrawBitmap(m_bitmap, bmpX, bmpY, true);
    }

    // 绘制按钮文字（覆盖在图片上）
    dc.SetTextForeground(m_fgColour);
    wxCoord textWidth, textHeight;
    dc.GetTextExtent(m_label, &textWidth, &textHeight);

    // 文字的 x 和 y 坐标，确保文字居中在图片上方
    int textX = (size.GetWidth() - textWidth) / 2;
    int textY = (size.GetHeight() - textHeight) / 2;

    dc.DrawText(m_label, textX, textY);
}