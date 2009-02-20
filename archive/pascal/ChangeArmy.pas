unit ChangeArmy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls;

type
army = record
  name, race : string[50];
  min, max : integer;
  leader : string[50];
end;

type
  Tchange1 = class(TForm)
    FileListBox1: TFileListBox;
    Panel1: TPanel;
    ok: TButton;
    cancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  change1: Tchange1;
  gamepath : string[255];
  mf : file of army;
  ma : army;

implementation

uses GameScreen;

{$R *.DFM}

procedure Tchange1.FormShow(Sender: TObject);
begin
   {SETTING DIRECTORY}
  filelistbox1.directory := gamepath+'\save\*.*';
  filelistbox1.Mask := '*.ard';
end;

procedure Tchange1.cancelClick(Sender: TObject);
begin
   {VISIBLE FORMS}
  change1.visible := false; 
end;

procedure Tchange1.FileListBox1Click(Sender: TObject);
begin
   {ACTIVATING BUTTON}
  ok.enabled := true;
end;

procedure Tchange1.okClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to (FileListBox1.Items.Count - 1) do begin
  try
    if FileListBox1.Selected[i] then begin
      if not FileExists(FileListBox1.Items.Strings[i]) then begin
        MessageDlg('File: ' + FileListBox1.Items.Strings[i] +
                   ' not found', mtError, [mbOk], 0);
        Continue;
      end;
      AssignFile(mf, FileListBox1.Items.Strings[i]);

      Reset(mf);
      read(mf, ma);
      CloseFile(mf);
      with game do
      begin
       with listbox3 do
       begin
       items.clear;
       items.add('Fix This');
       items.Add('AchromiciA');
       end;
      edit4.text := ma.name;
      edit6.text := IntToStr(ma.min);
      edit7.text := IntToStr(ma.max);
      end;
    end;
   finally
   { do something here }
   change1.visible := false;
   end;
 end;
end;

end.
