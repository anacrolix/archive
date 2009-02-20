unit Accountchoice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, MPlayer;

type
  Taccount2 = class(TForm)
    PopupMenu1: TPopupMenu;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OK: TButton;
    OK1: TButton;
    cancel: TButton;
    new: TMenuItem;
    load: TMenuItem;
    line1: TMenuItem;
    cancel1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    procedure OKClick(Sender: TObject);
    procedure newClick(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure cancel1Click(Sender: TObject);
    procedure OK1Click(Sender: TObject);
    procedure loadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  account2: Taccount2;

implementation

uses Accountnew, Accountload;

{$R *.DFM}

procedure Taccount2.OKClick(Sender: TObject);
begin
   {CHANGING FORMS}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
  account2.visible := false;
  account1.visible := true;
end;

procedure Taccount2.newClick(Sender: TObject);
begin
   {CHANGING FORMS}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
  account2.visible := false;
  account1.visible := true;
end;

procedure Taccount2.cancelClick(Sender: TObject);
begin
   {CHANGING FORMS}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
  account2.visible := false; 
end;

procedure Taccount2.cancel1Click(Sender: TObject);
begin
   {CHANGING FORMS}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;   
  account2.visible := false; 
end;

procedure Taccount2.OK1Click(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHANGING FORMS}
  Account2.visible := false;
  Account3.visible := true;
end;

procedure Taccount2.loadClick(Sender: TObject);
begin
   {PLAYING SOUND}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
   {CHANGING FORMS}
  Account2.visible := false;
  Account3.visible := true;
end;

procedure Taccount2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {PLAYING EXITING SOUND}
    mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
end;

procedure Taccount2.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

procedure Taccount2.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
end;

end.
