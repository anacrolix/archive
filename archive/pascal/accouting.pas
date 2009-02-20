unit accouting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Taccountnam = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  accountnam: Taccountnam;

implementation

{$R *.DFM}

procedure Taccountnam.Button1Click(Sender: TObject);
begin
 accountnam.visible := false;
end;

end.
