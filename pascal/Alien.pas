unit Alien;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type

charac = record
  charname, typ, race, rank, pass : string[25];
  str, dex, arm, int, ste, wp, expg, expn : integer;
  lvl, chp, hp, cmana, mana : integer;
end;


  Tcharacter_alien = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Hatchling: TRadioButton;
    Drone: TRadioButton;
    PsiDrone: TRadioButton;
    KeizPredator: TRadioButton;
    Blitzkreig: TRadioButton;
    Devorer: TRadioButton;
    Overseer: TRadioButton;
    Label1: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    apass: TEdit;
    arpass: TEdit;
    Panel5: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
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
    aname1: TEdit;
    achp: TEdit;
    ahp: TEdit;
    acmana: TEdit;
    amana: TEdit;
    astr: TEdit;
    adex: TEdit;
    arace: TEdit;
    alvl: TEdit;
    atype: TEdit;
    aRank: TEdit;
    aste: TEdit;
    aexpg: TEdit;
    aint: TEdit;
    aarm: TEdit;
    awp: TEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    aexpn: TEdit;
    aname: TEdit;
    Info1: TButton;
    Label24: TLabel;
    procedure HatchlingClick(Sender: TObject);
    procedure anameChange(Sender: TObject);
    procedure DroneClick(Sender: TObject);
    procedure PsiDroneClick(Sender: TObject);
    procedure KeizPredatorClick(Sender: TObject);
    procedure BlitzkreigClick(Sender: TObject);
    procedure DevorerClick(Sender: TObject);
    procedure OverseerClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  character_alien: Tcharacter_alien;
  chara : charac;
  charl : file of charac;
  charf : text;

implementation

uses Info, NotRight, Charmade, Name, Password, NoType, Load0, Info_alien;

{$R *.DFM}


procedure Tcharacter_alien.anameChange(Sender: TObject);
begin
 chara.charname := aname.text;
 aname1.text := chara.charname;
end;

procedure Tcharacter_alien.HatchlingClick(Sender: TObject);
begin
 if Hatchling.checked = true then
begin
  achp.text := '80';
  chara.chp := 80;
  ahp.text := '80';
  chara.hp := 80;
  acmana.text := '0';
  chara.cmana := 0;
  amana.text := '0';
  chara.mana := 0;
  arace.text := 'Alien';
  chara.race := 'Alien';
  atype.text := 'Hatchling';
  chara.typ := 'Hatchling';
  astr.text := '18';
  chara.str := 18;
  adex.text := '10';
  chara.dex := 10;
  aarm.text := '18';
  chara.arm := 18;
  aint.text := '1';
  chara.int := 1;
  aste.text := '2';
  chara.ste := 2;
  alvl.text := '1';
  chara.lvl := 1;
  arank.text := 'Lava';
  chara.rank := 'Lava';
  awp.text := '14';
  chara.wp := 14;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '200';
  chara.expn := 200;
end;
end;

procedure Tcharacter_alien.DroneClick(Sender: TObject);
begin
 if Drone.checked = true then
begin
  achp.text := '120';
  chara.chp := 120;
  ahp.text := '120';
  chara.hp := 120;
  acmana.text := '5';
  chara.cmana := 5;
  amana.text := '5';
  chara.mana := 5;
  arace.text := 'Alien';
  chara.race := 'Alien';
  arank.text := 'Lava';
  chara.rank := 'Lava';
  astr.text := '12';
  chara.str := 12;
  adex.text := '12';
  chara.dex := 12;
  aint.text := '1';
  chara.int := 1;
  awp.text := '18';
  chara.wp := 18;
  atype.text := 'Drone';
  chara.typ := 'Drone';
  aste.text := '4';
  chara.ste := 4;
  aarm.text := '12';
  chara.arm := 12;
  alvl.text := '1';
  chara.lvl := 1;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '170';
  chara.expn := 170;
end;
end;

procedure Tcharacter_alien.PsiDroneClick(Sender: TObject);
begin
 if PsiDrone.checked = true then
begin
  achp.text := '60';
  chara.chp := 60;
  ahp.text := '60';
  chara.hp := 60;
  acmana.text := '12';
  chara.cmana := 12;
  amana.text := '12';
  chara.mana := 12;
  arace.text := 'Alien';
  chara.race := 'Alien';
  arank.text := 'Lava';
  chara.rank := 'Lava';
  astr.text := '8';
  chara.str := 8;
  adex.text := '18';
  chara.dex := 18;
  aint.text := '12';
  chara.int := 12;
  awp.text := '4';
  chara.wp := 4;
  atype.text := 'PsiDrone';
  chara.typ := 'PsiDrone';
  aste.text := '8';
  chara.ste := 8;
  aarm.text := '9';
  chara.arm := 9;
  alvl.text := '1';
  chara.lvl := 1;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '150';
  chara.expn := 150;
end;
end;

procedure Tcharacter_alien.KeizPredatorClick(Sender: TObject);
begin
 if KeizPredator.checked = true then
begin
  achp.text := '200';
  chara.chp := 200;
  ahp.text := '200';
  chara.hp := 200;
  acmana.text := '0';
  chara.cmana := 0;
  amana.text := '0';
  chara.mana := 0;
  arace.text := 'Alien';
  chara.race := 'Alien';
  arank.text := 'Lava';
  chara.rank := 'Lava';
  astr.text := '20';
  chara.str := 20;
  adex.text := '5';
  chara.dex := 5;
  aint.text := '1';
  chara.int := 1;
  awp.text := '24';
  chara.wp := 24;
  atype.text := 'KeizPredator';
  chara.typ := 'KeizPredator';
  aste.text := '0';
  chara.ste := 0;
  aarm.text := '21';
  chara.arm := 21;
  alvl.text := '1';
  chara.lvl := 1;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '250';
  chara.expn := 250;
end;
end;

procedure Tcharacter_alien.BlitzkreigClick(Sender: TObject);
begin
 if Blitzkreig.checked = true then
begin
  achp.text := '60';
  chara.chp := 60;
  ahp.text := '60';
  chara.hp := 60;
  acmana.text := '8';
  chara.cmana := 8;
  amana.text := '8';
  chara.mana := 8;
  arace.text := 'Alien';
  chara.race := 'Alien';
  arank.text := 'Lava';
  chara.rank := 'Lava';
  astr.text := '10';
  chara.str := 10;
  adex.text := '27';
  chara.dex := 27;
  aint.text := '11';
  chara.int := 11;
  awp.text := '8';
  chara.wp := 8;
  atype.text := 'Blitzkreig';
  chara.typ := 'BlitzKreig';
  aste.text := '14';
  chara.ste := 14;
  aarm.text := '3';
  chara.arm := 3;
  alvl.text := '1';
  chara.lvl := 1;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '120';
  chara.expn := 120;
end;
end;

procedure Tcharacter_alien.DevorerClick(Sender: TObject);
begin
 if Devorer.checked = true then
begin
  achp.text := '180';
  chara.chp := 180;
  ahp.text := '180';
  chara.hp := 180;
  acmana.text := '2';
  chara.cmana := 2;
  amana.text := '2';
  chara.mana := 2;
  arace.text := 'Alien';
  chara.race := 'Alien';
  arank.text := 'Lava';
  chara.rank := 'Lava';
  astr.text := '16';
  chara.str := 16;
  adex.text := '18';
  chara.dex := 18;
  aint.text := '2';
  chara.int := 2;
  awp.text := '13';
  chara.wp := 13;
  atype.text := 'Devorer';
  chara.typ := 'Devorer';
  aste.text := '8';
  chara.ste := 8;
  aarm.text := '7';
  chara.arm := 7;
  alvl.text := '1';
  chara.lvl := 1;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '190';
  chara.expn := 190;
end;
end;

procedure Tcharacter_alien.OverseerClick(Sender: TObject);
begin
 if Overseer.checked = true then
begin
  achp.text := '45';
  chara.chp := 45;
  ahp.text := '45';
  chara.hp := 45;
  acmana.text := '3';
  chara.cmana := 3;
  amana.text := '3';
  chara.mana := 3;
  arace.text := 'Alien';
  chara.race := 'Alien';
  arank.text := 'Lava';
  chara.rank := 'Lava';
  astr.text := '20';
  chara.str := 20;
  adex.text := '24';
  chara.dex := 24;
  aint.text := '8';
  chara.int := 8;
  awp.text := '29';
  chara.wp := 29;
  atype.text := 'Overseer';
  chara.typ := 'Overseer';
  aste.text := '20';
  chara.ste := 20;
  aarm.text := '13';
  chara.arm := 13;
  alvl.text := '1';
  chara.lvl := 1;
  aexpg.text := '0';
  chara.expg := 0;
  aexpn.text := '280';
  chara.expn := 280;
end;
end;

procedure Tcharacter_alien.BitBtn2Click(Sender: TObject);
var
  path1 : string[20];
begin
 if Drone.Checked = false then
 if PsiDrone.checked = false then
 if Blitzkreig.checked = false then
 if Devorer.checked = false then
 if Overseer.checked = false then
 if KeizPredator.checked = false then
 if Hatchling.checked = false then
begin
  nochar.visible := true;
end;
 if aname.text = '' then
begin
  noname.visible := true;
end;
 if apass.text <> arpass.text then
begin
  incorrect.visible := true;
end

  else

 if apass.text = '' then
begin
  nopass.visible := true;
end

  else

 if arpass.text = '' then
begin
  nopass.visible := true;
end

  else

 if (apass.text = arpass.text) then
begin
   assignfile(charl, 'c:\tp\turbo\dark\save\'+chara.charname+'.sav');
   rewrite(charl);
   write(charl, chara);
   closefile(charl);
  assignfile(charl, 'c:\tp\turbo\dark\save\'+path1+'\'+chara.charname+'.sav');
  rewrite(charl);
  write(charl, chara);
  closefile(charl);
  if fileexists('c:\tp\turbo\Dark\save\Dark.chr') then
begin
  assignfile(charf, 'C:\tp\turbo\dark\save\Dark.chr');
  append(charf);
  writeln(charf, chara.charname);
  closefile(charf);
end;
  chara.pass := apass.text;
  charcre.visible := true;
end;
end;

procedure Tcharacter_alien.BitBtn3Click(Sender: TObject);
begin
 loadchar0.visible := true;
end;

procedure Tcharacter_alien.Info1Click(Sender: TObject);
begin
 Ainfo.visible := true;
end;

procedure Tcharacter_alien.FormCreate(Sender: TObject);
var
  path2 : string[20];
begin
   if fileexists('c:\tp\turbo\dark\save\Dark.pth') then
begin
  assignfile(charf, 'c:\tp\turbo\dark\save\Dark.pth');
  reset(charf);
  readln(charf, path2);
  closefile(charf);
  label24.caption := path2;
end;
end;

end.
