unit Characterload;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, MPlayer, Menus, FileCtrl;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
  Tcharacter1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    cancel: TButton;
    ok: TButton;
    Label5: TLabel;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    PopupMenu1: TPopupMenu;
    ok1: TMenuItem;
    cancel1: TMenuItem;
    FileListBox1: TFileListBox;
    procedure FormCreate(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cancel1Click(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure ok1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  character1: Tcharacter1;
  ca : character;
  cf : file of character;
  at : text;
  path1 : string[20];

implementation

uses Accountload2, GameScreen, Accountload;

{$R *.DFM}

procedure Tcharacter1.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

procedure Tcharacter1.cancelClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer1.Open;
  with MediaPlayer1 do
  begin
  wait := true;
  play;
  end;
  MediaPlayer1.close;
   {CHANGING FORMS}
  character1.visible := false;
  account4.visible := true;
end;

procedure Tcharacter1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {PLAYING SOUND}
  mediaplayer1.Open;
  with MediaPlayer1 do
  begin
  wait := true;
  play;
  end;
  MediaPlayer1.close;
end;

procedure Tcharacter1.cancel1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer1.Open;
  with MediaPlayer1 do
  begin
  wait := true;
  play;
  end;
  MediaPlayer1.close;
   {CHANGING FORMS}
  character1.visible := false;
  account4.visible := true; 
end;

procedure Tcharacter1.okClick(Sender: TObject);
var
  i : integer;
begin
   {PLAYING SOUND}
  mediaplayer2.Open;
  with MediaPlayer2 do
  begin
  wait := true;
  play;
  end;
  MediaPlayer2.close;


  for i := 0 to (FileListBox1.Items.Count - 1) do begin
  try
    if FileListBox1.Selected[i] then begin
      if not FileExists(FileListBox1.Items.Strings[i]) then begin
        MessageDlg('File: ' + FileListBox1.Items.Strings[i] +
                   ' not found', mtError, [mbOk], 0);
        Continue;
      end;
      AssignFile(cf, FileListBox1.Items.Strings[i]);

      Reset(cf);
      read(cf, ca);
      CloseFile(cf);
      game.label14.caption := ca.name;
      game.label21.caption := path1;
      character1.visible := false;
      game.visible := true;
     end;
   finally
  end;
 end;
end;

procedure Tcharacter1.ok1Click(Sender: TObject);
var
  i : integer;
begin
   {PLAYING SOUND}
  mediaplayer2.Open;
  with MediaPlayer2 do
  begin
  wait := true;
  play;
  end;
  MediaPlayer2.close;


  for i := 0 to (FileListBox1.Items.Count - 1) do begin
  try
    if FileListBox1.Selected[i] then begin
      if not FileExists(FileListBox1.Items.Strings[i]) then begin
        MessageDlg('File: ' + FileListBox1.Items.Strings[i] +
                   ' not found', mtError, [mbOk], 0);
        Continue;
      end;
      AssignFile(cf, FileListBox1.Items.Strings[i]);

      Reset(cf);
      read(cf, ca);
      CloseFile(cf);
      game.label14.caption := ca.name;
      game.label21.caption := path1;
      character1.visible := false;
      game.visible := true;
     end;
   finally
  end;
 end;
end;

procedure Tcharacter1.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
   {GETTING ACCOUNT}
  path1 := account3.edit2.text;
   {DIRECTORY}
  filelistbox1.directory := gamepath+'\save\'+path1;
end;

procedure Tcharacter1.FileListBox1Click(Sender: TObject);
begin
   {ACTIVATING BUTTONS}
  ok.enabled := true;
  ok1.visible := true; 
end;

end.
