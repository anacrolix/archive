unit Accountnew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls, MPlayer;

type
hold = record
  name : string[20];
  pass : string[20];
end;

type
  TAccount1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Panel1: TPanel;
    Edit2: TEdit;
    Label3: TLabel;
    PopupMenu1: TPopupMenu;
    Clear: TMenuItem;
    Clear1: TMenuItem;
    Label4: TLabel;
    Edit3: TEdit;
    ok: TButton;
    cancel: TButton;
    line1: TMenuItem;
    accept: TMenuItem;
    cancel1: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    MediaPlayer3: TMediaPlayer;
    procedure ClearClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure cancel1Click(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure acceptClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Account1: TAccount1;
  af : file of hold;
  aa : hold;
  at : text;
  gamepath : string[255];

implementation

uses Racenew, Accountchoice, Accountload;

{$R *.DFM}

procedure TAccount1.ClearClick(Sender: TObject);
begin
  {POPUP CLEAR PASSWORDS EDIT BOXES}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
 edit2.text := '';
 edit3.text := '';
end;

procedure TAccount1.Clear1Click(Sender: TObject);
begin
   {POPUP CLEAR NAME EDIT BOX}
  mediaplayer2.open;
  with mediaplayer2 do
  begin
  wait := true;
  play;
  end;
  mediaplayer2.close;
  edit1.text := '';
end;

procedure TAccount1.FormCreate(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
  mediaplayer3.filename := gamepath+'\Misc\Left Click.wav';
   {DISABLING OK BUTTON ON FORM}
  ok.enabled := false;
end;

procedure TAccount1.cancelClick(Sender: TObject);
begin
    {ACTIVATING CANCEL BUTTON}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   edit2.Text := '';
   edit3.text := '';
   Account1.visible := false;
end;

procedure TAccount1.Edit3Change(Sender: TObject);
begin
     {DISABLING OK BUTTON}
   if edit3.text = '' then
begin
  ok.enabled := false;
  accept.visible := false;
end;
  if edit2.Text <> edit3.text then
begin
  ok.enabled := false;
  accept.visible := false;
end;
     {ENABLING OK BUTTON FOR ACCOUNTING}
   if (edit1.text <> '') and (edit2.text <> '') and (edit3.text <> '') and
   (edit2.text = edit3.text) then
begin
  ok.enabled := true;
  accept.visible := true;
end;
end;

procedure TAccount1.cancel1Click(Sender: TObject);
begin
    {ACTIVATING POPUP CANCEL BUTTON}
  mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   Account1.visible := false;
end;

procedure TAccount1.okClick(Sender: TObject);
begin
       {PLAYING WAV}
  mediaplayer3.open;
  with mediaplayer3 do
  begin
  wait := true;
  play;
  end;
  mediaplayer3.close;
       {SETTING VALUE TO ACCOUNT RECORD NAME}
  aa.name := edit1.text;
       {SETTING VALUE TO ACCOUNT RECORD PASS}
  aa.pass := edit2.text;
       {CREATING FOLDER AND INFO FILE FOR ACCOUNTS}
  createdir(gamepath+'\save\'+edit1.text);
  assignfile(af, gamepath+'\save\'+edit1.text+'.acu');
  rewrite(af);
  write(af,aa);
  closefile(af);
   account3.edit2.text := edit1.text;
       {CHANGING FORMS}
  edit2.text := '';
  edit3.text := '';
  account1.visible := false;
  race.visible := true;
end;

procedure TAccount1.Edit2Change(Sender: TObject);
begin
     {DISABLING OK BUTTON}
  if edit2.text = '' then
begin
  ok.enabled := false;
  accept.visible := false;
end;
  if edit2.text <> edit3.text then
begin
  ok.enabled := false;
  accept.visible := false;
end;
end;

procedure TAccount1.Edit1Change(Sender: TObject);
begin
     {DISABLING OK BUTTON}
  if edit1.text = '' then
begin
  ok.enabled := false;
  accept.visible := false;
end;
end;

procedure TAccount1.acceptClick(Sender: TObject);
begin
       {PLAYING WAV}
  mediaplayer3.open;
  with mediaplayer3 do
  begin
  wait := true;
  play;
  end;
  mediaplayer3.close;
       {SETTING VALUE TO ACCOUNT RECORD NAME}
  aa.name := edit1.text;
       {SETTING VALUE TO ACCOUNT RECORD PASS}
  aa.pass := edit2.text;
       {CREATING FOLDER AND INFO FILE FOR ACCOUNTS}
  createdir(gamepath+'\save\'+edit1.text);
  assignfile(af, gamepath+'\save\'+edit1.text+'.acu');
  rewrite(af);
  write(af,aa);
  closefile(af);
   account3.edit2.text := edit1.text;
       {CHANGING FORMS}
  edit2.text := '';
  edit3.text := '';
  account1.visible := false;
  race.visible := true;
end;

procedure TAccount1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {PLAYING EXITING SOUND}
    mediaplayer1.open;
  with mediaplayer1 do
  begin
  wait := true;
  play;
  end;
  mediaplayer1.close;
   {CHANGING FORMS}
  edit2.Text := '';
  edit3.text := ''; 
  account2.visible := true;
end;

procedure TAccount1.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(at, 'c:\windows\system\Dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
  mediaplayer1.filename := gamepath+'\Misc\Click.wav';
  mediaplayer2.filename := gamepath+'\Misc\Right Click.wav';
  mediaplayer3.filename := gamepath+'\Misc\Left Click.wav';
   {DISABLING OK BUTTON ON FORM}
  ok.enabled := false;
end;

end.
