unit Conferm1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tconferm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Yes: TButton;
    No: TButton;
    procedure YesClick(Sender: TObject);
    procedure NoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  conferm: Tconferm;

implementation

uses Game_Screen, Main;

{$R *.DFM}

procedure Tconferm.YesClick(Sender: TObject);
begin
  apocalypse.visible := false;
  conferm.visible := false;
  open.visible := true;
end;

procedure Tconferm.NoClick(Sender: TObject);
begin
  conferm.visible := false;
end;

end.
