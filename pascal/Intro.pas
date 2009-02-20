unit Intro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TDeath = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cont: TButton;
    Label4: TLabel;
    close: TBitBtn;
    procedure contClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Death: TDeath;

implementation

uses Screen1;

{$R *.DFM}

procedure TDeath.contClick(Sender: TObject);
begin
  close.visible := true;
  label1.visible := false;
  label2.visible := false;
  label3.visible := false;
  label4.visible := true;
  death.visible := false;
  open.visible := true;
end;

end.
