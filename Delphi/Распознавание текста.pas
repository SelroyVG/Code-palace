//
// Ещё куча кошмарного кода второй курсовой с интересным, но не эффективным алгоритмом
//

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.ExtDlgs;

type
  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    Memo1: TMemo; results: TMemo;
    CheckBox1: TCheckBox;
    N3: TMenuItem;
    SaveDialog1: TSaveDialog;
    function scan_color (c, j, i: integer): boolean;
    procedure scan_pic;
    procedure char (begin_ch, begin_str_ch: integer);
    procedure scan_char (begin_str, end_str: integer);
    procedure N2Click(Sender: TObject);
    procedure search (line1, line2, line3, line4, line5, line6: integer; point1, point2, point3, point4, line12, line13, line14, line15: boolean; line16, line17, line18, line19, line20,  begin_ch, begin_str_ch: integer);
    procedure N3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  Character = class // Размеры буквы
  Private
   x_charP, y_charP: integer;
   Public
   property x_char:integer read x_charP write x_charP;
   property y_char:integer read y_charP write y_charP;
   constructor Create;
end;

var
  Form1: TForm1;
  pic: array of array of integer;   // Двумерный массив, содержащий цвет пикселя
    char_mas: array[0..40] of array[0..50] of integer; // массив, содержащий цвет каждого пикселя буквы
    string_count, old_begin_str_ch, space: integer;
    prew, prew2: boolean;
    cchar: Character;
    Bitmap: TBitmap;

implementation
   Constructor Character.Create;
   begin
  x_charP := 0;
  y_charP := 0;
   end;
{$R *.dfm}

procedure TForm1.scan_char (begin_str, end_str: integer);
var i, j, count, begin_ch, end_ch, begin_str_ch, end_str_ch, i2, j2: integer; check, check2: boolean;
begin

    j := 0; count := 0;
    while j < Bitmap.width-1 do
    Begin
        check := false;
        for i := begin_str to end_str do
          check := check or scan_color (40, j, i);

        if check = true then
            begin
              begin_ch := j;
               while check = true do
               begin
                       j := j + 1;
                       check := false;
                       for i:= begin_str to end_str do
                            check := check or scan_color (40, j, i);
               end; end_ch := j - 1;    count := count + 1;
               {Уменьшение границ буквы до чёрных контуров}
               begin_str_ch := begin_str;
               end_str_ch := end_str;
               check2 := false;
               while check2 = false do
               Begin
                 for j2 := begin_ch to end_ch do
                    check2 := check2 or scan_color (40, j2, begin_str_ch);
                    if check2 = false then
                       begin_str_ch := begin_str_ch + 1;
               End;
                 check2 := false;   end_str_ch := end_str;
               while check2 = false do
                    Begin
                           for j2 := begin_ch to end_ch do
                               check2 := check2 or scan_color (40, j2, end_str_ch);
                     if check2 = false then
                          end_str_ch := end_str_ch - 1;
                                    End;
                 {......}
                if begin_str_ch = end_str_ch then
                      begin_str_ch := begin_str_ch - 1;

               for i2 := begin_str_ch to end_str_ch do
                     for j2 := begin_ch to end_ch do
                     Begin
                            if  scan_color (40, j2, i2) = true then    // "Очернение" буквы
                              Begin

                              Form1.Image1.canvas.Pixels[j2 - begin_ch,i2 - begin_str_ch] := clBlack; // Вывод на форму
                              char_mas[j2 - begin_ch,i2 - begin_str_ch] := clBlack;
                              End else Begin
                               Form1.Image1.canvas.Pixels[j2 - begin_ch,i2 - begin_str_ch] := clWhite;
                               char_mas[j2 - begin_ch,i2 - begin_str_ch] := clWhite;
                              End;
                     End;
                     cchar.x_char := end_ch - begin_ch; cchar.y_char := end_str_ch - begin_str_ch;
                      char (begin_ch, begin_str_ch);
                        Form1.Image1.Canvas.Brush.Color := clBlack;
                       Form1.Image1.canvas.rectangle (0, 0, Image1.width, Image1.height);
            end else j := j + 1;

    End;

end;

procedure TForm1.scan_pic;
var i, j, i2, j2, begin_str, end_str: integer; check : bool;
Begin
  i := 0; check := false;
  while i < Bitmap.height do
  Begin
    for j:=0 to Bitmap.width-1 do
        check := check or scan_color (150, j, i);  // выделение строки

       if check = true then
       begin
            begin_str := i;
            while check = true do
            begin
                   i := i + 1;
                   check := false;

                   for j:=0 to Bitmap.width - 1 do
                       check := check or scan_color (150, j, i);
            end;
            end_str := i-1;
            Form1.Image1.Canvas.Brush.Color := clBlack;
            Form1.Image1.canvas.rectangle (0, 0, Image1.width, Image1.height);

            space := 0;
            scan_char(begin_str, end_str);

            if (Form1.results.Lines[string_count] = '?') or (Form1.results.Lines[string_count] = '??') or (Form1.results.Lines[string_count] = '???') or (Form1.results.Lines[string_count] = ' ?') or (Form1.results.Lines[string_count] = ' ? ?') then
               Form1.results.Lines[string_count] := '' else Begin  String_count := string_count + 1; Form1.results.Lines.Add(''); End;
             check := false;

       end;
       i := i+1;
  End;

End;

procedure TForm1.char (begin_ch, begin_str_ch: integer); //(xb, yb, xe, ye: integer);        // анализ буквы
var  i, j, count, count2, count3, count4, line1, line2, line3, line4, line5, line6, line16, line17, line18, line19, line20:integer; check, check_bnv :boolean; countfloat: real;
 point1, point2, point3, point4, line10, line11, line12, line13, line14, line15, prew: boolean;

begin
line1 := 0; // Левая верт. черта
line2 := 0; // Правая верт. черта
line3 := 0; // Верхняя горизонтальная черта
line4 := 0; // Нижняя горизонтальная черта
line5 := 0; // Средняя верт. черта
//line1 := false; // Левая верт. черта

point1 := false; // Левая верхняя точка
point2 := false; // Правая верхняя точка
point3 := false; // Левая нижняя точка
point4 := false; // Правая нижняя точка

line10 := false;// Слеш
line11 := false;// Средняя горизонтальная черта
line12 := false;// Средняя верхняя точка
line13 := false;// Средняя левая точка
line14 := false;// Средняя правая точка
line15 := false;// Средняя нижняя точка
line16 := 0;// Количество изменений цвета
line17 := 0;// Количество изменений цвета
line18 := 0;// Количество изменений цвета
line19 := 0;// Количество изменений цвета
line20 := 0;// Количество изменений цвета
Form1.Memo1.Clear;

     {Левая верт. черта}
  count := 0; prew := false;
  i := round(cchar.x_char/12);
   for j := 0 to cchar.y_char do
           if (char_mas[i, j] = clBlack) and (prew = false) then
             Begin count := count + 1;
                   prew := true;
             End else if (char_mas[i, j] = clWhite) and (prew = true) then prew := false;

      line1 := count;
      Form1.Memo1.Lines.Add ('Переходов: ' + inttostr(line1));
   {...}

     {Правая верт. черта}
     count := 0; prew := false;
     i := cchar.x_char - round(cchar.x_char/12);
   for j := 0 to cchar.y_char do
           if (char_mas[i, j] = clBlack) and (prew = false) then
             Begin count := count + 1;
                   prew := true;
             End else if (char_mas[i, j] = clWhite) and (prew = true) then prew := false;

      line2 := count;
      Form1.Memo1.Lines.Add ('Переходов: ' + inttostr(line2));
     {...}

      {Верхняя горизонтальная черта}
          count := 0; prew := false;
       j := cchar.y_char div 20;
   for i := 0 to cchar.x_char do
           if (char_mas[i, j] = clBlack) and (prew = false) then
             Begin count := count + 1;
                   prew := true;
             End else if (char_mas[i, j] = clWhite) and (prew = true) then prew := false;

      line3 := count;
      Form1.Memo1.Lines.Add ('Переходов: ' + inttostr(line3));
      {...}

        {Нижняя горизонтальная черта}

             count := 0; prew := false;
       j := cchar.y_char - (cchar.y_char div 20);
   for i := 0 to cchar.x_char do
           if (char_mas[i, j] = clBlack) and (prew = false) then
             Begin count := count + 1;
                   prew := true;
             End else if (char_mas[i, j] = clWhite) and (prew = true) then prew := false;

      line4 := count;
      Form1.Memo1.Lines.Add ('Переходов: ' + inttostr(line4));
     {...}

        {Средняя верт. черта}
  count := 0; count2 := 0; count3 := 0;   prew := false;
  i := round(cchar.x_char/2);
   for j := 0 to cchar.y_char do
           if (char_mas[i, j] = clBlack) and (prew = false) then
               Begin count := count + 1;
                   prew := true;
             End else if (char_mas[i, j] = clWhite) and (prew = true) then prew := false;
      line5 := count;
      Form1.Memo1.Lines.Add ('Переходов: ' + inttostr(line5));
   {...}
           {Средняя горизонтальная черта}
  count := 0;  prew := false;
  j := round(cchar.y_char/2);
   for i := 0 to cchar.x_char do
           if (char_mas[i, j] = clBlack) and (prew = false) then
               Begin count := count + 1;
                   prew := true;
             End else if (char_mas[i, j] = clWhite) and (prew = true) then prew := false;



      line6 := count;
      Form1.Memo1.Lines.Add ('Переходов: ' + inttostr(line6));
   {...}

      //
        {Левая верхняя точка}
           check := false;
        for i := 0 to round(cchar.x_char/8) do
         for j := 0 to round(cchar.y_char/8) do
          if char_mas[i,j] = clBlack then check := true;
          point1 := check;
       {...}

       {Правая верхняя точка}
       check := false;
       for i := cchar.x_char downto round(cchar.x_char*7/8) do
         for j := 0 to round(cchar.y_char/8) do
          if char_mas[i,j] = clBlack then check := true;
          point2 := check;
      {...}
           {Левая нижняя точка}
       check := false;
        for i := 0 to round(cchar.x_char/8) do
         for j := cchar.y_char downto round(cchar.y_char*7/8) do
          if char_mas[i,j] = clBlack then check := true;
          point3 := check;
      {...}
           {Правая нижняя точка}
       check := false;
       for i := cchar.x_char downto round(cchar.x_char*7/8) do
         for j := cchar.y_char downto round(cchar.y_char*7/8) do
          if char_mas[i,j] = clBlack then check := true;
          point4 := check;
      {...}

     {Средняя верхняя точка}
      if char_mas[round(cchar.x_char/2),0] = clBlack then
      Begin
         line12 := true;
         Form1.Memo1.Lines.Add ('Средняя верхняя точка');
       End;
     {...}
     {Средняя левая точка}
      if (char_mas[0,round(cchar.y_char/2)] = clBlack) or (char_mas[0,round(cchar.y_char/2) + 1] = clBlack) or (char_mas[0,round(cchar.y_char/2) - 1] = clBlack) then
      Begin
         line13 := true;
         Form1.Memo1.Lines.Add ('Средняя левая точка');
       End;
     {...}
     {Средняя правая точка}
      if (char_mas[cchar.x_char,round(cchar.x_char/2)] = clBlack) or (char_mas[cchar.x_char,round(cchar.x_char/2) + 1] = clBlack) or (char_mas[cchar.x_char,round(cchar.x_char/2) - 1] = clBlack) then
      Begin
         line14 := true;
         Form1.Memo1.Lines.Add ('Средняя правая точка');
       End;
     {...}
     {Средняя нижняя точка}
      if char_mas[round(cchar.x_char/2),cchar.y_char] = clBlack then
      Begin
         line15 := true;
         Form1.Memo1.Lines.Add ('Средняя нижняя точка');
       End;
     {...}


      {Line-16}
  j := 0; i := 0;
   for i := 1 to cchar.x_char do
   Begin
           if ((char_mas[i, j] = clBlack) and (char_mas[i-1, j] = clWhite)) or ((char_mas[i, j] = clWhite) and (char_mas[i-1, j] = clBlack)) then
              line16 := line16 + 1;
   End;
         Form1.Memo1.Lines.Add ('Верхн. гор. линия: ' + inttostr(line16));
        {...}
        {Line-17}
  j := round(cchar.y_char/3); i := 0;
   for i := 1 to cchar.x_char do
   Begin
           if ((char_mas[i, j] = clBlack) and (char_mas[i-1, j] = clWhite)) or ((char_mas[i, j] = clWhite) and (char_mas[i-1, j] = clBlack)) then
              line17 := line17 + 1;
   End;
         Form1.Memo1.Lines.Add ('Средняя гор. линия: ' + inttostr(line17));
        {...}

        {Line-19}
  j := cchar.y_char; i := 0;
   for i := 1 to cchar.x_char do
   Begin
           if ((char_mas[i, j] = clBlack) and (char_mas[i-1, j] = clWhite)) or ((char_mas[i, j] = clWhite) and (char_mas[i-1, j] = clBlack)) then
              line19 := line19 + 1;
   End;
    Form1.Memo1.Lines.Add ('Нижняя гор. линия: ' + inttostr(line19));

        {...}
        {Line-20}
  j := 0; i := round(cchar.x_char/2);
   for j := 1 to cchar.y_char do
   Begin
           if ((char_mas[i, j] = clBlack) and (char_mas[i, j-1] = clWhite)) or ((char_mas[i, j] = clWhite) and (char_mas[i, j-1] = clBlack)) then
              line20 := line20 + 1;
   End;
        Form1.Memo1.Lines.Add ('Средняя верт. линия: ' + inttostr(line20));
        {...}

      search (line1, line2, line3, line4, line5, line6, point1, point2, point3, point4, line12, line13, line14, line15, line16, line17, line18, line19, line20, begin_ch, begin_str_ch);

       if Form1.CheckBox1.Checked = true then
          showmessage('Продолжить');


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Form1.Memo1.Lines.Clear;
Form1.results.Lines.Clear;
end;

procedure TForm1.N2Click(Sender: TObject);  // Загрузка картинки, Начало работы программы
var s: string;
begin
 Form1.results.Clear; String_count := 0; prew := false; prew2 := false;  old_begin_str_ch := -1;  cchar := Character.Create;
 Form1.N3.Enabled := true;
   if Form1.CheckBox1.Checked = true then
          Form1.Memo1.Visible := true else Form1.Memo1.Visible := false;
   if Form1.CheckBox1.Checked = true then
          Form1.Image1.Visible := true else Form1.Image1.Visible := false;

 if OpenPictureDialog1.Execute then
 begin
     s:= OpenPictureDialog1.FileName;
 end;
     Bitmap:=TBitmap.Create;
Bitmap.LoadFromFile(s);
SetLength(pic, Bitmap.width, Bitmap.height);
 scan_pic;
end;

procedure TForm1.N3Click(Sender: TObject);
var s: string;
begin
      if SaveDialog1.Execute then
           s:= SaveDialog1.FileName;
      Results.lines.SaveToFile(s);
end;

function TForm1.scan_color (c, j, i: integer): boolean;           // Тёмный пиксель -- true
var r, g, b: integer;
begin
           R := GetRValue(Bitmap.canvas.Pixels[j,i]);
           G := GetGValue(Bitmap.canvas.Pixels[j,i]);
           B := GetBValue(Bitmap.canvas.Pixels[j,i]);
           if (R < c) or (G < c) or (B < c) then
               result := true else result := false;
end;

procedure TForm1.search (line1, line2, line3, line4, line5, line6:integer; point1, point2, point3, point4, line12, line13, line14, line15: boolean; line16, line17, line18, line19, line20, begin_ch, begin_str_ch:integer);
    var S :string; check, check2:boolean; i,j:integer;
    Begin
    check2 := false;
    S := S + inttostr(line1);
    S := S + inttostr(line2);
    S := S + inttostr(line3);
    S := S + inttostr(line4);
    S := S + inttostr(line5);
    S := S + inttostr(line6);
    S := S + '|';
    if point1 then S := S + '1' else S := S + '0';
    if point2 then S := S + '1' else S := S + '0';
    if point3 then S := S + '1' else S := S + '0';
    if point4 then S := S + '1' else S := S + '0';
    S := S + '|';
   if old_begin_str_ch <> -1 then  //Пробел
     if space = 0 then
     Begin
        if ((begin_ch - old_begin_str_ch) > 0.7*cchar.x_char) and (cchar.x_char/cchar.y_char < 1) or ((begin_ch - old_begin_str_ch) > 0.4*cchar.x_char) and (cchar.x_char/cchar.y_char >= 1) then
        Begin
        Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + ' ';
        space := begin_ch - old_begin_str_ch;
        End;

     End else
     if (((begin_ch - old_begin_str_ch) > space) and (space <> 0)) then
        Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + ' ';
        if space <= 0.3*cchar.x_char then
          space := 0;



    Form1.Memo1.Lines.Add (S);
    check := false;

    if (S = '111222|0011|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'А'; check:=true; End;
    if (S = '111131|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Б'; check:=true; End;
    if (S = '121131|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'В'; check:=true; End;
    if (S = '111111|1110|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Г'; check:=true; End;
    if (S = '111222|0111|') or (S = '111222|0011|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Д'; check:=true; End;
    if (S = '131131|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Е'; check:=true; End;
    if (S = '223311|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ж'; check:=true; End;
    if (S = '221131|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'З'; check:=true; End;
    if (S = '112213|1111|') then
    Begin
        i := begin_ch + round(cchar.x_char/2);
        for j := begin_str_ch downto begin_str_ch - round(cchar.y_char/3) do
           check2 := check2 or scan_color (50, i, j);
       if check2 = true then Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Й'
       else Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'И';
       check:=true;
    End;
    if (S = '122221|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'К'; check:=true; End;
    if (S = '111212|0111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Л'; check:=true; End;
    if (S = '112314|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'М'; check:=true; End;
    if (S = '112211|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Н'; check:=true; End;
    if (S = '111122|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'О'; check:=true; End;
    if (S = '111212|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'П'; check:=true; End;
    if (S = '111121|1110|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Р'; check:=true; End;
    if (S = '121121|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'C'; check:=true; End;
    if (S = '111111|1100|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Т'; check:=true; End;
    if (S = '112112|1110|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'У'; check:=true; End;
    if (S = '111113|0000|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ф'; check:=true; End;
    if (S = '222211|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Х'; check:=true; End;
    if (S = '112112|1101|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ц'; check:=true; End;
    if (S = '112112|1101|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ч'; check:=true; End;
    if (S = '113113|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ш'; check:=true; End;
    if (S = '113113|1101|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Щ'; check:=true; End;
    if (S = '111121|1011|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ь'; check:=true; prew := true; End;

    if ((cchar.y_char/cchar.x_char > 4) or (S = '111111|1111|')) and (prew = true) and (check = false) then
      Begin
          S := Form1.results.Lines[String_count];
         if S[length(s)] = ' ' then
            Delete(S,Length(S)-1,2) else  Delete(S,Length(S),1);
          Form1.results.Lines[String_count] := S;
          Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ы'; check:=true;  prew := false;
      End else if  (prew = true) and (check = false) then  prew := false; // Удаление предыдущего символа "Ь" если распознана буква "Ы"

    if (S = '111121|1001|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ъ'; check:=true; End;
    if (S = '211131|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Э'; check:=true; End;
    if (S = '112222|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Ю'; check:=true; End;
    if (S = '211221|1111|') then
    Begin Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + 'Я'; check:=true; End;

    if Form1.results.Lines[String_count] <> '' then
          old_begin_str_ch := begin_ch + cchar.x_char;
    if check = false then
       Form1.results.Lines[String_count] := Form1.results.Lines[String_count] + '?';
    End;
end.

