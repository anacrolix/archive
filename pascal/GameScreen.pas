unit GameScreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
body = record
  larm, rarm, lleg, rleg : string[50];
  head, chest, feet, hands : string[50];
  lfinger1, rfinger1, lfinger2, rfinger2 : string[50];
end;

type
hold = record
  name : string[20];
  pass : string[20];
end;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
  TGame = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    ListBox1: TListBox;
    PopupMenu1: TPopupMenu;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    Exit1: TMenuItem;
    Commands1: TMenuItem;
    Usecommands1: TMenuItem;
    AutoCommands1: TMenuItem;
    SpecialCommands1: TMenuItem;
    Commands2: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    KeywordSearch1: TMenuItem;
    N3: TMenuItem;
    DeathIncHomepage1: TMenuItem;
    DarkHomepage1: TMenuItem;
    Downloadlatestversion1: TMenuItem;
    N2: TMenuItem;
    InformationonCreators1: TMenuItem;
    OtherCreations1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    Panel2: TPanel;
    ListBox2: TListBox;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    Edit3: TEdit;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    ListBox3: TListBox;
    Label9: TLabel;
    new: TButton;
    Army1: TMenuItem;
    New1: TMenuItem;
    Search1: TMenuItem;
    Join1: TMenuItem;
    Label10: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Edit4: TEdit;
    change: TMenuItem;
    remove: TMenuItem;
    clear1: TButton;
    Character1: TMenuItem;
    Statistics: TMenuItem;
    Equip: TMenuItem;
    Inventory: TMenuItem;
    Skills: TMenuItem;
    menu: TMenuItem;
    Button1: TButton;
    Panel5: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    ListBox4: TListBox;
    Button2: TButton;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    Message1: TMenuItem;
    Open1: TMenuItem;
    clear2: TMenuItem;
    del: TMenuItem;
    Messages1: TMenuItem;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Timer1: TTimer;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    procedure newClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure changeClick(Sender: TObject);
    procedure removeClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure clear1Click(Sender: TObject);
    procedure StatisticsClick(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure clear2Click(Sender: TObject);
    procedure delClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure EquipClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure menuClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Game: TGame;
  at : text;
   {PATH VARIABLES}
  account : string[50];
  chara : string[50];
  army : string[50];
   {TYPE VARIABLES}
  cf : file of character;
  ca : character;
  aa : hold;
  af : file of hold;
  ifa : file of body;
  ia : body;
   {GAME STRINGS}
  current : string[255];
  command : string[255];
  statis : string[50];
   {CLOCK VARIABLES}
  counter : integer;
  previous : integer;
  xtra : integer;
  minute : integer;
  minutetwo : integer;
  hour : integer;
   {EDIT BOX VARIABLES}
  currenttime : integer; 

implementation

uses CreateArmy, CharacterStats, MessageScreen, CharEquipment, ChangeArmy,
  CharacterMenu;

{$R *.DFM}

procedure TGame.newClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Accessing New Army Screen}');
  end; 
   {CHANGING FORMS}
  newarmy.visible := true;
end;

procedure TGame.New1Click(Sender: TObject);
begin
   {DISPLAYING LISTBOX}
  with listbox1 do
  begin
  items.add('{Accessing New Army menu}');
  end;
   {CHANGING FORMS}
  newarmy.visible := true;
end;

procedure TGame.Exit1Click(Sender: TObject);
begin
   {CHANGING LIST BOX ITEMS}
  listbox3.items.clear;
   {CHANGING FORMS}
  game.visible := false;
end;

procedure TGame.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
end;

procedure TGame.FormShow(Sender: TObject);
begin
   {GETTING ACCOUNT STATS}
  assignfile(af, gamepath+'\save\'+label21.caption+'.acu');
  reset(af);
  read(af, aa);
  closefile(af);
   {GETTING CHARACTER STATS}
  if ca.name = '' then
begin
  assignfile(cf, gamepath+'\save\'+aa.name+'\'+label14.caption+'.sav');
  reset(cf);
  read(cf, ca);
  closefile(cf);
end;
   {GETTING EQUIPMENT}
  edit3.BringToFront;
  button1.SendToBack;
  edit5.BringToFront;
  button2.SendToBack;
  edit2.BringToFront;
  button3.SendToBack;
   bitbtn1.Glyph.LoadFromfile(gamepath+'\buttons\bitbtn1.bmp');
   bitbtn2.Glyph.LoadFromfile(gamepath+'\buttons\bitbtn2.bmp');
   bitbtn3.Glyph.LoadFromfile(gamepath+'\buttons\bitbtn3.bmp');
   bitbtn4.Glyph.LoadFromfile(gamepath+'\buttons\bitbtn4.bmp');
  listbox4.items.clear; 
  listbox4.items.add(ca.name);
  ca.name := label14.caption;
end;

procedure TGame.changeClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Army Ready for Changing}');
  items.add('-----------------------------------');
  end;
   {LIST BOX ITEMS}
  with listbox3 do
  begin
  items.clear;
  end;
   {CLEARING NAME BOXES}
  edit4.text := '';
  edit6.text := '';
  edit7.text := '';
   {VISIBLE CHANGING}
  change1.visible := true;  
end;

procedure TGame.removeClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Removing Army Files}');
  end;
  with listbox3 do
  begin
  items.clear;
  end;
   {CLEARING BOXES}
  edit4.text := '';
  edit6.text := '';
  edit7.text := '';
   {REMOVING FILES}
  if fileexists(gamepath+'\save\Dark.amy') then
begin
  assignfile(at, gamepath+'\save\Dark.amy');
  reset(at);
  readln(at, army);
  closefile(at);
   {DELETING FILES}
  deletefile(gamepath+'\save\'+account+'\'+army+'.ard');
  deletefile(gamepath+'\save\Dark.amy');
     {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Army Files Removed}');
  items.add('-----------------------------------');
  end;
end

  else

begin
     {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Army Files Not Found}');
  items.add('-----------------------------------');
  end;
end;
end;

procedure TGame.Save1Click(Sender: TObject);
begin
   {SHOWING MESSAGE}
  with listbox1 do
  begin
  items.add('{Saveing character}');
  end;
   {SAVING CHARACTER FILES}
  assignfile(cf, gamepath+'\save\'+aa.name+'\'+ca.name+'.sav');
  rewrite(cf);
  write(cf, ca);
  closefile(cf);
   {SHOWING MESSAGE}
  with listbox1 do
  begin
  items.add('{'+ca.name+' saved}');
  items.add('-----------------------------------');
  end;
end;

procedure TGame.Load1Click(Sender: TObject);
begin
   {DISPLAYING CHARACTER LOAD SCREEN}
end;

procedure TGame.Button1Click(Sender: TObject);
begin
  if edit3.text <> '' then
begin
   {SELECTING TEXT}
  edit3.SelectAll;
   {ASSIGNING VARIABLES}
  current := edit3.text;
   {LIST BOX ITEMS}
  with listbox2 do
  begin
  items.add(ca.name+': "'+current+'"');
  end;
  with listbox1 do
  begin
  items.add('Say "'+current+'"');
  end;
end

  else

  if edit3.text = '' then
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{No text in talk box}');
  items.add('-----------------------------------');
  end;
end;
end;

procedure TGame.clear1Click(Sender: TObject);
begin
   {CLEARING LIST BOX}
  with listbox1 do
  begin
  items.clear;
  end;
end;

procedure TGame.StatisticsClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Accessing Character Screen}');
  end;
   {GIVING LABELS STATS}
  with character2 do
  begin
  label11.caption := ca.name;
  label13.caption := ca.type1;
  label15.caption := ca.rank;
  label23.caption := ca.race;
  label30.caption := IntToStr(ca.str);
  label31.caption := IntToStr(ca.dex);
  label32.caption := IntToStr(ca.int);
  label33.caption := IntToStr(ca.arm);
  label34.caption := IntToStr(ca.ste);
  label35.caption := IntToStr(ca.wp);
  label3.caption := IntToStr(ca.chp);
  label4.caption := IntToStr(ca.cm);
  label38.caption := IntToStr(ca.hp);
  label39.caption := IntToStr(ca.m);
  label36.caption := IntToStr(ca.expg);
  label37.caption := IntToStr(ca.expn);
  label41.caption := IntToStr(ca.lvl);
  label42.caption := IntToStr(ca.curmove);
  label44.caption := IntToStr(ca.movement);
  end;
   {CHANGING FORMS}
  character2.visible := true;
end;

procedure TGame.Edit4Change(Sender: TObject);
begin
   {GIVING LIST BOX CHARACTER LABEL}
  if edit4.text <> '' then
begin
  listbox4.items.add(ca.name);
end;
end;

procedure TGame.Edit3Change(Sender: TObject);
begin
   {SETTING BUTTON}
  if ActiveControl = edit3 then
begin
  button1.Default := true;
end;
end;

procedure TGame.Edit5Change(Sender: TObject);
begin
   {SETTING BUTTON}
  if ActiveControl = edit5 then
begin
  button2.default := true;
end;
end;

procedure TGame.Button2Click(Sender: TObject);
var
  count : shortint;
begin
   {SELECTING TEXT}
  edit5.SelectAll;
   {SETTING VARIABLE}
  command := edit5.text;
   {ACTIVATING}
    for count := 1 to length(command) do
      command[count] := UPCASE(command[count]);

  if command = '' then
begin
  with listbox1 do
  begin
  items.add('{No Text in Command Box}');
  items.add('-----------------------------------');
  end;
end

  else

  if (command = 'STATISTICS') or (command = 'STAT') or
  (command = 'STATS') or (command = 'ST') then
begin
  with listbox1 do
  begin
  items.add('{Accessing Character Screen}');
  end;
  character2.visible := true;
end

  else

  if (command = 'NEW ARMY') or (command = 'NEW A') then
begin
  with listbox1 do
  begin
  items.add('{Accessing New Army Screen}');
  end;
  newarmy.visible := true;
end

  else

  if (command = 'REMOVE ARMY') or (command = 'REMOVE A') or
  (command = 'DEL ARMY') or (command = 'DEL A') then
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Removing Army Files}');
  end;
  with listbox3 do
  begin
  items.clear;
  end;
   {CLEARING BOXES}
  edit4.text := '';
  edit6.text := '';
  edit7.text := '';
   {REMOVING FILES}
  if fileexists(gamepath+'\save\Dark.amy') then
begin
  assignfile(at, gamepath+'\save\Dark.amy');
  reset(at);
  readln(at, army);
  closefile(at);
   {DELETING FILES}
  deletefile(gamepath+'\save\'+account+'\'+army+'.ard');
  deletefile(gamepath+'\save\Dark.amy');
     {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Army Files Removed}');
  items.add('-----------------------------------');
  end;
end

  else

begin
     {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Army Files Not Found}');
  items.add('-----------------------------------');
  end;
end;
end

  else

  if (command = 'SLEEP') or (command = 'SL') then
begin
  if (statis = 'Sleeping') then
begin
  with listbox1 do
  begin
  items.add(ca.name+' is already asleep');
  items.add('-----------------------------------');
  end;
end

  else

begin
  with listbox1 do
  begin
  items.add(ca.name+' has fallen asleep');
  items.add('-----------------------------------');
  end;
  edit1.text := 'Sleeping';
  statis := 'Sleeping';
end;
end

  else

  if (command = 'AWAKE') or (command = 'AW') or
  (command = 'WAKE UP') or (command = 'WAKE') or
  (command = 'GET UP') then
begin
  if statis = 'Normal' then
begin
  with listbox1 do
  begin
  items.add(ca.name+' is awake');
  items.add('-----------------------------------');
  end;
end

  else

  if statis = 'Napping' then
begin
  with listbox1 do
  begin
  items.add(ca.name+' has woken up');
  items.add('-----------------------------------');
  end;
  statis := 'Normal';
  edit1.text := 'Normal';
end

  else

  if statis = 'Sleeping' then
begin
  with listbox1 do
  begin
  items.add(ca.name+' has woken up');
  items.add('-----------------------------------');
  end;
  statis := 'Normal';
  edit1.text := 'Normal';
end;
end

  else

  if (command = 'NAP') or (command = 'NA') or
  (command = 'TAKE A NAP') or (command = 'TAKE A NA') then
begin
  if statis = 'Normal' then
begin
  with listbox1 do
  begin
  items.add(ca.name+' is taking a nap');
  items.add('-----------------------------------');
  end;
  statis := 'Napping';
  edit1.text := 'Napping';
end

  else

  if statis = 'Napping' then
begin
  with listbox1 do
  begin
  items.add(ca.name+' is already napping');
  items.add('-----------------------------------');
  end;
end;
end

  else

  if (command = 'MESSAGES') or (command = 'MESSAGE') or
  (command = 'OPEN MESSAGES') or (command = 'OPEN MESSAGE') or
  (command = 'OPEN MESSAGE SCREEN') or (command = 'OPEN MESSAGE S') then
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('Accessing Message Screen');
  end;
   {CHANGING FORMS}
  MessageMenu.visible := true;
end

  else

  if (command = 'REMOVE MESSAGES') or (command = 'REMOVE MESSAGE') or
  (command = 'DELETE MESSAGES') or (command = 'DELETE MESSAGE') then
begin
   {MESSAGE}
  with listbox1 do
  begin
  items.add('Removing Message Files');
  end;
   {DELETING MESSAGE FILES}
  if fileexists(gamepath+'\messages\'+ca.name+'.dam') then
begin
  deletefile(gamepath+'\messages\'+ca.name+'.dam');
  with listbox1 do
  begin
  items.add('Message Files Removed');
  items.add('-----------------------------------');
  end;
end

  else

begin
  with listbox1 do
  begin
  items.add('Message Files Not Found');
  items.add('-----------------------------------');
  end;
end;
end

  else

  if (command = 'CLEAR MESSAGES') or (command = 'CLEAR MESSAGE') then
begin
   {SETTING LIST BOX ITEMS}
  with messagemenu do
  begin
   with listbox1 do
   begin
   items.clear;
   end;
  end;
   {CLEARING MESSAGE}
  with listbox1 do
  begin
  items.add('Message Box Cleared');
  items.add('-----------------------------------');
  end;
end

  else

  if command = 'HEALTH - 20' then
begin
  ca.chp := ca.chp - 20;
end;
end;

procedure TGame.Edit2Change(Sender: TObject);
begin
   {SETTING BUTTON}
  if ActiveControl = edit2 then
begin
  button3.Default := true;
end;
end;

procedure TGame.Open1Click(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{Accessing Message Screen}');
  end;
   {CHANGING FORMS}
  MessageMenu.visible := true;
end;

procedure TGame.clear2Click(Sender: TObject);
begin
   {SETTING LIST BOX ITEMS}
  with messagemenu do
  begin
   with listbox1 do
   begin
   items.clear;
   end;
  end;
   {CLEARING MESSAGE}
  with listbox1 do
  begin
  items.add('{Message Box Cleared}');
  items.add('-----------------------------------');
  end;
end;

procedure TGame.delClick(Sender: TObject);
begin
   {MESSAGE}
  with listbox1 do
  begin
  items.add('{Removing Message Files}');
  end;
   {DELETING MESSAGE FILES}
  if fileexists(gamepath+'\messages\'+ca.name+'.dam') then
begin
  deletefile(gamepath+'\messages\'+ca.name+'.dam');
  with listbox1 do
  begin
  items.add('Message Files Removed');
  items.add('-----------------------------------');
  end;
end

  else

begin
  with listbox1 do
  begin
  items.add('{Message Files Not Found}');
  items.add('-----------------------------------');
  end;
end;
end;

procedure TGame.BitBtn3Click(Sender: TObject);
begin
   {MOVING PANEL RIGHT}
  panel5.left := panel5.left + 3;
end;

procedure TGame.BitBtn2Click(Sender: TObject);
begin
   {MOVING PANEL UP}
  panel5.Top := panel5.top - 3;
end;

procedure TGame.BitBtn1Click(Sender: TObject);
begin
   {MOVING PANEL LEFT}
  panel5.left := panel5.left - 3;
end;

procedure TGame.BitBtn4Click(Sender: TObject);
begin
   {MOVING PANEL DOWN}
  panel5.Top := panel5.top + 3;
end;

procedure TGame.EquipClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('Accessing Equipment Screen');
  end;
   {CHANGING FORMS}
  equipment.visible := true; 
end;

procedure TGame.Timer1Timer(Sender: TObject);
begin
   {SETTING CLOCK}
  if Timer1.Interval = 1000 then
begin
  counter := counter + 1;
  if counter = 10 then
begin

   {ADDING CHARACTER HEALTH (REGEN)}
  if ca.chp < ca.hp then
begin
  if statis = 'Sleeping' then
begin
  ca.chp := ca.chp + 3;
end

  else

  if statis = 'Napping' then
begin
  ca.chp := ca.chp + 2;
end

  else

  if statis = 'Normal' then
begin
  ca.chp := ca.chp + 1;
end;
end;


  counter := 0;
  xtra := xtra + 1;
  label23.caption := IntToStr(xtra);
end;
  if xtra = 6 then
begin
  xtra := 0;
  counter := 0;
  minute := minute + 1;
  label25.caption := IntToStr(minute);
end;
  if minute = 10 then
begin
  minute := 0;
  minutetwo := minutetwo + 1;
  label26.caption := IntToStr(minutetwo);
end;
  if minutetwo = 6 then
begin
  minute := 0;
  minutetwo := 0;
  xtra := 0;
  hour := hour + 1;
end;
  label22.Caption := IntToStr(counter);
  label23.caption := IntToStr(xtra);
  label25.caption := IntToStr(minute);
  label26.caption := IntToStr(minutetwo);
  label28.caption := IntToStr(hour);
end;
end;

procedure TGame.menuClick(Sender: TObject);
begin
   {CHANGING FORMS}
  menuC.visible := true;
   {GIVING TEXT TO EDIT BAR}
  menuc.edit1.text := ca.name;
  game.visible := false;
end;

procedure TGame.Button3Click(Sender: TObject);
begin
  if combobox1.text = '' then
begin
  with listbox1 do
  begin
  items.add('{You have no one to talk to}');
  end;
end

  else

  if edit2.text <> '' then
begin
   {SELECTING TEXT}
  edit2.SelectAll;
   {ASSIGNING VARIABLES}
  current := edit2.text;
   {LIST BOX ITEMS}
  with listbox2 do
  begin
  items.add(ca.name+' Whispers To '+combobox1.text+' : "'+current+'"');
  end;
  with listbox1 do
  begin
  items.add('Say "'+current+'"');
  end;
end

  else

  if edit2.text = '' then
begin
   {LIST BOX ITEMS}
  with listbox1 do
  begin
  items.add('{No text in Whisper box}');
  items.add('-----------------------------------');
  end;
end;
end;

end.
