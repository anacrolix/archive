unit AccountPassword;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, MPlayer, Menus;

type
hold = record
  name : string[20];
  pass : string[20];
end;

type
  Taccount5 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Panel1: TPanel;
    ok: TButton;
    cancel: TButton;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    PopupMenu1: TPopupMenu;
    ok1: TMenuItem;
    cancel1: TMenuItem;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cancel1Click(Sender: TObject);
    procedure ok1Click(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  account5: Taccount5;
  at : text;
  path1 : string[50];
  af : file of hold;
  aa : hold;
  gamepath : string[255];

implementation

uses Accountload2, Characterload;

{$R *.DFM}

procedure Taccount5.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Left Click.wav';
end;

procedure Taccount5.Edit1Change(Sender: TObject);
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

procedure Taccount5.cancelClick(Sender: TObject);
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
  account5.visible := false;
  account4.visible := true;
end;

procedure Taccount5.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure Taccount5.cancel1Click(Sender: TObject);
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

procedure Taccount5.ok1Click(Sender: TObject);
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
  account5.visible := false;
  character1.visible := true;
end;

procedure Taccount5.okClick(Sender: TObject);
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
  account5.visible := false;
  character1.visible := true;
  edit1.text := '';
end;

procedure Taccount5.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Left Click.wav';
   {TAKING PASSWORD}
  label3.caption := account4.Edit1.Text;
  aa.pass := label3.caption;
end;

end.
