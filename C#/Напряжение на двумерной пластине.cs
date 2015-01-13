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
            double[,] U = new double[pointsCount, pointsCount];
            double[,] futureU = new double[pointsCount, pointsCount];

            for (int i = 0; i < pointsCount; i++)
            {
                U[i, 0] = 1000.0;
                U[0, i] = 500.0;
                U[i, pointsCount - 1] = 0.0;
                U[pointsCount - 1, i] = 0.0;
                futureU[i, 0] = 1000.0;
                futureU[0, i] = 500.0;
                futureU[i, pointsCount - 1] = 0.0;
                futureU[pointsCount - 1, i] = 0.0;
                if (i < Convert.ToInt32(pointsCount / 2))
                {
                    futureU[Convert.ToInt32(pointsCount / 2), i] = 1000.0;
                    U[Convert.ToInt32(pointsCount / 2), i] = 1000.0;
                }
                    
            }

            int pixelsForPoint = Convert.ToInt32(canvas.Width / pointsCount);
            Bitmap image = new Bitmap(canvas.Width, canvas.Height);
            Graphics draw = Graphics.FromImage(image); // Инициализация инструментов рисования



            for (int i = 0; i < pointsCount; i++)
                for (int j = 0; j < pointsCount; j++)
                {
                    int color = Convert.ToInt32(Math.Round(255.0 * (U[i, j] / 1000.0)));
                    Color deviationColor = Color.FromArgb(color, color, color);
                    SolidBrush deviationBrush = new SolidBrush(deviationColor);
                    draw.FillRectangle(deviationBrush, pixelsForPoint * i, pixelsForPoint * j, pixelsForPoint, pixelsForPoint);

                }
            canvas.Image = image; // Запись bitmap-картинки в PictureBox под названием canvas
            Application.DoEvents();
            double eps = 0.001;
            int maxTime = 1500;
            for (int time = 0; time <= maxTime; time++)
            {
                timeTextBox.Text = Convert.ToString(time);
                
                for (int i = 1; i < pointsCount-1; i++)
                    for (int j = 1; j < pointsCount-1; j++)
                    {
                        if ((i == Convert.ToInt32(pointsCount / 2)) && (j < Convert.ToInt32(pointsCount / 2)))
                          U[i, j] = 1000.0;
                        else
                            futureU[i, j] = 0.25 * (U[i - 1, j] + U[i + 1, j] + U[i, j - 1] + U[i, j + 1]);
                       
                    }
                for (int i = 0; i < pointsCount; i++)
                    for (int j = 0; j < pointsCount; j++)
                    {
                        if (time % 3 == 0)
                        {
                            int color = Convert.ToInt32(Math.Round(255.0 * (U[i, j] / 1000.0)));
                            Color deviationColor = Color.FromArgb(color, color, color);
                            SolidBrush deviationBrush = new SolidBrush(deviationColor);
                            draw.FillRectangle(deviationBrush, pixelsForPoint * i, pixelsForPoint * j, pixelsForPoint, pixelsForPoint);
                        }
                        U[i, j] = futureU[i, j];
                    }
                if (time % 3 == 0)
                {
                    canvas.Image = image;
                    Application.DoEvents();
                }
            }
        }
    }
}
