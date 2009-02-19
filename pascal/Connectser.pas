unit Connectser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type

charac = record
  charname, typ, race, rank, pass : string[25];
  str, dex, arm, int, ste, wp, expg, expn : integer;
  lvl, chp, hp, cmana, mana : integer;
end;

type
  TConnect = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Connect: TConnect;
  chara : charac;
  charl : file of charac;

implementation

uses Game_Screen, Main;

{$R *.DFM}

procedure TConnect.BitBtn1Click(Sender: TObject);
begin
  connect.visible := false;
  apocalypse.visible := true;
end;

end.
