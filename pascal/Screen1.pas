unit Screen1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MPlayer, Buttons, ExtCtrls;

type
  TOpen = class(TForm)
    Label1: TLabel;
    MediaPlayer1: TMediaPlayer;
    Label2: TLabel;
    next: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    close: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    procedure MediaPlayer1Click(Sender: TObject; Button: TMPBtnType;
      var DoDefault: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Open: TOpen;
  gamepath : string[255];
  at : text;
  song : string[255];

implementation

uses Selection;

{$R *.DFM}

procedure TOpen.MediaPlayer1Click(Sender: TObject; Button: TMPBtnType;
  var DoDefault: Boolean);
begin
   {CHANGING LABEL CAPTION TO MEDIA PLAYER}
case Button of
    btPlay :
    begin
      Label3.Caption := '{Playing}';
      with mediaplayer1 do
      begin
      enabledbuttons := [btpause];
      end;
    end;
    btPause:
    begin
      Label3.Caption := '{Paused}';
      with mediaplayer1 do
      begin
      enabledbuttons := [btplay];
      end;
    end;
 end;
end;

procedure TOpen.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Games.wav';
   {ACTIVATING MEDIA PLAYER ON FORM OPEN}
  mediaplayer1.open;
  with mediaplayer1 do begin
  play;
  Autoenable := false;
  enabledbuttons := [btpause];
  end;
end;

procedure TOpen.nextClick(Sender: TObject);
begin
     {CHANGING LABELS}
   label6.Visible := false;
   label7.visible := false;
   label8.visible := false;
   label2.visible := false;
   label4.visible := true;
   label5.visible := true;
     {ACTIVATING NEXT BUTTON CLOSING FORM}
     with mediaplayer1 do
    begin
      enabledbuttons := [btplay];
      label3.caption := '{Paused}';
      stop;
    end;
    mediaplayer1.close;
    open.visible := false;
    NLE.visible := true;
end;

procedure TOpen.Button1Click(Sender: TObject);
begin
  if mediaplayer1.filename = gamepath+'\Misc\Games.wav' then
begin
  mediaplayer1.close;
  mediaplayer1.filename := gamepath+'\Misc\Intro.wav';
  mediaplayer1.open;
  mediaplayer1.play;
end

  else

  if mediaplayer1.filename = gamepath+'\Misc\Intro.wav' then
begin
  mediaplayer1.close;
  mediaplayer1.filename := gamepath+'\Misc\Games.wav';
  mediaplayer1.open;
  mediaplayer1.play;
end

end;

end.
