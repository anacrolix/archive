import tkinter as tk
from tkinter import ttk
from tkinter import font as tkFont

r=tk.Tk()

vPcode=tk.StringVar()
vPcode.set('Postal code')
st=ttk.Style()
st.configure('I.TEntry',foreground='gray',background='white')
st.map('I.TEntry',selectforeground=[('!disabled','gray')],selectbackground=[('!disabled','white')])
ePcode=ttk.Entry(r,textvariable=vPcode,style='I.TEntry',width=12)
efn=tkFont.Font(font=str(ePcode['font']))
fn=tkFont.Font(font=str(ePcode['font']))
fn['slant']='italic'
ePcode['font']=fn
ePcode.grid()

def postal(ev):
  global r,vPcode,ePcode
  if ev.keysym=='Return':
    ttk.Label(r,text='Done successfully').grid()
  elif vPcode.get()=='Postal code':
    ePcode['style']='I.TEntry'
    ePcode['font']=fn
  else:
    ePcode['style']='TEntry'
    ePcode['font']=efn

ePcode.select_range(0,tk.END)
ePcode.bind('<KeyRelease>',lambda ev: postal(ev))
ePcode.focus()

r.mainloop()
