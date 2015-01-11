unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    PaintBox1: TPaintBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    ScrollBar1: TScrollBar;
    GroupBox2: TGroupBox;
    ScrollBar2: TScrollBar;
    GroupBox3: TGroupBox;
    ScrollBar3: TScrollBar;
    GroupBox4: TGroupBox;
    ScrollBar4: TScrollBar;
    GroupBox5: TGroupBox;
    ScrollBar5: TScrollBar;
    GroupBox7: TGroupBox;
    ScrollBar7: TScrollBar;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    ScrollBar8: TScrollBar;
    ScrollBar9: TScrollBar;
    ScrollBar10: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox6: TGroupBox;
    ScrollBar6: TScrollBar;
    procedure Button1Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ScrollBar7Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);
    procedure ScrollBar5Change(Sender: TObject);
    procedure ScrollBar6Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar8Change(Sender: TObject);
    procedure ScrollBar9Change(Sender: TObject);
    procedure ScrollBar10Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


type
  TVector=array[1..4] of real;
  TConvertMatr=array[1..4] of TVector;
  TFigure=array[1..5] of TVector;

Var
  Figure:TFigure=((0,0,0,1),(0,60,0,1),(60,60,0,1),(60,0,0,1),(30,0,40,1));
  NewFigure:TFigure;
  M,T:TConvertMatr;
  Sh:TConvertMatr=((1,0,0,0),(0,1,0,0),(0,0,1,0),(0,0,0,1));
function Tx(f:real):TConvertMatr; //вращение относительно x
var T:TConvertMatr;
begin
  f:=f/180*pi;
  T[1,1]:=1;   T[1,2]:=0;      T[1,3]:=0;       T[1,4]:=0;
  T[2,1]:=0;   T[2,2]:=cos(f); T[2,3]:=sin(f);  T[2,4]:=0;
  T[3,1]:=0;   T[3,2]:=-sin(f);T[3,3]:=cos(f);  T[3,4]:=0;
  T[4,1]:=0;   T[4,2]:=0;      T[4,3]:=0;       T[4,4]:=1;

  Result:=T;
end;

function Ty(f:real):TConvertMatr; //вращение относительно y
var T:TConvertMatr;
begin
  f:=f/180*pi;

  T[1,1]:=cos(f);T[1,2]:=0;    T[1,3]:=-sin(f);  T[1,4]:=0;
  T[2,1]:=0;     T[2,2]:=1;    T[2,3]:=0;        T[2,4]:=0;
  T[3,1]:=sin(f);T[3,2]:=0;    T[3,3]:=cos(f);   T[3,4]:=0;
  T[4,1]:=0;     T[4,2]:=0;    T[4,3]:=0;        T[4,4]:=1;

  Result:=T;
end;

function Tz(f:real):TConvertMatr; //вращение относительно z
var T:TConvertMatr;
begin
  f:=f/180*pi;

  T[1,1]:=cos(f);   T[1,2]:=sin(f);     T[1,3]:=0;    T[1,4]:=0;
  T[2,1]:=-sin(f);  T[2,2]:=cos(f);     T[2,3]:=0;    T[2,4]:=0;
  T[3,1]:=0;        T[3,2]:=0;          T[3,3]:=1;    T[3,4]:=0;
  T[4,1]:=0;        T[4,2]:=0;          T[4,3]:=0;    T[4,4]:=1;

  Result:=T;
end;

function Az:TConvertMatr; //проекция, вид сверху
var A:TConvertMatr;
begin
  A[1,1]:=1;  A[1,2]:=0;  A[1,3]:=0;  A[1,4]:=0;
  A[2,1]:=0;  A[2,2]:=1;  A[2,3]:=0;  A[2,4]:=0;
  A[3,1]:=0;  A[3,2]:=0;  A[3,3]:=0;  A[3,4]:=0;
  A[4,1]:=0;  A[4,2]:=0;  A[4,3]:=0;  A[4,4]:=1;

  Result:=A;
end;

function Ax:TConvertMatr; //проекция, вид слева
var A:TConvertMatr;
begin
  A[1,1]:=0;  A[1,2]:=0;  A[1,3]:=0;  A[1,4]:=0;
  A[2,1]:=0;  A[2,2]:=1;  A[2,3]:=0;  A[2,4]:=0;
  A[3,1]:=0;  A[3,2]:=0;  A[3,3]:=1;  A[3,4]:=0;
  A[4,1]:=0;  A[4,2]:=0;  A[4,3]:=0;  A[4,4]:=1;

  Result:=A;
end;

function Ay:TConvertMatr; //проекция, главный вид
var A:TConvertMatr;
begin
  A[1,1]:=1;  A[1,2]:=0;  A[1,3]:=0;  A[1,4]:=0;
  A[2,1]:=0;  A[2,2]:=0;  A[2,3]:=0;  A[2,4]:=0;
  A[3,1]:=0;  A[3,2]:=0;  A[3,3]:=1;  A[3,4]:=0;
  A[4,1]:=0;  A[4,2]:=0;  A[4,3]:=0;  A[4,4]:=1;

  Result:=A;
end;

function S(a,l,j,s:real):TConvertMatr; //масштабирование по оси x в a раз
Var M:TConvertMatr;
begin
  M[1,1]:=a;  M[1,2]:=0;  M[1,3]:=0;  M[1,4]:=0;
  M[2,1]:=0;  M[2,2]:=l;  M[2,3]:=0;  M[2,4]:=0;
  M[3,1]:=0;  M[3,2]:=0;  M[3,3]:=j;  M[3,4]:=0;
  M[4,1]:=0;  M[4,2]:=0;  M[4,3]:=0;  M[4,4]:=S;

  Result:=M;
end;


function Multipli_Matr(M,T:TConvertMatr):TConvertMatr; //Перемножение двух матриц
var i,j,k:integer;
    V:TConvertmatr;
begin

  for i:=1 to 4 do
    for j:=1 to 4 do
      begin
        V[i,j]:=0;
        for k:=1 to 4 do
          V[i,j]:=V[i,j]+M[i,k]*T[k,j];
      end;

  Result:=V;
end;

//умножает матрицу на вектор
function Multipli_Matr_Vector(M:TConvertMatr;V:TVector):Tvector;
var U:TVector;
    i,j:integer;
begin
  for i:=1 to 4 do
    begin
      U[i]:=0;
      for j:=1 to 4 do
        U[i]:=1.2*(U[i]+M[i,j]*V[j]);  ///!!!
    end;

  Result:=U;
end;


//ортогональная изометрия
Function Ortogon_Isometr:TConvertMatr;
var Q,f:real;
    M:TConvertMatr;
begin
  f:=45/180*pi;
  Q:=35.26/180*pi;

  M:=Multipli_Matr(Ty(-45),Tx(35.26));
  M:=Multipli_Matr(M,Az);

  Result:=M;
end;

//ортогональная диметрия
function Ortogon_Dimetr:TConvertMatr;
var Q,f:real;
    M:TConvertMatr;
begin

  M:=Multipli_Matr(Ty(-22.2),Tx(20.7));
  M:=Multipli_Matr(M,Az);

  Result:=M;
end;

//косоугольная изометрия
function Kosougol_Isometr:TConvertMatr;
var a,b:real;
    M:TConvertMatr;
begin
  a:=cos(45/180*pi);
  b:=cos(45/180*pi);

  M[1,1]:=1;  M[1,2]:=0;  M[1,3]:=0;  M[1,4]:=0;
  M[2,1]:=0;  M[2,2]:=1;  M[2,3]:=0;  M[2,4]:=0;
  M[3,1]:=-a; M[3,2]:=-b; M[3,3]:=0;  M[3,4]:=0;
  M[4,1]:=0;  M[4,2]:=0;  M[4,3]:=0;  M[4,4]:=1;


  Result:=M;
end;

//косоугольная диметрия
function Kosougol_Dimetr:TConvertMatr;
var a,b:real;
    M:TConvertMatr;
begin
  a:=0.5*cos(45/180*pi);
  b:=0.5*cos(45/180*pi);

  M[1,1]:=1;  M[1,2]:=0;  M[1,3]:=0;  M[1,4]:=0;
  M[2,1]:=0;  M[2,2]:=1;  M[2,3]:=0;  M[2,4]:=0;
  M[3,1]:=-a; M[3,2]:=-b; M[3,3]:=0;  M[3,4]:=0;
  M[4,1]:=0;  M[4,2]:=0;  M[4,3]:=0;  M[4,4]:=1;

  Result:=M;
end;

//сдвиг
function Sdvig(l,m,n:real):TConvertMatr;
var T:TConvertMatr;
begin
  T[1,1]:=1;  T[1,2]:=0;  T[1,3]:=0;  T[1,4]:=0;
  T[2,1]:=0;  T[2,2]:=1;  T[2,3]:=0;  T[2,4]:=0;
  T[3,1]:=0;  T[3,2]:=0;  T[3,3]:=1;  T[3,4]:=0;
  T[4,1]:=l;  T[4,2]:=m;  T[4,3]:=n;  T[4,4]:=1;

  Result:=T;

end;

function Perspectiva_1(c:real):TConvertMatr;
var V:TConvertMatr;
begin

  M[1,1]:=1;  M[1,2]:=0;  M[1,3]:=0;  M[1,4]:=0;
  M[2,1]:=0;  M[2,2]:=1;  M[2,3]:=0;  M[2,4]:=0;
  M[3,1]:=0;  M[3,2]:=0;  M[3,3]:=0;  M[3,4]:=-1/c;
  M[4,1]:=0;  M[4,2]:=0;  M[4,3]:=0;  M[4,4]:=1;

  Result:=M;

end;

function Perspectiva_2(c:real):TConvertMatr;
begin

  result:=Multipli_Matr(Multipli_Matr(Multipli_Matr(Sdvig(100,100,100),Tx(30)),Ty(30)),Perspectiva_1(c));
end;

procedure Perspectiva(Vec:TVector;x,y,z,u0,v0:real;var u,v:integer);
begin
  if z-Vec[3]=0 then z:=z+1;
  u:=round(u0+z*(Vec[1]-x)/(z-Vec[3])+x);
  v:=round(v0+z*(Vec[2]-y)/(z-Vec[3])+y);
end;

Procedure Convert_3D_to_2D(const M:TConvertmatr;Vec:TVector; const u0,v0:integer; var xo,yo:integer);
begin
  xo:=u0+round(M[1,1]*Vec[1]+M[2,1]*Vec[2]+M[3,1]*Vec[3]);
  yo:=v0+round(M[1,2]*Vec[1]+M[2,2]*Vec[2]+M[3,2]*Vec[3]);

end;

Procedure Line(x1,y1,x2,y2:integer;Col:TColor);
var HoldCol:TColor;
begin
  Form1.PaintBox1.Canvas.Pen.Color:=Col;
  Form1.PaintBox1.Canvas.MoveTo(x1,y1);
  Form1.PaintBox1.Canvas.LineTo(x2,y2);
end;

Procedure Paint_Figure(u0,v0:integer;Matr:TConvertMatr);   // Рисование фигуры с учётом выбранной проекции
var xp,yp:array[1..8] of integer;
    xo,yo:array[1..4] of integer;
    h:integer;
    V:TVector;
    i:integer;
begin
  h:=Form1.PaintBox1.Height;

  for i:=1 to 5 do
    begin
      V:=Multipli_Matr_Vector(Sh,Figure[i]);  //Умножение матрицы на вектор
      Convert_3D_to_2D(Matr,V,u0,v0,xp[i],yp[i]);
    end;

    V[1]:=0;V[2]:=0;V[3]:=0;
  Convert_3D_to_2D(M,V,u0,v0,xo[1],yo[1]);
  V[1]:=240;V[2]:=0;V[3]:=0;
  Convert_3D_to_2D(M,V,u0,v0,xo[2],yo[2]);
  V[1]:=0;V[2]:=240;V[3]:=0;
  Convert_3D_to_2D(M,V,u0,v0,xo[3],yo[3]);
  V[1]:=0;V[2]:=0;V[3]:=240;
  Convert_3D_to_2D(M,V,u0,v0,xo[4],yo[4]);
 // showmessage (inttostr (xo[1]));
  Line(xo[1],h-yo[1],xo[2],h-yo[2],clBlue);
  Line(xo[1],h-yo[1],xo[3],h-yo[3],clBlue);
  Line(xo[1],h-yo[1],xo[4],h-yo[4],clBlue);

  Line(xp[1],h-yp[1],xp[2],h-yp[2],clBlack);
  Line(xp[2],h-yp[2],xp[3],h-yp[3],clBlack);
  Line(xp[3],h-yp[3],xp[4],h-yp[4],clBlack);
  Line(xp[1],h-yp[1],xp[4],h-yp[4],clBlack);
  Line(xp[1],h-yp[1],xp[5],h-yp[5],clBlack);
  Line(xp[2],h-yp[2],xp[5],h-yp[5],clBlack);
  Line(xp[3],h-yp[3],xp[5],h-yp[5],clBlack);
  Line(xp[4],h-yp[4],xp[5],h-yp[5],clBlack);


  Form1.PaintBox1.Canvas.Font.Color:=clBlack;
  Form1.PaintBox1.Canvas.TextOut(xo[1]-15,yo[1]-15,'O');
  Form1.PaintBox1.Canvas.TextOut(xo[2],h-yo[2],'X');
  Form1.PaintBox1.Canvas.TextOut(xo[3],h-yo[3],'Y');
  Form1.PaintBox1.Canvas.TextOut(xo[4],h-yo[4],'Z');


end;

procedure Paint_Perspect(x,y,z:integer);
var i:integer;
    h:integer;
    xp,yp,xo,yo:array[1..8] of integer;
    u0,v0:real;
    V:TVector;

begin
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;
  Form1.PaintBox1.Canvas.FillRect(Form1.PaintBox1.Canvas.ClipRect);
  h:=Form1.PaintBox1.Height;

  V[1]:=-100;V[2]:=0;V[3]:=0;
  Perspectiva(V,x,y,z,Form1.PaintBox1.Width div 2,Form1.PaintBox1.Height div 2,Xo[1],yo[1]);
  V[1]:=200;V[2]:=0;V[3]:=0;
  Perspectiva(V,x,y,z,Form1.PaintBox1.Width div 2,Form1.PaintBox1.Height div 2,Xo[2],yo[2]);
  V[1]:=-100;V[2]:=y;V[3]:=z;
  Perspectiva(V,x,y,z,Form1.PaintBox1.Width div 2,Form1.PaintBox1.Height div 2,Xo[3],yo[3]);
  V[1]:=200;V[2]:=y;V[3]:=z;
  Perspectiva(V,x,y,z,Form1.PaintBox1.Width div 2,Form1.PaintBox1.Height div 2,Xo[4],yo[4]);

  Line(xo[1],h-yo[1],xo[2],h-yo[2],clGreen);
  Line(xo[3],h-yo[3],xo[4],h-yo[4],clRed);

  for i:=1 to 5 do
    Perspectiva(Figure[i],x,y,z,Form1.PaintBox1.Width div 2,Form1.PaintBox1.Height div 2,Xp[i],yp[i]);

  Line(xp[1],h-yp[1],xp[2],h-yp[2],clBlack);
  Line(xp[2],h-yp[2],xp[3],h-yp[3],clBlack);
  Line(xp[3],h-yp[3],xp[4],h-yp[4],clBlack);
  Line(xp[1],h-yp[1],xp[4],h-yp[4],clBlack);
  Line(xp[1],h-yp[1],xp[5],h-yp[5],clBlack);
  Line(xp[2],h-yp[2],xp[5],h-yp[5],clBlack);
  Line(xp[3],h-yp[3],xp[5],h-yp[5],clBlack);
  Line(xp[4],h-yp[4],xp[5],h-yp[5],clBlack);



  Form1.PaintBox1.Canvas.Brush.Color := clGreen;
  Form1.PaintBox1.Canvas.Rectangle(20-10, 20-10, 20+10, 20+10);
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;

  Form1.PaintBox1.Canvas.Brush.Color := clRed;
  Form1.PaintBox1.Canvas.Rectangle(20-10, 50-10, 20+10, 50+10);
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;
  Form1.PaintBox1.Canvas.Font.Color:=clBlack;
  Form1.PaintBox1.Canvas.TextOut(40,12,'Линия основания');
  Form1.PaintBox1.Canvas.TextOut(40,42,'Линия горизонта');
end;


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;
  Form1.ScrollBar8.Visible := false;
  Form1.ScrollBar9.Visible := false;
  Form1.Label1.Visible := false;
  Form1.Label2.Visible := false;
  M:=Ortogon_Isometr;
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);

end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Sh:=S(ScrollBar1.Position,ScrollBar2.Position,ScrollBar2.Position,1);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);

end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  Sh:=S(ScrollBar1.Position,ScrollBar2.Position,ScrollBar3.Position,1);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);

end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
  Sh:=S(ScrollBar1.Position,ScrollBar2.Position,ScrollBar3.Position,1);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.ScrollBar8.Visible := false;
  Form1.ScrollBar9.Visible := false;
  Form1.Label1.Visible := false;
  Form1.Label2.Visible := false;
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;
  M:=Ortogon_Dimetr;
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Form1.ScrollBar8.Visible := false;
  Form1.ScrollBar9.Visible := false;
  Form1.Label1.Visible := false;
  Form1.Label2.Visible := false;
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;
  M:=Kosougol_Isometr;
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Form1.ScrollBar8.Visible := false;
  Form1.ScrollBar9.Visible := false;
  Form1.Label1.Visible := false;
  Form1.Label2.Visible := false;
  Form1.PaintBox1.Canvas.Brush.Color := clWhite;
  M:=Kosougol_Dimetr;
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);
end;

procedure TForm1.ScrollBar7Change(Sender: TObject);
begin
  Sh:=S(ScrollBar7.Position,ScrollBar7.Position,ScrollBar7.Position,ScrollBar7.Position);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,M);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Form1.ScrollBar8.Visible := true;
  Form1.ScrollBar9.Visible := true;
  Form1.Label1.Visible := true;
  Form1.Label2.Visible := true;
  Paint_Perspect(ScrollBar8.Position,ScrollBar9.Position,ScrollBar10.Position);
end;


procedure TForm1.ScrollBar4Change(Sender: TObject);
begin
  T:=Multipli_Matr(Tx(ScrollBar4.Position),M);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,T);
end;

procedure TForm1.ScrollBar5Change(Sender: TObject);
begin
  T:=Multipli_Matr(Ty(ScrollBar5.Position),M);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,T);
end;

procedure TForm1.ScrollBar6Change(Sender: TObject);
begin
  T:=Multipli_Matr(Tz(ScrollBar6.Position),M);
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,T);

end;

var Stop:boolean=false;
procedure TForm1.Button6Click(Sender: TObject);
var f:real;
    B:TConvertMatr;
begin
  Stop:=false;
  f:=0;
  repeat
    B:=Multipli_Matr(Ty(f),M);
    PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
    Paint_Figure(Paintbox1.Width div 2,PaintBox1.Height div 2,B);
    Sleep(200);
    Application.ProcessMessages;
    f:=f+10;
  until Stop;

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Stop:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  NewFigure:=figure;
end;

procedure TForm1.ScrollBar8Change(Sender: TObject);
begin
  Paint_Perspect(ScrollBar8.Position,ScrollBar9.Position,ScrollBar10.Position);
end;

procedure TForm1.ScrollBar9Change(Sender: TObject);
begin
  Paint_Perspect(ScrollBar8.Position,ScrollBar9.Position,ScrollBar10.Position);
end;

procedure TForm1.ScrollBar10Change(Sender: TObject);
begin
    Paint_Perspect(ScrollBar8.Position,ScrollBar9.Position,ScrollBar10.Position);
end;

end.
