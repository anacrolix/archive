unit Alienlist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, MPlayer, StdCtrls, ExtCtrls;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
  Talienform = class(TForm)
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    MediaPlayer3: TMediaPlayer;
    PopupMenu1: TPopupMenu;
    Drone1: TMenuItem;
    PsiDrone1: TMenuItem;
    Hatchling1: TMenuItem;
    KeizPredator1: TMenuItem;
    BlitzKreig1: TMenuItem;
    Devourer1: TMenuItem;
    Overseer1: TMenuItem;
    line2: TMenuItem;
    Unselect: TMenuItem;
    Clear1: TMenuItem;
    line1: TMenuItem;
    Keep1: TMenuItem;
    Close1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    Label2: TLabel;
    Drone: TRadioButton;
    PsiDrone: TRadioButton;
    Hatchling: TRadioButton;
    KeizPredator: TRadioButton;
    BlitzKreig: TRadioButton;
    Devourer: TRadioButton;
    Overseer: TRadioButton;
    Panel5: TPanel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Panel3: TPanel;
    keep: TButton;
    close: TButton;
    procedure closeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
    procedure Drone1Click(Sender: TObject);
    procedure PsiDrone1Click(Sender: TObject);
    procedure Hatchling1Click(Sender: TObject);
    procedure KeizPredator1Click(Sender: TObject);
    procedure BlitzKreig1Click(Sender: TObject);
    procedure Devourer1Click(Sender: TObject);
    procedure Overseer1Click(Sender: TObject);
    procedure UnselectClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure DroneClick(Sender: TObject);
    procedure PsiDroneClick(Sender: TObject);
    procedure HatchlingClick(Sender: TObject);
    procedure KeizPredatorClick(Sender: TObject);
    procedure BlitzKreigClick(Sender: TObject);
    procedure DevourerClick(Sender: TObject);
    procedure OverseerClick(Sender: TObject);
    procedure keepClick(Sender: TObject);
    procedure Keep1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  alienform: Talienform;
  ca : character;
  cf : file of character;
  account : text;
  gamepath : string[255];
  path1 : string[255];

implementation

uses Racenew, GameScreen, Accountload;

{$R *.DFM}

procedure Talienform.closeClick(Sender: TObject);
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
  alienform.visible := false;
  race.visible := true;
end;

procedure Talienform.FormClose(Sender: TObject; var Action: TCloseAction);
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
  race.visible := true;
end;

procedure Talienform.Close1Click(Sender: TObject);
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
  alienform.visible := false;
  race.visible := true;
end;

procedure Talienform.Drone1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  Drone.checked := true;
end;

procedure Talienform.PsiDrone1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  PsiDrone.checked := true;
end;

procedure Talienform.Hatchling1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  Hatchling.checked := true;
end;

procedure Talienform.KeizPredator1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  KeizPredator.checked := true;
end;

procedure Talienform.BlitzKreig1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  BlitzKreig.checked := true;
end;

procedure Talienform.Devourer1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  Devourer.checked := true;
end;

procedure Talienform.Overseer1Click(Sender: TObject);
begin
   {PLAYING EXITING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING RADIO BUTTON}
  Overseer.checked := true;
end;

procedure Talienform.UnselectClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {UNCHECKING RADIO BUTTONS}
  Drone.checked := false;
  Psidrone.checked := false;
  hatchling.checked := false;
  keizpredator.checked := false;
  blitzkreig.checked := false;
  devourer.checked := false;
  overseer.checked := false;
  label23.caption := '{None}';
  label7.caption := '{None}';
  label13.caption := '{None}';
  label15.caption := '{None}';
  label17.caption := '{None}';
  label30.caption := '?';
  label31.caption := '?';
  label32.caption := '?';
  label33.caption := '?';
  label34.caption := '?';
  label35.caption := '?';
  label36.caption := '0';
  label37.caption := '?';
  label38.caption := '?';
  label39.caption := '?';
  label41.caption := '?';
   {DEAVTIVATING KEEP BUTTON}
  keep1.visible := false;
  keep.enabled := false; 
end;

procedure Talienform.Clear1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CLEARING EDIT BOX}
  edit1.text := '';
end;

procedure Talienform.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
  mediaplayer3.filename := gamepath+'\Misc\Left Click.wav';
   {DISABLING KEEP BUTTON}
  keep.enabled := false;
  keep1.visible := false;
end;

procedure Talienform.Edit1Change(Sender: TObject);
begin
   {SETTING RECORD NAME}
  if edit1.text <> '' then
begin
  ca.name := edit1.text;
end;
   {SETTING NAME LABEL}
  if edit1.text = '' then
begin
  label11.caption := '{None}';
end

  else

  if edit1.Text <> '' then
begin
  label11.caption := edit1.Text;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (keizpredator.checked = true) or (hatchling.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) or (blitzkreig.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
end;

procedure Talienform.DroneClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'Drone';
  label13.caption := 'Drone';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\Drone.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.PsiDroneClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'PsiDrone';
  label13.caption := 'PsiDrone';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\PsiDrone.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.HatchlingClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'Hatchling';
  label13.caption := 'Hatchling';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\Hatchling.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.KeizPredatorClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'KeizPredator';
  label13.caption := 'KeizPredator';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\KeizPredator.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.BlitzKreigClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'BlitzKreig';
  label13.caption := 'BlitzKreig';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\BlitzKreig.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.DevourerClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'Devourer';
  label13.caption := 'Devourer';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\Devourer.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.OverseerClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (drone.checked = false) and (psidrone.checked = false) and (hatchling.checked = false) and
  (keizpredator.checked = false) and (blitzkreig.checked = false) and (devourer.checked = false) and
  (overseer.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (drone.checked = true) or (psidrone.checked = true) or (hatchling.checked = true) or
  (keizpredator.checked = true) or (blitzkreig.checked = true) or (devourer.checked = true) or
  (overseer.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (drone.checked = true) or (psidrone.checked = true) or
  (hatchling.checked = true) or (keizpredator.checked = true) or (blitzkreig.checked = true) or
  (devourer.checked = true) or (overseer.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {SETTING LABEL VALUES}
  label7.caption := 'Overseer';
  label13.caption := 'Overseer';
  label17.caption := 'Lava';
  label15.caption := 'Lava';
  label23.caption := 'Alien';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\Overseer.chr');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {APPLYING STATS}
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label41.caption := IntToStr(ca.lvl);
end;

procedure Talienform.keepClick(Sender: TObject);
begin
   {PLAYING WAV'S}
  mediaplayer3.open;
  with mediaplayer3 do
  begin
  wait := true;
  play;
  end;
  mediaplayer3.close;
   {GETTING ACCOUNT}
  path1 := account3.edit2.text;
    {CREATING CHARACTER FILE}
  assignfile(cf, gamepath+'\save\'+path1+'\'+edit1.text+'.sav');
  rewrite(cf);
  write(cf, ca);
  closefile(cf);
   {CHANGING FORMS}
      game.label14.caption := ca.name;
      game.label21.caption := path1;   
  alienform.visible := false;
  game.visible := true;
end;

procedure Talienform.Keep1Click(Sender: TObject);
begin
   {PLAYING WAV'S}
  mediaplayer3.open;
  with mediaplayer3 do
  begin
  wait := true;
  play;
  end;
  mediaplayer3.close;
   {READING FILE}
  assignfile(account, gamepath+'\save\Dark.pth');
  reset(account);
  readln(account, path1);
  closefile(account);
   {SAVING CHARACTER}
  assignfile(cf, gamepath+'\save\'+path1+'\'+edit1.text+'.sav');
  rewrite(cf);
  write(cf, ca);
  closefile(cf);
   {ADDING CHARACTER CHECK FILE}
  assignfile(account, gamepath+'\save\Dark.chr');
  rewrite(account);
  writeln(account, edit1.text);
  closefile(account);
   {CHANGING FORMS}
  alienform.visible := false;
  game.visible := true;
end;

procedure Talienform.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
  mediaplayer3.filename := gamepath+'\Misc\Left Click.wav';
   {DISABLING KEEP BUTTON}
  keep.enabled := false;
  keep1.visible := false;
end;

end.
