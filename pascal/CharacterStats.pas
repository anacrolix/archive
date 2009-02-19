unit CharacterStats;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
  Tcharacter2 = class(TForm)
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
    Panel1: TPanel;
    ok: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label42: TLabel;
    procedure FormShow(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  character2: Tcharacter2;
  at : text;
  cf : file of character;
  ca : character;
  gamepath : string[255];

implementation

uses GameScreen;

{$R *.DFM}

procedure Tcharacter2.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at,gamepath);
  closefile(at);

  if label23.caption = 'Human' then
begin
  label8.caption := 'Character -';
end

  else

  if label23.caption = 'Alien' then
begin
  label8.caption := 'Mutant -';
end;
end;

procedure Tcharacter2.okClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with game do
  begin
  with listbox1 do
  begin
  items.add('{Character Screen Closed}');
  items.add('-----------------------------------');
  end;
  end;
   {CHANGING FORMS}
  character2.visible := false;
end;

procedure Tcharacter2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {LIST BOX ITEMS}
  with game do
  begin
  with listbox1 do
  begin
  items.add('{Character Screen Closed}');
  items.add('-----------------------------------');
  end;
  end;
end;

end.
