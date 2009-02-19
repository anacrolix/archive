unit Load0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FileCtrl;

type
  TLoadchar0 = class(TForm)
    Label4: TLabel;
    Select: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    FileListBox1: TFileListBox;
    DriveComboBox1: TDriveComboBox;
    Label6: TLabel;
    Button1: TButton;
    DirectoryListBox1: TDirectoryListBox;
    Label7: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure SelectClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Loadchar0: TLoadchar0;
  charfile : array [1..20] of string[25];
  foundit : Tsearchrec;

implementation

uses Connectser;

{$R *.DFM}

procedure TLoadchar0.SelectClick(Sender: TObject);
begin
  loadchar0.visible := false;
  connect.visible := true;
end;

procedure TLoadchar0.Button1Click(Sender: TObject);
begin
   label7.visible := true;
   DirectoryListBox1.visible := true;
   FileListBox1.visible := false;
   DriveComboBox1.visible := false;
   button2.visible := true;
   button3.visible := true;
end;

procedure TLoadchar0.Button3Click(Sender: TObject);
begin
   label7.visible := false;
   DirectoryListBox1.visible := false;
   FileListBox1.visible := true;
   DriveComboBox1.visible := true;
   button2.visible := false;
   button3.visible := false;
end;

procedure TLoadchar0.Button2Click(Sender: TObject);
begin
   label7.visible := false;
   DirectoryListBox1.visible := false;
   FileListBox1.visible := true;
   DriveComboBox1.visible := true;
   button2.visible := false;
   button3.visible := false;
   FileListBox1.Drive := DriveComboBox1.Drive;
end;

procedure TLoadchar0.DirectoryListBox1Change(Sender: TObject);
begin
   DriveComboBox1.dirlist := DirectoryListBox1;
end;

end.
