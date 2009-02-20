unit Newaccount;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls;

type
acc = record
  accountnam : string[20];
  pass : string[20];
end;

type
  Taccountset = class(TForm)
    accountname: TEdit;
    pass1: TEdit;
    pass2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    BitBtn1: TBitBtn;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  accountset: Taccountset;
  ples : acc;
  accou : file of acc;
  accoun : text;

implementation

uses NotRight, Password, accouting, Race;

{$R *.DFM}

procedure Taccountset.Button2Click(Sender: TObject);
var
  path1 : string[20];
begin
 if accountname.text = '' then
begin
  accountnam.visible := true;
end

  else

 if pass1.text = '' then
begin
  nopass.visible := true;
end

  else

 if pass1.text <> pass2.text then
begin
  incorrect.visible := true;
end;

 if (pass1.text = pass2.text) and (pass1.text <> '') and (accountname.text <> '') then
begin
  ples.accountnam := accountname.text;
  ples.pass := pass1.text;
  CreateDir('c:\tp\turbo\dark\save\'+accountname.text+'');
     assignfile(accou, 'c:\tp\turbo\dark\save\'+accountname.text+'\'+accountname.text+'.acu');
     rewrite(accou);
   write(accou, ples);
   closefile(accou);
   if fileexists('c:\tp\turbo\dark\save\Dark.pth') then
begin
  assignfile(accoun, 'c:\tp\turbo\dark\save\Dark.pth');
  reset(accoun);
  readln(accoun, path1);
  closefile(accoun);
    removedir('c:\tp\turbo\dark\save\'+path1);
end;

begin
  assignfile(accoun, 'c:\tp\turbo\dark\save\Dark.pth');
  rewrite(accoun);
  writeln(accoun, accountname.text);
  closefile(accoun);
end;
  accountset.visible := false;
  character.visible := true;

end;
end;

procedure Taccountset.FormCreate(Sender: TObject);
begin
   accountname.text := ples.accountnam;
   pass1.text := ples.pass;
end;

end.
