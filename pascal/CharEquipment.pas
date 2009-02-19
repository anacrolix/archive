unit CharEquipment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tequipment = class(TForm)
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  equipment: Tequipment;

implementation

uses GameScreen;

{$R *.DFM}

procedure Tequipment.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {LIST BOX ITEMS}
  with game do
  begin
   with listbox1 do
   begin
   items.add('Equipment Screen Closed');
   items.add('-----------------------------------');
   end;
  end;
end;

end.
