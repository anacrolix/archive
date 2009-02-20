unit Selection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, MPlayer;

type
  TNLE = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    New: TMenuItem;
    Load: TMenuItem;
    new1: TButton;
    load1: TButton;
    exit: TButton;
    Label2: TLabel;
    Label3: TLabel;
    exit1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    procedure exitClick(Sender: TObject);
    procedure new1Click(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure exit1Click(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure load1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NLE: TNLE;
  at : text;
  gamepath : string[255];

implementation

uses Screen1, Accountnew, Accountchoice, Accountload2;

{$R *.DFM}

procedure TNLE.exitClick(Sender: TObject);
begin
  {ACTIVATING EXIT BUTTON}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
  NLE.visible := false;
  open.visible := true;
  open.mediaplayer1.open;
end;

procedure TNLE.new1Click(Sender: TObject);
begin
  {ACTIVATING NEW CHARACTER BUTTON}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
  Account2.visible := true;
end;

procedure TNLE.NewClick(Sender: TObject);
begin
  {ACTIVATING POPUP NEW CHARACTER BUTTON}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   Account2.visible := true;
end;

procedure TNLE.exit1Click(Sender: TObject);
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
  nle.visible := false;
  open.visible := true;
end;

procedure TNLE.LoadClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
end;

procedure TNLE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {PLAYING EXITING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  open.visible := true; 
end;

procedure TNLE.load1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHANGING FORMS}
  account4.visible := true;
end;

procedure TNLE.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

procedure TNLE.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

end.
