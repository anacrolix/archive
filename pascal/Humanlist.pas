unit Humanlist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, MPlayer, Mask;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
  Thumanform = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    infantry: TRadioButton;
    Medic: TRadioButton;
    Demolitions: TRadioButton;
    Explosives: TRadioButton;
    Spy: TRadioButton;
    Sniper: TRadioButton;
    Artillary: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Panel3: TPanel;
    keep: TButton;
    close: TButton;
    PopupMenu1: TPopupMenu;
    Infantry1: TMenuItem;
    Demolitions1: TMenuItem;
    Medic1: TMenuItem;
    Explosives1: TMenuItem;
    Spy1: TMenuItem;
    Sniper1: TMenuItem;
    Artillary1: TMenuItem;
    line1: TMenuItem;
    Keep1: TMenuItem;
    Close1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    Panel4: TPanel;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel5: TPanel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    line2: TMenuItem;
    Unselect: TMenuItem;
    Clear1: TMenuItem;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
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
    MediaPlayer3: TMediaPlayer;
    Label9: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    procedure Infantry1Click(Sender: TObject);
    procedure Demolitions1Click(Sender: TObject);
    procedure Medic1Click(Sender: TObject);
    procedure Explosives1Click(Sender: TObject);
    procedure Spy1Click(Sender: TObject);
    procedure Sniper1Click(Sender: TObject);
    procedure Artillary1Click(Sender: TObject);
    procedure Keep1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure closeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure infantryClick(Sender: TObject);
    procedure MedicClick(Sender: TObject);
    procedure DemolitionsClick(Sender: TObject);
    procedure ExplosivesClick(Sender: TObject);
    procedure SpyClick(Sender: TObject);
    procedure SniperClick(Sender: TObject);
    procedure ArtillaryClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure UnselectClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure keepClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  humanform: Thumanform;
  ca : character;
  cf : file of character;
  account : text;
  gamepath : string[255];

implementation

uses Racenew, GameScreen, Accountload;

{$R *.DFM}

procedure Thumanform.Infantry1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  infantry.checked := true;
end;

procedure Thumanform.Demolitions1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  demolitions.checked := true;
end;

procedure Thumanform.Medic1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  medic.checked := true;
end;

procedure Thumanform.Explosives1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  explosives.checked := true;
end;

procedure Thumanform.Spy1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  spy.checked := true;
end;

procedure Thumanform.Sniper1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  sniper.checked := true;
end;

procedure Thumanform.Artillary1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING BUTTON}
  artillary.checked := true;
end;

procedure Thumanform.Keep1Click(Sender: TObject);
var
  path1 : string[30];
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
  humanform.visible := false;
  game.visible := true;
end;

procedure Thumanform.Close1Click(Sender: TObject);
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
  humanform.visible := false;
  race.visible := true;
end;

procedure Thumanform.closeClick(Sender: TObject);
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
  humanform.visible := false;
  race.visible := true;
end;

procedure Thumanform.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
  mediaplayer3.filename := gamepath+'\Misc\Left Click.wav';
   {DISABLING BUTTONS}
  keep.enabled := false;
  keep1.visible := false;
end;

procedure Thumanform.infantryClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {CHANGING TYPE LABEL}
  label7.caption := 'Infantry';
  label13.Caption := 'Infantry';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\infantry.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.MedicClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {CHANGING TYPE LABEL}
  label7.caption := 'Medic';
  label13.Caption := 'Medic';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\medic.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.DemolitionsClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {CHANGING TYPE LABEL}
  label7.caption := 'Demolitions';
  label13.Caption := 'Demolitions';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\demolitions.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.ExplosivesClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {CHANGING TYPE LABEL}
  label7.caption := 'Explosives Technician';
  label13.Caption := 'Explosives Technician';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\explosives technician.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.SpyClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
 {CHANGING TYPE LABEL}
  label7.caption := 'Spy';
  label13.Caption := 'Spy';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\Spy.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.SniperClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {CHANGING TYPE LABEL}
  label7.caption := 'Sniper';
  label13.Caption := 'Sniper';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\sniper.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.ArtillaryClick(Sender: TObject);
begin
   {CHANGING KEEP BUTTON}
  if (infantry.checked = false) and (medic.checked = false) and (spy.checked = false) and
  (sniper.checked = false) and (artillary.checked = false) and (explosives.checked = false) and
  (demolitions.checked = false) then
begin
  keep1.visible := false;
  keep.enabled := false;
end

  else

  if (infantry.checked = true) or (medic.checked = true) or (spy.checked = true) or
  (sniper.checked = true) or (artillary.checked = true) or (explosives.checked = true) or
  (demolitions.checked = true) then
begin
  keep1.visible := true;
  keep.enabled := true;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
begin
  keep.enabled := true;
  keep1.enabled := true;
end;
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.visible := false;
end;
   {CHANGING TYPE LABEL}
  label7.caption := 'Artillary';
  label13.caption := 'Artillary';
  label15.caption := 'Private';
  label17.caption := 'Private';
  label23.caption := 'Human';
   {ACCESSING FILE}
  assignfile(cf, gamepath+'\characters\artillary.chr');
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
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
end;

procedure Thumanform.Edit1Change(Sender: TObject);
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
  if (edit1.text <> '') and (infantry.checked = true) or (medic.checked = true) or
  (spy.checked = true) or (sniper.checked = true) or (artillary.checked = true) or
  (explosives.checked = true) or (demolitions.checked = true) then
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

procedure Thumanform.UnselectClick(Sender: TObject);
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
  infantry.checked := false;
  medic.checked := false;
  spy.checked := false;
  sniper.checked := false;
  artillary.checked := false;
  explosives.checked := false;
  demolitions.checked := false;
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
   {DEACTIVATING KEEP BUTTON}
  keep1.visible := false;
  keep.enabled := false; 
end;

procedure Thumanform.Clear1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CLEARING NAME EDIT BOX}
  edit1.Text := '';
  label11.caption := '{None}';
end;

procedure Thumanform.keepClick(Sender: TObject);
var
  path1 : string[30];
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
   {SAVING CHARACTER}
  assignfile(cf, gamepath+'\save\'+path1+'\'+edit1.text+'.sav');
  rewrite(cf);
  write(cf, ca);
  closefile(cf);
   {CHANGING FORMS}
  game.label14.caption := ca.name;
  game.label21.caption := path1; 
  humanform.visible := false;
  game.visible := true;
end;

procedure Thumanform.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure Thumanform.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
  mediaplayer3.filename := gamepath+'\Misc\Left Click.wav';
   {DISABLING BUTTONS}
  keep.enabled := false;
  keep1.visible := false;
end;

end.
