unit NotRight;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  Tincorrect = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  incorrect: Tincorrect;

implementation

{$R *.DFM}

end.
