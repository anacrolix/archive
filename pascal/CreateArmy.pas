unit CreateArmy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, MPlayer, Menus;

type
character = record
  name, type1, race, rank : string[50];
  str, dex, int, arm, ste, wp, lvl : integer;
  hp, chp, m, cm : integer;
  expg, expn : integer;
  curmove, movement : integer;
end;

type
army = record
  name, race : string[50];
  min, max : integer;
  leader : string[50];
end;

type
  TNewarmy = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    cancel: TButton;
    keep: TButton;
    PopupMenu1: TPopupMenu;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    Edit2: TEdit;
    Edit3: TEdit;
    min: TMenuItem;
    max: TMenuItem;
    clear: TMenuItem;
    N1: TMenuItem;
    keep1: TMenuItem;
    cancel1: TMenuItem;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure minClick(Sender: TObject);
    procedure maxClick(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure cancel1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cancelClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure keepClick(Sender: TObject);
    procedure keep1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Newarmy: TNewarmy;
  ma : army;
  mf : file of army;
  at : text;
  ca : character;
  cf : file of character;
  gamepath, path1, path2 : string[255];

implementation

uses GameScreen, Accountload;

{$R *.DFM}

procedure TNewarmy.Edit1Change(Sender: TObject);
begin
   {DEACTIVATING KEEP BUTTON}
  if edit1.text = '' then
begin
  keep.enabled := false;
  keep1.enabled := false;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (edit2.text <> '') and (edit3.text <> '') then
begin
  keep.enabled := true;
  keep1.visible := true;
   {SETTING NAME FOR ARMY}
  ma.name := edit1.text;
end;

end;

procedure TNewarmy.Edit2Change(Sender: TObject);
begin
   {DEACTIVATING KEEP BUTTON}
  if edit2.text = '' then
begin
  keep.enabled := false;
  keep1.enabled := false;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (edit2.text <> '') and (edit3.text <> '') then
begin
  keep.enabled := true;
  keep1.visible := true;
end;
   {SETTING MIN VALUE}
  if edit2.text <> '' then
begin
   {SETTTING ARMY MIN MEMBERS}
  ma.min := StrToInt(edit2.text);
end

  else

  if edit1.text  = '4' then
begin
  edit2.text := IntToStr(5);
end

  else

  if edit2.text = '3' then
begin
  edit2.text := IntToStr(5);
end

  else

  if edit2.text = '2' then
begin
  edit2.text := IntToStr(5);
end

  else

  if edit2.text = '1' then
begin
  edit2.text := IntToStr(5);
end;

end;

procedure TNewarmy.minClick(Sender: TObject);
begin
   {SETTING MINIMUM VALUES}
  edit2.Text := '5'; 
end;

procedure TNewarmy.maxClick(Sender: TObject);
begin
   {SETTING MAXIMUM VALUE TO MEMBER}
  edit3.text := '99'; 
end;

procedure TNewarmy.clearClick(Sender: TObject);
begin
   {CLEARING NAME EDIT BOX}
  edit1.text := ''; 
end;

procedure TNewarmy.cancel1Click(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with game do
  begin
  with listbox1 do
  begin
  items.add('{New Army Menu Closed}');
  items.add('-----------------------------------');
  end;
  end;
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  newarmy.visible := false;
end;

procedure TNewarmy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {LIST BOX ITEMS}
  with game do
  begin
  with listbox1 do
  begin
  items.add('{New Army Menu Closed}');
  items.add('-----------------------------------');
  end;
  end;
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close; 
end;

procedure TNewarmy.cancelClick(Sender: TObject);
begin
   {LIST BOX ITEMS}
  with game do
  begin
  with listbox1 do
  begin
  items.add('{New Army Menu Closed}');
  items.add('-----------------------------------');
  end;
  end;
   {PLAYING SOUND}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  newarmy.visible := false;
end;

procedure TNewarmy.Edit3Change(Sender: TObject);
begin
   {DEACTIVATING KEEP BUTTON}
  if edit3.text = '' then
begin
  keep.enabled := false;
  keep1.enabled := false;
end;
   {ACTIVATING KEEP BUTTON}
  if (edit1.text <> '') and (edit2.text <> '') and (edit3.text <> '') then
begin
  keep.enabled := true;
  keep1.visible := true;
   if edit3.Text <> '' then
begin
   {SETTING ARMY MAX MEMBERS}
  ma.max := StrToInt(edit3.text);
end;
end;
end;

procedure TNewarmy.keepClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING VALUES}
  if ma.min = 0 then
begin
  ma.min := 5;
end;
  if ma.max = 0 then
begin
  ma.max := 6;
end;
  if ma.min < 5 then
begin
  ma.min := 5;
end;
  if ma.max > 99 then
begin
  ma.max := 99;
end;
  if ma.max < 6 then
begin
  ma.max := 6;
end;
  if ma.max <= ma.min then
begin
  ma.max := ma.min + 1;
end;
   {MAKING NAME}
  ma.name := edit1.text; 
   {CREATING FILES}
  assignfile(mf, gamepath+'\save\'+ma.name+'.ard');
  rewrite(mf);
  write(mf, ma);
  closefile(mf);
   {CLEARING EDIT BOXES}
  edit1.text := '';
  edit2.text := '';
  edit3.text := '';
   {ARMY VALUES ON GAME FORM BEING SET}
  with game do
  begin
  edit4.text := ma.name;
  edit6.text := IntToStr(ma.min);
  edit7.text := IntToStr(ma.max);
  with listbox3 do
  begin
  items.clear;
  items.add(ma.leader);
  end;
  with listbox4 do
  begin
  items.clear;
  items.add(ma.leader);
  end;
  with listbox1 do
  begin
  items.add('{New Army Menu Closed}');
  items.add('-----------------------------------');
  end;
  end;
   {CHANGING FORMS}
  newarmy.visible := false;
end;

procedure TNewarmy.keep1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHECKING VALUES}
  if ma.min = 0 then
begin
  ma.min := 5;
end;
  if ma.max = 0 then
begin
  ma.max := 6;
end;
  if ma.min < 5 then
begin
  ma.min := 5;
end;
  if ma.max > 99 then
begin
  ma.max := 99;
end;
  if ma.max < 6 then
begin
  ma.max := 6;
end;
  if ma.max <= ma.min then
begin
  ma.max := ma.min + 1;
end;
   {MAKING NAME}
  ma.name := edit1.text; 
   {CREATING FILES}
  assignfile(mf, gamepath+'\save\'+ma.name+'.ard');
  rewrite(mf);
  write(mf, ma);
  closefile(mf);
   {CLEARING EDIT BOXES}
  edit1.text := '';
  edit2.text := '';
  edit3.text := '';
   {ARMY VALUES ON GAME FORM BEING SET}
  with game do
  begin
  edit4.text := ma.name;
  edit6.text := IntToStr(ma.min);
  edit7.text := IntToStr(ma.max);
  with listbox3 do
  begin
  items.clear;
  items.add(ma.leader);
  end;
  with listbox1 do
  begin
  items.add('{New Army Menu Closed}');
  items.add('-----------------------------------');
  end;
  end;
   {CHANGING FORMS}
  newarmy.visible := false;
end;

procedure TNewarmy.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Left Click.wav';
end;

procedure TNewarmy.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Left Click.wav';
   {GETTING ARMY RACE}
   {GETTING ACCOUNT/CHARACTER}
  path1 := account3.edit2.text;
  path2 := game.label14.caption;
   {GETTING CHARACTER STATS}
  assignfile(cf, gamepath+'\save\'+path1+'\'+path2+'.sav');
  reset(cf);
  read(cf, ca);
  closefile(cf);
   {SETTING ARMY VARIABLES}
  ma.race := ca.race;
  label10.caption := ca.race;
  ma.leader := ca.name;
  label12.caption := ma.leader;
end;

end.
