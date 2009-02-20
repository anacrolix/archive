unit accountchoice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  Taccountche = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Button2: TButton;
    Label3: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  accountche: Taccountche;

implementation

uses Newaccount, openaccount;

{$R *.DFM}

procedure Taccountche.Button2Click(Sender: TObject);
begin
 accountche.visible := false;
 accountset.visible := true;
end;

procedure Taccountche.Button1Click(Sender: TObject);
begin
  accountche.visible := false;
  accountload.visible := true;
end;

end.
