unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TOpen = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    New: TBitBtn;
    BitBtn1: TBitBtn;
    Load: TBitBtn;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure NewClick(Sender: TObject);
    procedure LoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Open: TOpen;

implementation

uses Race, Load1, accountchoice, Opening;

{$R *.DFM}

procedure TOpen.NewClick(Sender: TObject);
begin
 accountche.visible := true;
end;

procedure TOpen.LoadClick(Sender: TObject);
begin
 loadchar1.visible := true;
end;

end.
