unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    procedure Image1Click(Sender: TObject);
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
var point_number: integer; coord1, coord2: TPoint;


procedure TForm1.Button1Click(Sender: TObject);   // Построение сетки
var i, j, x, y: integer;
begin
Image1.Canvas.Pen.Color := clGray;
     i := 0;
     while (i <= 800) do
     begin
       Image1.Canvas.MoveTo (i, 0);
       Image1.Canvas.LineTo (i, 600);
       i := i + 15;
     end;
          i := 0;
     while (i <= 600) do
     begin
       Image1.Canvas.MoveTo (0, i);
       Image1.Canvas.LineTo (810, i);
       i := i + 15;
     end;
     point_number := 0;             // Количество считанных точек
end;


procedure TForm1.Button2Click(Sender: TObject);
var i, x, y: integer;
begin
    Image1.Canvas.Brush.Color := clWhite;
    Image1.Canvas.Rectangle (0, 0, 810, 600);
    Image1.Canvas.Brush.Color := clBlue;

     i := 0;
     while (i <= 810) do
     begin
       Image1.Canvas.MoveTo (i, 0);
       Image1.Canvas.LineTo (i, 600);
       i := i + 15;
     end;
          i := 0;
     while (i <= 600) do
     begin
       Image1.Canvas.MoveTo (0, i);
       Image1.Canvas.LineTo (810, i);
       i := i + 15;
     end;
     point_number := 0;             // Количество считанных точек

end;

procedure TForm1.Image1Click(Sender: TObject);

var squares_x, squares_y, x1, x2, y1, y2, x, y, check_otr_y, check_otr_x, t, fin: integer; // Точки относительно начала линии
var err, prir_err: real;

begin
Image1.Canvas.Brush.Color := clBlue;
      if point_number = 0 then
      begin
      GetCursorPos(coord1);  // Координаты курсора относительно экрана
      coord1 := ScreenToClient(coord1);  // Координаты курсора относительно клиента
      point_number := 1;
      Image1.Canvas.Rectangle ((coord1.x div 15)*15, (coord1.y div 15)*15, (coord1.x div 15)*15 + 15, (coord1.y div 15)*15 +15);
      end
      else if point_number = 1 then
begin

      GetCursorPos(coord2);  // Координаты курсора относительно экрана
      coord2 := ScreenToClient(coord2);  // Координаты курсора относительно клиента
      x1 := coord1.x div 15; x2 := coord2.x div 15;         y1 := coord1.y div 15; y2 := coord2.y div 15;
      squares_x := abs(x2 - x1);  squares_y := abs(y2 - y1);   // Кол-во клеток, которые необходимо пройти по x и y
    point_number := 2;
     Image1.Canvas.Rectangle ((coord2.x div 15)*15, (coord2.y div 15)*15, (coord2.x div 15)*15 + 15, (coord2.y div 15)*15 +15);       // Рисование конечной точки
      err := 0;

if squares_y < squares_x then
begin
      prir_err := squares_y/squares_x;
      if y1 > y2 then check_otr_y := -1  else check_otr_y := 1;
      if x1 < x2 then check_otr_x := 1   else check_otr_x := -1;
         y := y1; x := x1;  fin := x2;

    while x <> fin do
      begin
           Image1.Canvas.Rectangle (x*15, y*15, x*15+15, y*15+15);
           err := err + prir_err;
           if err >= 0.5 then
           begin
             y := y + check_otr_y;
             err := err - 1.0;
           end;

           x := x + check_otr_x;
      end;
end  else
begin
        prir_err := squares_x/squares_y;

        if y1 > y2 then check_otr_y := -1  else check_otr_y := 1;
        if x1 < x2 then check_otr_x := 1   else check_otr_x := -1;
         x := x1; y := y1;  fin := y2;

        while y <> fin do
      begin
           Image1.Canvas.Rectangle (x*15, y*15, x*15+15, y*15+15);
           err := err + prir_err;
           if err >= 0.5 then
           begin
             x := x + check_otr_x;
             err := err - 1.0;
           end;
           y := y + check_otr_y;
      end;
end;
    point_number := 0;
end; end; end.

