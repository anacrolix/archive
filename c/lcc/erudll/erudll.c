#include <windows.h>
unsigned int APIENTRY __declspec(dllexport)
ReadMem (HWND hwnd, int address) {

   HDC hdc;
   HPEN oldpen, pen;

   if (IsWindow(hwnd)) {
      hdc = GetDC(hwnd);
      pen = CreatePen(PS_SOLID, 1, 0x000000FF);
      oldpen = SelectObject(hdc, pen);
      Ellipse (hdc, X1, Y1, X2, Y2);
      SelectObject (hdc, oldpen);
      DeleteObject (pen);
      ReleaseDC (hwnd, hdc);
   }
}
