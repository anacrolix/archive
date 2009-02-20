unit Racenew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, MPlayer;

type
  TRace = class(TForm)
    Human: TRadioButton;
    Alien: TRadioButton;
    Rebellion: TRadioButton;
    Cult: TRadioButton;
    PopupMenu1: TPopupMenu;
    Label1: TLabel;
    Panel1: TPanel;
    ok: TButton;
    cancel: TButton;
    human1: TMenuItem;
    Alien1: TMenuItem;
    line1: TMenuItem;
    cancel1: TMenuItem;
    OK1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure HumanClick(Sender: TObject);
    procedure AlienClick(Sender: TObject);
    procedure human1Click(Sender: TObject);
    procedure Alien1Click(Sender: TObject);
    procedure cancel1Click(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure OK1Click(Sender: TObject);
    procedure RebellionClick(Sender: TObject);
    procedure CultClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Race: TRace;

implementation

uses Accountnew, Humanlist, Alienlist, Accountchoice;

{$R *.DFM}

procedure TRace.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
   {DISABLING OK BUTTON ON FORM LOAD}
  OK.enabled := false;
end;

procedure TRace.HumanClick(Sender: TObject);
begin
   {ENABLING OK BUTTON}
  if human.checked = true then
begin
  ok.enabled := true;
  ok1.Visible := true;
end;
end;

procedure TRace.AlienClick(Sender: TObject);
begin
   {ENABLING OK BUTTON}
  if alien.checked = true then
begin
  ok.enabled := true;
  ok1.Visible := true;
end;
end;

procedure TRace.human1Click(Sender: TObject);
begin
  {POPUP CHECKING HUMAN}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
human.checked := true;
end;

procedure TRace.Alien1Click(Sender: TObject);
begin
  {POPUP CHECKING ALIEN}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
alien.checked := true;
end;

procedure TRace.cancel1Click(Sender: TObject);
begin
   {CHANGING FORMS}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
  race.visible := false;
  account2.visible := true;
end;

procedure TRace.cancelClick(Sender: TObject);
begin
  {CHANGING FORMS}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
  race.visible := false;
  account2.visible := true;
end;

procedure TRace.okClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RACE TYPE}
{HUMAN}
  if human.checked = true then
begin
  race.visible := false;
  humanform.visible := true;
  humanform.bringtofront;
end

  else

{ALIEN}
  if Alien.checked = true then
begin
  race.visible := false;
  alienform.Visible := true;
end;
end;

procedure TRace.OK1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RACE TYPE}
{HUMAN}
  if human.checked = true then
begin
  race.visible := false;
  humanform.visible := true;
  humanform.bringtofront;
end

  else

{ALIEN}
  if Alien.checked = true then
begin
  race.visible := false;
  alien.Visible := true;
end;
end;

procedure TRace.RebellionClick(Sender: TObject);
begin
  {DEACTIVATING BUTTONS}
  if rebellion.checked = true then
begin
  ok.enabled := false;
  ok1.visible := false;
end;
end;

procedure TRace.CultClick(Sender: TObject);
begin
   {DEACTIVATING BUTTONS}
  if cult.checked = true then
begin
  ok.enabled := false;
  ok1.visible := false;
end;
end;

procedure TRace.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {PLAYING EXITING SOUND}
    mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
end;

procedure TRace.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
   {DISABLING OK BUTTON ON FORM LOAD}
  OK.enabled := false;
end;

end.
