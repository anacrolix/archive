unit MessageScreen;

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
  TMessageMenu = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    ok: TButton;
    ListBox1: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    load: TButton;
    Button1: TButton;
    save: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure okClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure saveClick(Sender: TObject);
    procedure loadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MessageMenu: TMessageMenu;
  resent : string[255];
  gamepath : string[255];
  cf : file of character;
  ca : character;

implementation

uses GameScreen;

{$R *.DFM}

procedure TMessageMenu.FormCreate(Sender: TObject);
var
  account, chara : string[50];
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
   {GETTING CHARACTER STATS}
  if fileexists(gamepath+'\save\Dark.chr') then
begin
  assignfile(at, gamepath+'\save\Dark.pth');
  reset(at);
  readln(at, account);
  closefile(at);
   assignfile(at, gamepath+'\save\Dark.chr');
   reset(at);
   readln(at, chara);
   closefile(at);
  assignfile(cf, gamepath+'\save\'+account+'\'+chara+'.sav');
  reset(cf);
  read(cf, ca);
  closefile(cf);
end;
   {CHANGING EDIT BOX}
  edit1.bringtofront;
  button1.sendtoback;  
end;

procedure TMessageMenu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   {LIST BOX ITEMS}
  with game do
  begin
   with listbox1 do
   begin
   items.add('{Message Screen Closed}');
   items.add('-----------------------------------');
   end;
  end;
end;

procedure TMessageMenu.okClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with game do
  begin
   with listbox1 do
   begin
   items.add('{Message Screen Closed}');
   items.add('-----------------------------------');
   end;
  end;
   {CHANGING FORMS}
  messagemenu.visible := false; 
end;

procedure TMessageMenu.Edit1Change(Sender: TObject);
begin
   {CHECKING ACTIVECONTROL}
  if ActiveControl = edit1 then
begin
  button1.Default := true;
end;
end;

procedure TMessageMenu.Button1Click(Sender: TObject);
begin
   {SELECTING TEXT}
  edit1.SelectAll; 
   {CHANGING TO VARIABLE}
  if edit1.text <> '' then
begin
  resent := edit1.text;
end;
   {SETTING LIST BOX}
  if resent <> '' then
begin
  with listbox1 do
  begin
  items.add(resent);
  end;
end;
end;

procedure TMessageMenu.saveClick(Sender: TObject);
begin
   {SAVING FILE}
  with listbox1.items do
  begin
  savetofile(gamepath+'\messages\'+ca.name+'.dam');
  end;
   {INFORMER}
  messagedlg('Messages saved!', mtinformation, [mbok], 0);
end;

procedure TMessageMenu.loadClick(Sender: TObject);
begin
   {SAVING FILE}
  with listbox1.items do
  begin
  loadfromfile(gamepath+'\messages\'+ca.name+'.dam');
  end;
end;

end.
