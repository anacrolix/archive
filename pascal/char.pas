unit char;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Button2: TButton;
    Button1: TButton;
    Button4: TButton;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label2: TLabel;
    Panel2: TPanel;
    newfile: TButton;
    BitBtn1: TBitBtn;
    Panel3: TPanel;
    Label3: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    PopupMenu1: TPopupMenu;
    create: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure newfileClick(Sender: TObject);
    procedure createClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ca : character;
  cf : file of character;
  at : text;
  gamepath : string[255];

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Infantry';
   ca.rank := 'Private';
   ca.str := 20;
   ca.dex := 15;
   ca.int := 10;
   ca.arm := 7;
   ca.ste := 3;
   ca.wp := 18;
   ca.lvl := 1;
   ca.hp := 150;
   ca.chp := 150;
   ca.m := 0;
   ca.cm := 0;
   ca.expg := 0;
   ca.expn := 240;
   ca.curmove := 64;
   ca.movement := 64;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Medic';
   ca.rank := 'Private';
   ca.str := 18;
   ca.dex := 20;
   ca.int := 12;
   ca.arm := 6;
   ca.ste := 6;
   ca.wp := 22;
   ca.lvl := 1;
   ca.hp := 120;
   ca.chp := 120;
   ca.m := 10;
   ca.cm := 10;
   ca.expg := 0;
   ca.expn := 130;
   ca.curmove := 78;
   ca.movement := 78;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Explosives Technician';
   ca.rank := 'Private';
   ca.str := 14;
   ca.dex := 25;
   ca.int := 4;
   ca.arm := 3;
   ca.ste := 10;
   ca.wp := 30;
   ca.lvl := 1;
   ca.hp := 180;
   ca.chp := 180;
   ca.m := 0;
   ca.cm := 0;
   ca.expg := 0;
   ca.expn := 200;
   ca.curmove := 104;
   ca.movement := 104;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Artillary';
   ca.rank := 'Private';
   ca.str := 26;
   ca.dex := 10;
   ca.int := 5;
   ca.arm := 11;
   ca.ste := 1;
   ca.wp := 16;
   ca.lvl := 1;
   ca.hp := 200;
   ca.chp := 200;
   ca.m := 0;
   ca.cm := 0;
   ca.expg := 0;
   ca.expn := 310;
   ca.curmove := 41;
   ca.movement := 41;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Spy';
   ca.rank := 'Private';
   ca.str := 12;
   ca.dex := 34;
   ca.int := 18;
   ca.arm := 2;
   ca.ste := 15;
   ca.wp := 8;
   ca.lvl := 1;
   ca.hp := 100;
   ca.chp := 100;
   ca.m := 8;
   ca.cm := 8;
   ca.expg := 0;
   ca.expn := 110;
   ca.curmove := 120;
   ca.movement := 120;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Sniper';
   ca.rank := 'Private';
   ca.str := 14;
   ca.dex := 28;
   ca.int := 20;
   ca.arm := 1;
   ca.ste := 20;
   ca.wp := 30;
   ca.lvl := 1;
   ca.hp := 80;
   ca.chp := 80;
   ca.m := 5;
   ca.cm := 5;
   ca.expg := 0;
   ca.expn := 240;
   ca.curmove := 60;
   ca.movement := 60;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
   ca.race := 'Human';
   ca.type1 := 'Demolitions';
   ca.rank := 'Private';
   ca.str := 30;
   ca.dex := 8;
   ca.int := 2;
   ca.arm := 15;
   ca.ste := 0;
   ca.wp := 40;
   ca.lvl := 1;
   ca.hp := 280;
   ca.chp := 280;
   ca.m := 0;
   ca.cm := 0;
   ca.expg := 0;
   ca.expn := 500;
   ca.curmove := 32;
   ca.movement := 32;
end;

procedure TForm1.newfileClick(Sender: TObject);
begin
  if ca.type1 <> '' then
begin
  assignfile(cf, gamepath+'\characters\'+ca.type1+'.chr');
  rewrite(cf);
  write(cf, ca);
  closefile(cf);
  messagedlg('File Created!  [Now you can exit the program]',mtinformation, [mbok], 0);
end

  else

begin
  messagedlg('No character chosen',mtinformation, [mbok], 0);
end;
end;

procedure TForm1.createClick(Sender: TObject);
begin
  assignfile(cf, gamepath+'\characters\'+ca.type1+'.chr');
  rewrite(cf);
  write(cf, ca);
  closefile(cf);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'Drone';
   ca.rank := 'Lava';
   ca.str := 12;
   ca.dex := 12;
   ca.int := 1;
   ca.arm := 12;
   ca.ste := 4;
   ca.wp := 18;
   ca.lvl := 1;
   ca.hp := 120;
   ca.chp := 120;
   ca.m := 5;
   ca.cm := 5;
   ca.expg := 0;
   ca.expn := 170;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'PsiDrone';
   ca.rank := 'Lava';
   ca.str := 8;
   ca.dex := 18;
   ca.int := 12;
   ca.arm := 9;
   ca.ste := 8;
   ca.wp := 4;
   ca.lvl := 1;
   ca.hp := 60;
   ca.chp := 60;
   ca.m := 12;
   ca.cm := 12;
   ca.expg := 0;
   ca.expn := 150;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'Hatchling';
   ca.rank := 'Lava';
   ca.str := 18;
   ca.dex := 10;
   ca.int := 1;
   ca.arm := 18;
   ca.ste := 2;
   ca.wp := 14;
   ca.lvl := 1;
   ca.hp := 80;
   ca.chp := 80;
   ca.m := 0;
   ca.cm := 0;
   ca.expg := 0;
   ca.expn := 200;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'KeizPredator';
   ca.rank := 'Lava';
   ca.str := 20;
   ca.dex := 5;
   ca.int := 1;
   ca.arm := 21;
   ca.ste := 0;
   ca.wp := 24;
   ca.lvl := 1;
   ca.hp := 200;
   ca.chp := 200;
   ca.m := 0;
   ca.cm := 0;
   ca.expg := 0;
   ca.expn := 250;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'BlitzKreig';
   ca.rank := 'Lava';
   ca.str := 10;
   ca.dex := 27;
   ca.int := 11;
   ca.arm := 3;
   ca.ste := 14;
   ca.wp := 8;
   ca.lvl := 1;
   ca.hp := 60;
   ca.chp := 60;
   ca.m := 8;
   ca.cm := 8;
   ca.expg := 0;
   ca.expn := 120;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'Devourer';
   ca.rank := 'Lava';
   ca.str := 16;
   ca.dex := 18;
   ca.int := 2;
   ca.arm := 7;
   ca.ste := 8;
   ca.wp := 13;
   ca.lvl := 1;
   ca.hp := 180;
   ca.chp := 180;
   ca.m := 2;
   ca.cm := 2;
   ca.expg := 0;
   ca.expn := 190;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
   ca.race := 'Alien';
   ca.type1 := 'Overseer';
   ca.rank := 'Lava';
   ca.str := 20;
   ca.dex := 24;
   ca.int := 8;
   ca.arm := 13;
   ca.ste := 20;
   ca.wp := 29;
   ca.lvl := 1;
   ca.hp := 45;
   ca.chp := 45;
   ca.m := 3;
   ca.cm := 3;
   ca.expg := 0;
   ca.expn := 280;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
end;

end.
