unit Opening;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MPlayer;

type
  Tsound = class(TForm)
    Label1: TLabel;
    Label5: TLabel;
    MediaPlayer1: TMediaPlayer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  sound: Tsound;

implementation

uses Main;

{$R *.DFM}

procedure Tsound.FormCreate(Sender: TObject);
begin
   with MediaPlayer1 do
  begin
    AutoRewind := True;
    try
      Open;          { Open Media Player }
      Wait := True;  { Waits until sounds is done playing to return }
      Play;          { Play sound }
      Play;          { Play again after first playing is completed }
    finally
      Close;             { Close media player }
      end;
   end;
end;

procedure Tsound.Button1Click(Sender: TObject);
begin
  sound.visible := false;
  open.visible := true;
end;

end.
