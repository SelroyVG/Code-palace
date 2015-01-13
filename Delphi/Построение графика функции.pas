unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure search;
    procedure Button1Click(Sender: TObject);
    procedure Build_graph(y_min, y_max: real);
    function Polinom (x, a0, a1, a2, a3, a4, a5: real): real;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;  a: array[1..6] of real; x_sq: array [1..3] of real;

implementation

{$R *.dfm}

procedure Tform1.search;
var H, Hmin, Amax, B, Ag, X1, X2, ax, bx, xz, y_min, y_max: real;  count, N, i, j, M, M_sqrt: integer; check: boolean;
Begin

   A[1] := 4.5;
   A[2] := 0.6;
   A[3] := -23.2;
   A[4] := 108.6;
   A[5] := -147.7;
   A[6] := 38.0;
   N := 5;
   M := 50;
   check := false;
   for i := 1 to N+1 do
   Begin
   if a[i]<0 then
      begin
        if check = false then
          begin
            M_sqrt := i-1;
            Amax := a[i];
            check := true;
          end;
        if a[i]<Amax then
          Amax := a[i];
      End
   End;
   Amax := abs(Amax);
   B := 1 + exp((1/M_sqrt)*ln(Amax/a[1]));

   check := false; M_sqrt := 0;
   for i := 1 to N+1 do
   Begin
   if a[i]>0 then
      begin
        if check = false then
          begin
            Amax := a[i];
            check := true;
          end;
          if M_sqrt = 0 then
           M_sqrt := i-1;
        if a[i] > Amax then
          Amax := a[i];
      End
   End;
     Ag := -(1 + exp((1/M_sqrt)*ln(Amax/a[1])));

     H := (B - Ag)/M;

    count := 1;                                 
    X1 := Ag;

    X2 := Ag + H;

    y_min := Polinom (-10, a[1], a[2], a[3], a[4], a[5], a[6]);
    y_max := Polinom (-10, a[1], a[2], a[3], a[4], a[5], a[6]);

    while (X2 < B) Do
    Begin
        Ax := Polinom (X1, a[1], a[2], a[3], a[4], a[5], a[6]);
        Bx := Polinom (X2, a[1], a[2], a[3], a[4], a[5], a[6]);
        if (y_min > Ax) and (X1 > -5) and (X1 < 5) then
        y_min:=Ax;
        if (y_max < Ax) and (X1 > -5) and (X1 < 5) then
        y_max:=Ax;

        if ((Ax > 0) and (Bx < 0)) or ((Ax < 0) and (Bx > 0))
           then
          Begin
       {   xz := X1 + H/4;
              while (XZ < X2) Do
              Begin
                  Ax := Polinom (XZ - h/4, a[1], a[2], a[3], a[4], a[5], a[6]);
                  Bx := Polinom (XZ, a[1], a[2], a[3], a[4], a[5], a[6]);
                   if ((Ax > 0) and (Bx < 0)) or ((Ax < 0) and (Bx > 0))
                      then
                      Begin  }
                       // x_sq[count] := (2*XZ - h/4)/2;
                          x_sq[count] := (X2 + X1)/2;
                        count := count + 1;
                     { End;
                xz := xz + H/5;
              End;              }


          End;
       X1 := X2;
        X2 := X2 + H;

    End;
      Build_graph (y_min, y_max);
End;

function Tform1.Polinom (x, a0, a1, a2, a3, a4, a5: real): real;
Begin
Result :=  a0*x*x*x*x*x + a1*x*x*x*x + a2*x*x*x + a3*x*x + a4*x + a5;
End;


procedure TForm1.Build_graph(y_min, y_max: real);
var dist_per1_x, dist_per1_y, zero_x, zero_y, i, i2, j, x_spl, y_spl, y_spl_next: integer;
Begin

A[1] := 4.5;
   A[2] := 0.6;
   A[3] := -23.2;
   A[4] := 108.6;
   A[5] := -147.7;
   A[6] := 38.0;

  dist_per1_x := round(Form1.Image1.Width/10);
  dist_per1_y := round(Form1.Image1.height/((y_max-y_min)/5000));
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Rectangle(0,0,Form1.Image1.Width,Form1.Image1.height);
  zero_x := round(Form1.Image1.Width/2);
  zero_y := round(Form1.Image1.Height - abs(y_min/5000)*dist_per1_y) - 10 + 300;
   Form1.Edit4.Text := (floattostr(dist_per1_y));

     Image1.Canvas.Pen.Color := clBlue;

     Image1.Canvas.MoveTo (zero_x, 0);
     Image1.Canvas.LineTo (zero_x, Form1.Image1.Height);
     Image1.Canvas.MoveTo (0, zero_y);
     Image1.Canvas.LineTo (Form1.Image1.Width, zero_y);

      for I := -5 to 5 do

      begin

      for J := 0 to dist_per1_x-1 do
      Begin

          y_spl := zero_y - round(Polinom ((I*dist_per1_x + j)/dist_per1_x, a[1], a[2], a[3], a[4], a[5], a[6])/5);
          y_spl_next := zero_y - round(Polinom ((I*dist_per1_x + j+1)/dist_per1_x, a[1], a[2], a[3], a[4], a[5], a[6])/5);

          if ((y_spl > 0) and (y_spl_next < 0)) or ((y_spl < 0) and (y_spl_next > 0)) then
              Form1.Edit3.Text := inttostr(round(Polinom ((I*dist_per1_x + j)/dist_per1_x, a[1], a[2], a[3], a[4], a[5], a[6])));
           if ((y_spl > Form1.Image1.Height) and (y_spl_next < Form1.Image1.Height)) or ((y_spl < Form1.Image1.Height) and (y_spl_next > Form1.Image1.Height)) then
              Form1.Edit4.Text := inttostr(round(Polinom ((I*dist_per1_x + j)/dist_per1_x, a[1], a[2], a[3], a[4], a[5], a[6])));
            x_spl := zero_x + I*dist_per1_x + j;
         Image1.Canvas.Pen.Color := clRed;
        Image1.Canvas.MoveTo(x_spl, y_spl);
        Image1.Canvas.LineTo(x_spl+1, y_spl_next);

      End;
   End;
    Form1.Memo1.Lines.Add('X(' + inttostr(1) + ') = ' + floattostr(x_sq[1]));
    Form1.Memo1.Lines.Add('X(' + inttostr(2) + ') = ' + floattostr(x_sq[2]));
    Form1.Memo1.Lines.Add('X(' + inttostr(3) + ') = ' + floattostr(x_sq[3]));
    Form1.Edit1.Text := ('5');
    Form1.Edit2.Text := ('-5');
End;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Form1.Memo1.Clear;
    search;
end;

end.
