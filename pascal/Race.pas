unit Race;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TCharacter = class(TForm)
    Label1: TLabel;
    label9: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Human: TRadioButton;
    Alien: TRadioButton;
    Rebellion: TRadioButton;
    Cult: TRadioButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Character: TCharacter;

implementation

uses Human, Rebellion, Cult, Alien;

{$R *.DFM}

procedure TCharacter.BitBtn1Click(Sender: TObject);
begin
 if character.visible = true then character.visible := False;
 if Human.checked = true then
begin
 if character_human.visible = false then character_human.visible := true;
end;
 if Alien.checked = true then
begin
 if character_alien.visible = false then character_alien.visible := true;
end;
 if Rebellion.checked = true then
begin
 if character_rebellion.visible = false then character_rebellion.visible :=true;
end;
 if cult.checked = true then
begin
 if character_cult.visible = false then character_cult.visible := true;
end;
end;

end.
