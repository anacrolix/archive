unit Accountload;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, MPlayer, FileCtrl;

type
hold = record
  name : string[20];
  pass : string[20];
end;

type
  Taccount3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    ok1: TMenuItem;
    cancel1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    ok: TButton;
    canecl: TButton;
    FileListBox1: TFileListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cancel1Click(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure caneclClick(Sender: TObject);
    procedure ok1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  account3: Taccount3;
  aa : hold;
  af : file of hold;
  path1 : string[50];
  gamepath : string[255];

implementation

uses Accountchoice, Racenew, AccountPassword2;

{$R *.DFM}

procedure Taccount3.FormCreate(Sender: TObject);
begin
   {FILE LIST BOX FILES}
  filelistbox1.directory := gamepath+'\save';
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

procedure Taccount3.cancelClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  account3.visible := false;
  account2.visible := true; 
end;

procedure Taccount3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  account3.visible := false;
  account2.visible := true;
end;

procedure Taccount3.cancel1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  account3.visible := false;
  account2.visible := true;
end;

procedure Taccount3.okClick(Sender: TObject);
var
  i: integer;
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;


  for i := 0 to (FileListBox1.Items.Count - 1) do begin
  try
    if FileListBox1.Selected[i] then begin
      if not FileExists(FileListBox1.Items.Strings[i]) then begin
        MessageDlg('File: ' + FileListBox1.Items.Strings[i] +
                   ' not found', mtError, [mbOk], 0);
        Continue;
      end;
      AssignFile(af, FileListBox1.Items.Strings[i]);

      Reset(af);
      read(af, aa);
      CloseFile(af);
   account6.label3.caption := aa.pass;
   edit1.text := aa.pass;
   edit2.text := aa.name
    end;
   finally
   { do something here }
   account3.visible := false;
   account6.visible := true;
   end;
 end;
end;

procedure Taccount3.caneclClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  account3.visible := false;
  account2.visible := true;
end;

procedure Taccount3.ok1Click(Sender: TObject);
var
  i: integer;
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;


  for i := 0 to (FileListBox1.Items.Count - 1) do begin
  try
    if FileListBox1.Selected[i] then begin
      if not FileExists(FileListBox1.Items.Strings[i]) then begin
        MessageDlg('File: ' + FileListBox1.Items.Strings[i] +
                   ' not found', mtError, [mbOk], 0);
        Continue;
      end;
      AssignFile(af, FileListBox1.Items.Strings[i]);

      Reset(af);
      read(af, aa);
      CloseFile(af);
   account6.label3.caption := aa.pass;
   edit1.text := aa.pass;
   edit2.text := aa.name
    end;
   finally
   { do something here }
   account3.visible := false;
   account6.visible := true;
   end;
 end;
end;

procedure Taccount3.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

procedure Taccount3.FileListBox1Click(Sender: TObject);
begin
   {ACTIVATING BUTTONS}
  ok.enabled := true;
  ok1.visible := true;
end;

end.
