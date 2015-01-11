unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Stohastic (iter: integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Const
   max  = 16;
var
  Form1: TForm1;
  Black: TColor;
 // iter: integer;

implementation

{$R *.dfm}
procedure TForm1.Button1Click(Sender: TObject);
Begin
    Form1.ScrollBar1.Visible := true;
    Form1.Label1.Visible := true;
    Stohastic (ScrollBar1.Position);
End;

procedure TForm1.Stohastic(iter: integer);
Var
   x, y, n, i: Integer;
   mx, my: Integer;
begin
   Form1.Image1.Canvas.Brush.Color := clWhite;
   Form1.Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
   Form1.Image1.Canvas.Pen.Color := clBlack;
   Mx := Form1.Image1.Width div 2;
   My := Form1.Image1.Height div 2;
   Form1.Image1.Canvas.moveto (Mx, My);
   for I := 0 to iter do
   Begin
      x := random (9) - 4;
      y := random (9) - 4;
      if ((Mx + x) > 0) and ((Mx + x) < Form1.Image1.Width) then
          Mx := Mx + x else Mx := Mx - x;
      if ((My + y) > 0) and ((My + y) < Form1.Image1.Height) then
          My := My + y else My := My - y;
     Form1.Image1.Canvas.LineTo(Mx, My);
   End;
end;

procedure TForm1.Button2Click(Sender: TObject);
var iterat: integer;
 t, x, y, p : Real;
   k : LongInt;
   x0, y0, rad : Integer;
begin
   Form1.ScrollBar1.Visible := false;
   Form1.Label1.Visible := false;
    iterat := 5000;
Form1.Image1.Canvas.Brush.Color := clWhite;
   Form1.Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);

   x0 := 0;
   y0 := 350;
   rad :=600;
   x := 0.0;
   y := 0.0;
   for k := 1 To iterat do begin
      p := Random;
      t := x;
     if p <= 1/2 then begin
          x :=  1/2 * x + 1/(2*sqrt(3)) * y;
         y :=  1/(2*sqrt(3)) * t - 1/2 * y;
      end
      else
         begin
            x :=  1/2 * x - 1/(2*sqrt(3)) * y +1/2;
            y :=  -1/(2*sqrt(3)) * t - 1/2 * y + 1/(2*sqrt(3));
         end;
      Image1.Canvas.Pixels[Round(rad * x), y0 - Round(rad * y)] := clBlack;
   end;



end;

 function Julia(x0,y0: real): TColor;
 var
 a,b,x,y,x2,y2,xy: real;
 r:real;
 speed,k: integer;
 begin
 r:=1;
 a:=-0.55; b:=-0.55;
 x:=x0; y:=y0;
 k:=100;
 while (k>0)and(r<4) do
 begin
 x2:=x*x;
 y2:=y*y;
 xy:=x*y;
 x:=x2-y2+a;
 y:=2*xy+b;
 r:=x2+y2;
 dec(k)
 end;
 k:=round((k/100)*255);
 result:=RGB(k,k,k);
 end;

 procedure TForm1.Button3Click(Sender: TObject);
 var
 x_min,y_min,x_max,y_max,hx,hy,x,y: real;
 i,j,n: integer;
 color: TColor;
 begin
 Form1.ScrollBar1.Visible := false;
  Form1.Label1.Visible := false;
 x_min:=-1.5; x_max:=2;
 y_min:=-1.5; y_max:=1.5;
 n:=600;
 y:=y_min;
 hx:=(x_max-x_min)/n;
 hy:=(y_max-y_min)/n;
 for j:=0 to n do
 begin
 x:=x_min;
 for i:=0 to n do
 begin color:=Julia(x,y);
 Image1.Canvas.Pixels[i,j]:=color;
 x:=x+hx;
 end;
 y:=y+hy;
 end;
 end;


procedure TForm1.ScrollBar1Change(Sender: TObject);
var
iter: integer;
begin
    iter := ScrollBar1.Position;
    Form1.Label1.Caption := 'Число итераций: ' + inttostr(iter);
end;

end.
