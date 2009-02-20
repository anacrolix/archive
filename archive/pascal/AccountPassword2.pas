unit AccountPassword2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, MPlayer;

type
hold = record
  name : string[20];
  pass : string[20];
end;

type
  Taccount6 = class(TForm)
    Panel1: TPanel;
    ok: TButton;
    cancel: TButton;
    PopupMenu1: TPopupMenu;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    ok1: TMenuItem;
    cancel1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure ok1Click(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  account6: Taccount6;
  af : file of hold;
  aa : hold;
  at : text;

implementation

uses Racenew, Accountload;

{$R *.DFM}

procedure Taccount6.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Left Click.wav';
end;

procedure Taccount6.Edit1Change(Sender: TObject);
begin
   {CHECKING PASSWORD}
  if edit1.text = label3.caption then
begin
  ok.enabled := true;
  ok1.Visible := true;
end

  else

  if edit1.text = '' then
begin
  ok.enabled := false;
  ok1.visible := false;
end

  else

  if edit1.text <> label3.caption then
begin
  ok.enabled := false;
  ok1.visible := false;
end;
end;

procedure Taccount6.okClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHANGING FORMS}
  account6.visible := false;
  race.visible := true;
  edit1.text := '';
end;

procedure Taccount6.ok1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHANGING FORMS}
  account6.visible := false;
  race.visible := true; 
end;

procedure Taccount6.cancelClick(Sender: TObject);
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
  account6.visible := false;
  account3.visible := true;
end;

procedure Taccount6.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Left Click.wav';
   {GETTING PASSWORD}
  aa.pass := label3.caption; 
end;

end.
