using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Волновое_уравнение
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int pointsCount = 60;
            double lx = 5, ly = 5;
            double[,] U = new double[pointsCount, pointsCount];
            double[,] oldU = new double[pointsCount, pointsCount];
            double[,] futureU = new double[pointsCount, pointsCount];
            double c = 20;
            double tau = 0.00142;
            double h = lx / pointsCount;
            double r = c * tau / h;
            double startingPoint = 0.55;

            int pixelsForPoint = Convert.ToInt32(canvas.Width / pointsCount);
            Bitmap image = new Bitmap(canvas.Width, canvas.Height);
            Graphics draw = Graphics.FromImage(image); // Инициализация инструментов рисования


            oldU[32, 20] = U[32, 20] - tau * startingPoint;


            for (int i = 0; i < pointsCount; i++)
                for (int j = 0; j < pointsCount; j++)
                {
                    int color = Convert.ToInt32(128 + Math.Round(128 * (800 * U[i, j])));
                    Color deviationColor = Color.FromArgb(color, color, color);
                    SolidBrush deviationBrush = new SolidBrush(deviationColor);
                    draw.FillRectangle(deviationBrush, pixelsForPoint * i, pixelsForPoint * j, pixelsForPoint, pixelsForPoint);
                    
                }
            canvas.Image = image; // Запись bitmap-картинки в PictureBox под названием canvas
            Application.DoEvents();

            int maxTime = 1000;
            for (int time = 0; time <= maxTime; time++)
            {
                timeTextBox.Text = Convert.ToString(time);
                for (int i = 1; i < pointsCount-1; i++)
                    for (int j = 1; j < pointsCount-1; j++)
                    {
                        futureU[i, j] = (2 * U[i, j] - oldU[i, j] + r * r * (U[i - 1, j] + U[i, j - 1] - 4 * U[i, j] + U[i + 1, j] + U[i, j + 1]));
                    }
                for (int i = 0; i < pointsCount; i++)
                    for (int j = 0; j < pointsCount; j++)
                    {
                        oldU[i, j] = U[i, j];
                        int color = Convert.ToInt32(128 + Math.Round(128 * (825 * U[i, j])));
                        Color deviationColor = Color.FromArgb(color, color, color);
                        SolidBrush deviationBrush = new SolidBrush(deviationColor);
                        draw.FillRectangle(deviationBrush, pixelsForPoint * i, pixelsForPoint * j, pixelsForPoint, pixelsForPoint);

                        U[i, j] = futureU[i, j];
                    }
                canvas.Image = image; 
                Application.DoEvents();

            }
        }
    }
}
