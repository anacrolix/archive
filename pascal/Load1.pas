unit Load1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TLoadchar1 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Select: TBitBtn;
    BitBtn2: TBitBtn;
    Label4: TLabel;
    procedure SelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Loadchar1: TLoadchar1;

implementation

uses Connectser;

{$R *.DFM}

procedure TLoadchar1.SelectClick(Sender: TObject);
begin
  loadchar1.visible := false;
  connect.visible := true;
end;

end.
