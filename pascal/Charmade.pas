unit Charmade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
charac = record
  charname, typ, race, rank : string;
  str, dex, arm, int, ste, wp, expg, expn : integer;
  lvl, chp, hp, cmana, mana : integer;
  pass : string;
end;
  Tcharcre = class(TForm)
    Label1: TLabel;
    ok: TBitBtn;
    procedure okClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  charcre: Tcharcre;
  chara : charac;
  charf : file;

implementation

uses Info, Human, Alien, Rebellion, Cult;

{$R *.DFM}

procedure Tcharcre.okClick(Sender: TObject);
begin
 character_human.visible := false;
 character_alien.visible := false;
 character_rebellion.visible := false;
 character_cult.visible := false;
 charcre.visible := false;
 darkinfo.visible := true;
end;

end.
