using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Ряды
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private double Af(int k)
        {
            double T = 4.0;
            double a = 0.0, aTrapezoid, bTrapezoid;
            double w = 2.0*3.14152 / T;
            for (double i = 0.0; i < T; i += 0.1){
                if (k == 0)
                {
                    aTrapezoid = 2 / T * i;
                    bTrapezoid = 2 / T * i;
                }
                else
                {
                    aTrapezoid = 2 / T * (i * Math.Cos(Convert.ToDouble(k) * w * i));
                    bTrapezoid = 2 / T * ((i + 0.1) * Math.Cos(Convert.ToDouble(k) * w * (i + 0.1)));
                }
                a += (aTrapezoid + bTrapezoid) / 2.0 * 0.1;
            }
            
            
            return a;
        }

        private double Bf(int k)
        {
            double T = 4.0;
            double b = 0.0, aTrapezoid, bTrapezoid;
            double w = 2.0 * 3.14152 / T;
            for (double i = 0.0; i < T; i += 0.1)
            {
                aTrapezoid = 2 / T * (i * Math.Sin(Convert.ToDouble(k) * w * i));
                bTrapezoid = 2 / T * ((i + 0.1) * Math.Sin(Convert.ToDouble(k) * w * (i + 0.1)));
                b += (aTrapezoid + bTrapezoid) / 2.0 * 0.1;
            }
            return b;
        }
        private double As(int k)
        {
            double T = 4.0;
            double a = 0.0, aTrapezoid, bTrapezoid;
            double w = 2.0 * 3.14152 / T;
            for (double i = 0.0; i < T; i += 0.1)
            {
                if (k == 0)
                {
                    aTrapezoid = 2 / T * i;
                    bTrapezoid = 2 / T * i;
                }
                else
                {
                    aTrapezoid = 2 / T * (-i * Math.Cos(Convert.ToDouble(k) * w * i));
                    bTrapezoid = 2 / T * (-(i + 0.1) * Math.Cos(Convert.ToDouble(k) * w * (i + 0.1)));
                }
                a += (aTrapezoid + bTrapezoid) / 2.0 * 0.1;
            }
            return a;
        }

        private double Bs(int k)
        {
            double T = 4.0;
            double b = 0.0, aTrapezoid, bTrapezoid;
            double w = 2.0 * 3.14152 / T;
            for (double i = 0.0; i < T; i += 0.1)
            {
                aTrapezoid = 2 / T * ( - i * Math.Sin(Convert.ToDouble(k) * w * i));
                bTrapezoid = 2 / T * ( - (i + 0.1) * Math.Sin(Convert.ToDouble(k) * w * (i + 0.1)));
                b += (aTrapezoid + bTrapezoid) / 2.0 * 0.1;
            }
            return b;
        }
        private void button_Click(object sender, EventArgs e)
        {
            double T = 4.0;
            int period = 0;
            double maxX = 12.0, maxY = 3.0;
            Bitmap image = new Bitmap(canvas.Width, canvas.Height);
            Graphics draw = Graphics.FromImage(image);
            Point zero = new Point(30, canvas.Height / 2);
            draw.FillRectangle(Brushes.White, 0, 0, canvas.Width, canvas.Height);
            draw.DrawLine(Pens.Black, zero.X, 0, zero.X, canvas.Height);
            draw.DrawLine(Pens.Black, 0, zero.Y, canvas.Width, zero.Y);
            canvas.Image = image;
            Application.DoEvents();
            double pixelValueX = maxX / (canvas.Width - zero.X);
            double pixelValueY = maxY / (canvas.Height - zero.Y);
            debugTextBox.Text = Convert.ToString(pixelValueX);

            Point lineFirst = new Point();
            Point lineSecond = new Point();
            double y;
            lineFirst.X = zero.X;
            lineFirst.Y = zero.Y;

            for (int i = 1; i < canvas.Width - zero.X; i++)
            {
                period = Convert.ToInt32(Math.Truncate(i * pixelValueX / 4.0));
                
                lineSecond.X = i + zero.X;
                if ((i * pixelValueX) - T*period < 2.0)
                    y = i * pixelValueX - T * period;
                else
                    y = T * (period+1) - i * pixelValueX;
                lineSecond.Y = zero.Y - Convert.ToInt32(Math.Round(y / pixelValueY));
                draw.DrawLine(Pens.Blue, lineFirst, lineSecond);
                lineFirst.X = lineSecond.X;
                lineFirst.Y = lineSecond.Y;
            }
            canvas.Image = image;
            Application.DoEvents();
            lineFirst.X = zero.X;
            lineFirst.Y = zero.Y;
            double w = 2 * 3.14152 / T;
            for (int i = 1; i < canvas.Width - zero.X; i++)
            {
                period = Convert.ToInt32(Math.Truncate(i * pixelValueX / 4.0)); 
                lineSecond.X = i + zero.X; // Определение координаты x для следующей точки
                if ((i * pixelValueX) - T * period < 2.0)
                {
                    y = 1 / 2 * Af(0);
                    for (int j = 1; j <= 11; j++)
                        y += Af(j) * Math.Cos(j * w * i * pixelValueX) + Bf(j) * Math.Sin(j * w * i * pixelValueX);
                }
                else
                {
                    y = 1 / 2 * Af(0);
                    for (int j = 1; j <= 11; j++)
                        y += As(j) * Math.Cos(j * w * i * pixelValueX) + Bs(j) * Math.Sin(j * w * i * pixelValueX);
                }
                lineSecond.Y = zero.Y - Convert.ToInt32(Math.Round((y + 2) / pixelValueY));
                draw.DrawLine(Pens.Red, lineFirst, lineSecond);
                lineFirst.X = lineSecond.X;
                lineFirst.Y = lineSecond.Y;
            }
            canvas.Image = image;
            Application.DoEvents();
           
        }
    }
}
