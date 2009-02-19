unit CharacterMenu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FileCtrl;

type
  TMenuC = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Label4: TLabel;
    ListBox1: TListBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel3: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    Panel4: TPanel;
    Edit1: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Panel5: TPanel;
    Cancel: TButton;
    OK: TButton;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MenuC: TMenuC;
  gamepath, original : string[255];
  at : text;

implementation

uses GameScreen;

{$R *.DFM}

procedure TMenuC.FormShow(Sender: TObject);
begin
   {GETTING GAME PATH}
  assignfile(At, 'c:\windows\system\dark.dap');
  reset(at);
  readln(at, gamepath);
  closefile(at);
   {DISPLAYING CURRENT DIRECTORIES}
  directorylistbox1.Directory := gamepath+'\Save\'+game.label21.caption+'\';
   {GETTING ORIGINAL NAME}
  original := edit1.text;
  edit1.BringToFront;
  button1.SendToBack;
end;

procedure TMenuC.OKClick(Sender: TObject);
begin
   {LOOKING AT CHECK BUTTONS}
  if checkbox1.checked = true then
begin
  game.listbox1.visible := true;
  game.clear1.visible := true;
end

  else

  if checkbox1.checked = false then
begin
  game.listbox1.visible := false;
  game.clear1.visible := false;
end;
  if checkbox2.checked = true then
begin
  game.groupbox1.visible := true;
end

  else

  if checkbox2.checked = false then
begin
  game.GroupBox1.visible := false;
end;
  if checkbox3.checked = true then
begin
  game.panel4.visible := true;
  game.button1.visible := true;
end

  else

  if checkbox3.checked = false then
begin
  game.Panel4.Visible := false;
  game.Button1.visible := false;
end;
  if checkbox4.checked = true then
begin
  game.panel3.visible := true;
end

  else

  if checkbox4.checked = false then
begin
  game.panel3.visible := false;
end;
end;

procedure TMenuC.Edit1Change(Sender: TObject);
begin
   {CHANGING BUTTONS}
  if ActiveControl = Edit1 then
begin
  button1.default := true;
end;
end;

procedure TMenuC.Button1Click(Sender: TObject);
begin
  if edit1.text = '' then
begin
end

  else

  if edit1.text <> '' then
begin
   {CONVERTING TO VARIABLES}
  current := edit1.text;
   {DELETING ORIGINAL FILES}
  DeleteFile(gamepath+'\Save\'+game.label21.caption+'\'+game.label14.caption+'.sav');
   {CHANGING CHARACTER NAME}
  game.Label14.caption := edit1.text;
   MessageDlg('Character Name Changed [You Need to Save Character Before you Quit]',mtinformation,
      [mbOK], 0);
end;
end;

procedure TMenuC.CancelClick(Sender: TObject);
begin
   {CHANGING FORMS}
  MenuC.visible := false;
  game.visible := true;
end;

procedure TMenuC.ListBox1Click(Sender: TObject);
begin
   {DRAGGING = TRUE}

end;

procedure TMenuC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   {CHANGING FORMS}
  game.visible := true;
end;

end.
