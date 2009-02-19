unit Accountload2;

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
  Taccount4 = class(TForm)
    PopupMenu1: TPopupMenu;
    ok1: TMenuItem;
    cancel1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    FileListBox1: TFileListBox;
    Panel1: TPanel;
    ok: TButton;
    canecl: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cancel1Click(Sender: TObject);
    procedure caneclClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure ok1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  account4: Taccount4;
  aa : hold;
  af : file of hold;
  at : text;
  gamepath : string[255];

implementation

uses Characterload, AccountPassword, Accountload;

{$R *.DFM}

procedure Taccount4.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

procedure Taccount4.cancel1Click(Sender: TObject);
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
  account4.visible := false;
end;

procedure Taccount4.caneclClick(Sender: TObject);
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
  account4.visible := false;
end;

procedure Taccount4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
end;

procedure Taccount4.okClick(Sender: TObject);
var
  i : integer;
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
     edit1.text := aa.pass;
     account3.edit2.text := aa.name;
    account5.label3.caption := edit1.text;
    end;
   finally
   { do something here }
  account4.visible := false;
  account5.visible := true;
   end;
  end;
end;

procedure Taccount4.FormShow(Sender: TObject);
begin
   {SELECTING TEXT}
  edit1.selectall; 
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
   {FILE LIST BOX FILES}
  filelistbox1.directory := gamepath+'\save';
end;

procedure Taccount4.FileListBox1Click(Sender: TObject);
begin
   {ACTIVATING BUTTONS}
  ok.enabled := true;
  ok1.visible := true; 
end;

procedure Taccount4.ok1Click(Sender: TObject);
var
  i : integer;
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
     edit1.text := aa.pass;
     account3.edit2.text := aa.name;
    account5.label3.caption := edit1.text;
    end;
   finally
   { do something here }
  account4.visible := false;
  account5.visible := true;
   end;
  end;
end;

end.
