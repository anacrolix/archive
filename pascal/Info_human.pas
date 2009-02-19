unit Info_human;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, checklst;

type
  THInfo = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    ListBox1: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HInfo: THInfo;

implementation

{$R *.DFM}

end.
