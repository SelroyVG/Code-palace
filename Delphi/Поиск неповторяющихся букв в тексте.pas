unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Input: TMemo;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
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
var S: string;  scan, lng, char_c, i, j, n: integer; characters: string; ch: string;
begin
    char_c := 1; // ���������� ��������� ������
    scan := 1;  // ����������� ����
    S := Form1.Input.Text;
    lng := length(S);
          while lng > 0 do
          Begin
               characters := Copy (S, 1, 1);
               i := 1;
               Delete (S, i, 1);
               i := Pos (characters, S); // ����� �����
               if not (i > 0) then         // ���� ������ ��� ����� ����
               begin
               if (characters <> ' ') then
               Form1.Edit1.Text := Form1.Edit1.Text + characters + ', ' end
               else
                   Begin
                       n := i;
                       while n > 0 do
                       Begin
                            Delete (S, n, 1);
                            n := Pos(characters, S);
                       End;
                   End;
              lng := length(S);
          End;
end;
end.
