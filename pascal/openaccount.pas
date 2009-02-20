unit openaccount;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
account = record
  accountnam : string[20];
  pass : string[20];
end;

type
  Taccountload = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  accountload: Taccountload;
  ples : account;
  accou : file of account;
  charf : text;
  path1 : string[20];

implementation

uses Race;

{$R *.DFM}

procedure Taccountload.FormCreate(Sender: TObject);
begin
  if fileexists('c:\tp\turbo\dark\save\Dark.pth') then
begin
   assignfile(charf, 'c:\tp\turbo\dark\save\Dark.pth');
   reset(charf);
   readln(charf, path1);
   closefile(charf);
end;
  if fileexists('c:\tp\turbo\dark\save\'+path1+'\'+path1+'.acu') then
begin
  assignfile(accou, 'c:\tp\turbo\dark\save\'+path1+'\'+path1+'.acu');
  reset(accou);
  read(accou, ples);
  closefile(accou);
end;
  button1.enabled := false;
  label2.caption := path1;
end;

procedure Taccountload.Edit1Change(Sender: TObject);
begin
  if edit1.text = ples.pass then
begin
  button1.enabled := true;
end;
end;

procedure Taccountload.Button1Click(Sender: TObject);
begin
   if edit1.Text = ples.pass then
begin
  button1.enabled := true;
end;
  accountload.visible := false;
  character.visible := true;
end;

end.
