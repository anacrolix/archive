unit Human;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
charac = record
  charname, typ, race, rank, pass : string[25];
  str, dex, arm, int, ste, wp, expg, expn : integer;
  lvl, chp, hp, cmana, mana : integer;
end;

type
  TCharacter_human = class(TForm)
    Label1: TLabel;
    Panel2: TPanel;
    Medic: TRadioButton;
    Artillary: TRadioButton;
    Explosives: TRadioButton;
    Infantry: TRadioButton;
    Spy: TRadioButton;
    Sniper: TRadioButton;
    Demolitions: TRadioButton;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    hname: TEdit;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    hpass: TEdit;
    hrpass: TEdit;
    Panel5: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    hname1: TEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    hchp: TEdit;
    Label12: TLabel;
    hhp: TEdit;
    hcmana: TEdit;
    Label13: TLabel;
    hmana: TEdit;
    hstr: TEdit;
    hdex: TEdit;
    Label14: TLabel;
    hrace: TEdit;
    Label15: TLabel;
    hlvl: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    htype: TEdit;
    hRank: TEdit;
    hste: TEdit;
    Label19: TLabel;
    hexpg: TEdit;
    Label20: TLabel;
    hexpn: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    hint: TEdit;
    harm: TEdit;
    hwp: TEdit;
    Info0: TButton;
    procedure hnameChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure MedicClick(Sender: TObject);
    procedure ExplosivesClick(Sender: TObject);
    procedure ArtillaryClick(Sender: TObject);
    procedure InfantryClick(Sender: TObject);
    procedure SpyClick(Sender: TObject);
    procedure SniperClick(Sender: TObject);
    procedure DemolitionsClick(Sender: TObject);
    procedure Info0Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Character_human: TCharacter_human;
  chara : charac;
  charl : file of charac;
  charf : text;
  path1 : string[20];

implementation

uses NotRight, Charmade, Info, Name, Password, NoType, Info_human, Load0;

{$R *.DFM}

procedure TCharacter_human.hnameChange(Sender: TObject);
begin
 chara.charname := hname.text;
 hname1.text := chara.charname;
end;

procedure TCharacter_human.BitBtn2Click(Sender: TObject);
begin
 if medic.Checked = false then
 if explosives.checked = false then
 if Artillary.checked = false then
 if Infantry.checked = false then
 if Spy.checked = false then
 if Sniper.checked = false then
 if Demolitions.checked = false then
begin
  nochar.visible := true;
end;
 if hname.text = '' then
begin
  noname.visible := true;
end;
 if hpass.text <> hrpass.text then
begin
   incorrect.visible := true;
end

  else

 if hpass.text = '' then
begin
  nopass.visible := true;
end

  else

 if hrpass.text = '' then
begin
  nopass.visible := true;
end

  else

  if (hpass.text = hrpass.text) and (hname.text <> '') then
 begin
   assignfile(charf, 'c:\tp\turbo\dark\save\Dark.pth');
   reset(charf);
   readln(charf, path1);
   closefile(charf);
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
end

  else

begin
  assignfile(charf, 'c:\tp\turbo\dark\save\Dark.chr');
  rewrite(charf);
  writeln(charf, chara.charname);
  closefile(charf);
end;
  chara.pass := hpass.text;
  charcre.visible := true;
 end;
end;

procedure TCharacter_human.MedicClick(Sender: TObject);
begin
 if medic.Checked = true then
begin
  hchp.text := '120';
  chara.chp := 120;
  hhp.text := '120';
  chara.hp := 120;
  hcmana.text := '10';
  chara.cmana := 10;
  hmana.text := '10';
  chara.mana := 10;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Medic';
  chara.typ := 'Medic';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '6';
  chara.ste := 6;
  hstr.text := '18';
  chara.str := 18;
  hdex.text := '20';
  chara.dex := 20;
  harm.text := '6';
  chara.arm := 6;
  hint.text := '12';
  chara.int := 12;
  hwp.text := '22';
  chara.wp := 22;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '130';
  chara.expn := 130;
end;
end;

procedure TCharacter_human.ExplosivesClick(Sender: TObject);
begin
 if explosives.checked = true then
begin
  hchp.text := '180';
  chara.chp := 180;
  hhp.text := '180';
  chara.hp := 180;
  hcmana.text := '0';
  chara.cmana := 0;
  hmana.text := '0';
  chara.mana := 0;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Explosives Techincian';
  chara.typ := 'Explosives Techincian';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '10';
  chara.ste := 10;
  hstr.text := '14';
  chara.str := 14;
  hdex.text := '25';
  chara.dex := 25;
  harm.text := '3';
  chara.arm := 3;
  hint.text := '4';
  chara.int := 4;
  hwp.text := '30';
  chara.wp := 30;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '200';
  chara.expn := 200;
end;
end;

procedure TCharacter_human.ArtillaryClick(Sender: TObject);
begin
 if artillary.checked = true then
begin
  hchp.text := '200';
  chara.chp := 200;
  hhp.text := '200';
  chara.hp := 200;
  hcmana.text := '0';
  chara.cmana := 0;
  hmana.text := '0';
  chara.mana := 0;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Artillary';
  chara.typ := 'Artillary';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '1';
  chara.ste := 1;
  hstr.text := '26';
  chara.str := 26;
  hdex.text := '10';
  chara.dex := 10;
  harm.text := '11';
  chara.arm := 11;
  hint.text := '5';
  chara.int := 5;
  hwp.text := '16';
  chara.wp := 16;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '310';
  chara.expn := 310;
end;
end;

procedure TCharacter_human.InfantryClick(Sender: TObject);
begin
 if infantry.checked = true then
begin
  hchp.text := '150';
  chara.chp := 150;
  hhp.text := '150';
  chara.hp := 150;
  hcmana.text := '0';
  chara.cmana := 0;
  hmana.text := '0';
  chara.mana := 0;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Infantry';
  chara.typ := 'Infantry';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '3';
  chara.ste := 3;
  hstr.text := '20';
  chara.str := 20;
  hdex.text := '15';
  chara.dex := 15;
  harm.text := '7';
  chara.arm := 7;
  hint.text := '10';
  chara.int := 10;
  hwp.text := '18';
  chara.wp := 18;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '240';
  chara.expn := 240;
end;
end;

procedure TCharacter_human.SpyClick(Sender: TObject);
begin
 if spy.Checked = true then
begin
  hchp.text := '100';
  chara.chp := 100;
  hhp.text := '100';
  chara.hp := 100;
  hcmana.text := '8';
  chara.cmana := 8;
  hmana.text := '8';
  chara.mana := 8;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Spy';
  chara.typ := 'Spy';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '15';
  chara.ste := 15;
  hstr.text := '12';
  chara.str := 12;
  hdex.text := '34';
  chara.dex := 34;
  harm.text := '2';
  chara.arm := 2;
  hint.text := '18';
  chara.int := 10;
  hwp.text := '8';
  chara.wp := 8;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '110';
  chara.expn := 110;
end;
end;

procedure TCharacter_human.SniperClick(Sender: TObject);
begin
 if sniper.checked = true then
begin
  hchp.text := '80';
  chara.chp := 80;
  hhp.text := '80';
  chara.hp := 80;
  hcmana.text := '5';
  chara.cmana := 5;
  hmana.text := '5';
  chara.mana := 5;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Sniper';
  chara.typ := 'Sniper';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '20';
  chara.ste := 20;
  hstr.text := '14';
  chara.str := 14;
  hdex.text := '28';
  chara.dex := 28;
  harm.text := '1';
  chara.arm := 1;
  hint.text := '20';
  chara.int := 20;
  hwp.text := '30';
  chara.wp := 30;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '240';
  chara.expn := 240;
end;
end;

procedure TCharacter_human.DemolitionsClick(Sender: TObject);
begin
 if demolitions.checked = true then
begin
  hchp.text := '280';
  chara.chp := 280;
  hhp.text := '280';
  chara.hp := 280;
  hcmana.text := '0';
  chara.cmana := 0;
  hmana.text := '0';
  chara.mana := 0;
  hrace.text := 'Human';
  chara.race := 'Human';
  htype.text := 'Demolitions';
  chara.typ := 'Demolitions';
  hrank.text := 'Private';
  chara.rank := 'Private';
  hste.text := '0';
  chara.ste := 0;
  hstr.text := '30';
  chara.str := 30;
  hdex.text := '8';
  chara.dex := 8;
  harm.text := '15';
  chara.arm := 15;
  hint.text := '2';
  chara.int := 2;
  hwp.text := '40';
  chara.wp := 40;
  hexpg.text := '0';
  chara.expg := 0;
  hlvl.text := '1';
  chara.lvl := 1;
  hexpn.text := '500';
  chara.expn := 500;
end;
end;

procedure TCharacter_human.Info0Click(Sender: TObject);
begin
 Hinfo.visible := true;
end;

procedure TCharacter_human.BitBtn3Click(Sender: TObject);
begin
 loadchar0.visible := true;
end;

end.
