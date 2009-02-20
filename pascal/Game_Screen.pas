unit Game_Screen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ExtCtrls, ToolWin, StdCtrls, DBCtrls, Mask, Clipbrd;

type
charac = record
  charname, typ, race, rank, pass : string[25];
  str, dex, arm, int, ste, wp, expg, expn : integer;
  lvl, chp, hp, cmana, mana : integer;
end;

type
acc = record
  accountname : string[20];
  pass : string[20];
end;

type
  TApocalypse = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    AutoCommands1: TMenuItem;
    KillEnemy1: TMenuItem;
    WearItem1: TMenuItem;
    CharacterStats1: TMenuItem;
    CharacterSkills1: TMenuItem;
    Inventory1: TMenuItem;
    Equipment1: TMenuItem;
    Copy: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    MainMenu1: TMainMenu;
    statis: TDBLookupComboBox;
    Talk1: TEdit;
    Whisper1: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Help1: TMenuItem;
    File1: TMenuItem;
    Commands1: TMenuItem;
    whatcom1: TMenuItem;
    HowtouseCommands1: TMenuItem;
    SpecialCommands1: TMenuItem;
    Contents1: TMenuItem;
    About1: TMenuItem;
    InformationonCreators1: TMenuItem;
    OtherCreations1: TMenuItem;
    Quit1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    ListBox2: TListBox;
    com1: TEdit;
    Label5: TLabel;
    Edit1: TMenuItem;
    Paste2: TMenuItem;
    Copy1: TMenuItem;
    Cut2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ListBox3: TListBox;
    Army: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    N3: TMenuItem;
    Panel3: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ListBox4: TListBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    StatusBar1: TStatusBar;
    Panel4: TPanel;
    procedure KillEnemy1Click(Sender: TObject);
    procedure WearItem1Click(Sender: TObject);
    procedure CharacterStats1Click(Sender: TObject);
    procedure CharacterSkills1Click(Sender: TObject);
    procedure Inventory1Click(Sender: TObject);
    procedure Equipment1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Cut2Click(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Apocalypse: TApocalypse;
  chara : charac;
  charf : file of charac;
  accou : file of acc;
  charl : text;
  ples : acc;

implementation

{ $APPTYPE CONSOLE }
uses CStats, Inventory, Equipment, Skills, Main, Conferm1, Connectser;

{$R *.DFM}

procedure TApocalypse.KillEnemy1Click(Sender: TObject);
begin
  com1.text := 'Kill ';
end;

procedure TApocalypse.WearItem1Click(Sender: TObject);
begin
  com1.text := 'Wear ';
end;

procedure TApocalypse.CharacterStats1Click(Sender: TObject);
begin
  Stats.visible := true;
end;

procedure TApocalypse.CharacterSkills1Click(Sender: TObject);
begin
 Ski.visible := true;
end;

procedure TApocalypse.Inventory1Click(Sender: TObject);
begin
 Inv.visible := true;
end;

procedure TApocalypse.Equipment1Click(Sender: TObject);
begin
 Equ.visible := true;
end;

procedure TApocalypse.Button1Click(Sender: TObject);
begin
  Stats.visible := true;
end;

procedure TApocalypse.Button2Click(Sender: TObject);
begin
  Ski.visible := true;
end;

procedure TApocalypse.Button3Click(Sender: TObject);
begin
  Equ.visible := true;
end;

procedure TApocalypse.Button4Click(Sender: TObject);
begin
  Inv.visible := true;
end;

procedure TApocalypse.Quit1Click(Sender: TObject);
begin
  conferm.visible := true;
end;

procedure TApocalypse.Cut2Click(Sender: TObject);
begin
  com1.CutToClipboard;
end;

procedure TApocalypse.Paste2Click(Sender: TObject);
begin
  com1.pastefromClipboard;
end;

procedure TApocalypse.Copy1Click(Sender: TObject);
begin
  com1.copytoclipboard;
end;

procedure TApocalypse.CopyClick(Sender: TObject);
begin
  com1.CopyToClipboard;
end;

procedure TApocalypse.Cut1Click(Sender: TObject);
begin
  com1.CutToClipboard;
end;

procedure TApocalypse.Paste1Click(Sender: TObject);
begin
  com1.PasteFromClipboard;
end;

procedure TApocalypse.FormCreate(Sender: TObject);
var
  path1 : string[20];
begin
   if fileexists('c:\tp\turbo\dark\save\Dark.pth') then
begin
  assignfile(charl, 'C:\tp\turbo\dark\save\Dark.pth');
  reset(charl);
  readln(charl, path1);
  closefile(charl);
end;
   if fileexists('c:\tp\turbo\dark\save\'+path1+'\'+path1+'.acu') then
begin
 assignfile(accou, 'c:\tp\turbo\dark\save\'+path1+'\'+path1+'.acu');
 reset(accou);
 read(accou, ples);
 closefile(accou);
end;
   if fileexists('c:\tp\turbo\dark\save\'+path1+'\AchromiciA.sav') then
begin
 assignfile(charf, 'c:\tp\turbo\dark\save\'+path1+'\AchromiciA.sav');
 reset(charf);
 read(charf, chara);
 closefile(charf);
end;
 label9.caption := chara.charname;
 label16.caption := ples.accountname;
end;

procedure TApocalypse.Label9Click(Sender: TObject);
begin
  label9.caption := chara.charname;
end;

procedure TApocalypse.Label16Click(Sender: TObject);
begin
  label16.caption := ples.accountname;
end;

end.
