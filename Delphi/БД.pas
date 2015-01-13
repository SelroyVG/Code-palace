unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    Edit1: TEdit;
    Label6: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var Town, Time_out, Time_in: array[1..20] of string; F: Textfile;
strings, n, i: integer;
S, Need_town: string;  Number, Place: array[1..20] of integer;
begin
     AssignFile (F, 'Y:\Веселов\Delphi\Лабораторная работа 11\data.txt');
     Reset (F);
     strings := 2;
     Need_town := Form1.Edit1.Text;
  while not EOF (F) do
     Begin
       Readln (F, S);
       n := Pos ('|', S) - 1;
       Number[strings-1] := 0;
       for i := n downto 1 do
       Begin
            Number[strings-1] := Number[strings-1] + round(exp((n-i)*ln(10)))*strtoint(S[i]);
       End;
       Delete(S, 1, n+1);

       n := Pos ('|', S) - 1;
       Town[strings-1] := Copy (S, 0, n);
       Delete(S, 1, n+1);
     n := Pos ('|', S) - 1;
     Time_out[strings-1] := Copy (S, 0, n);
     Delete(S, 1, n+1);
     n := Pos ('|', S) - 1;
     Time_in[strings-1] := Copy (S, 0, n);
     Delete(S, 1, n+1);

     n := length(S);
     Place[strings-1] := 0;
     for i := n downto 1 do
       Begin
            Place[strings-1] := Place[strings-1] + round(exp((n-i)*ln(10)))*strtoint(S[i]);
       End;
              strings := strings + 1;
     End;
     Form1.Memo.Lines.Clear;
     for i := 1 to strings-1 do
         if Town[i] = Need_town then Form1.Memo.Lines.Add('Рейс №' + inttostr(Number[i]) + ' отправляется в ' + Time_out[i] + '. Осталось ' + inttostr(Place[i]) + ' свободных мест.');
    CloseFile (F);
end;
procedure TForm1.Button2Click(Sender: TObject);
var S: string; F: Textfile;
begin
      AssignFile (F, 'Y:\Веселов\Delphi\Лабораторная работа 11\data.txt');
       Append (F);
      S := Edit2.Text + '|' + Edit3.Text + '|' + Edit4.Text + '|' + Edit5.Text + '|' + Edit6.Text;
      Writeln (F); Write(F, S);
      CloseFile (F);
      end;
end.

