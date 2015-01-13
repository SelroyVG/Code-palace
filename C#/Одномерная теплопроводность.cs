using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Drawing;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
namespace Теплопроводность
{
    public partial class Form1 : Form
    {
        public Form1()
        {                                                             
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            canvas.BackColor = Color.White;
        }
                
        private void button1_Click(object sender, EventArgs e)
        {
            /*Информация о стенке*/
            double l = 1.0; // Толщина стенки в метрах
            int pointsCount = 41;
            double h = l / (pointsCount - 1);
            double tau = 0.0003;
            double R = tau / h * h;
            double minY = 0.0, minX = 0.0, maxX = 1.0, maxY = 100.0;
            double[] U, L, M;
            U = new double[pointsCount];
            L = new double[pointsCount];
            M = new double[pointsCount];
            /*...*/

            Point workSpace = new Point();
            workSpace.X = canvas.Width - 45;
            workSpace.Y = canvas.Height - 45;

            Point pointZero = new Point();
            pointZero.X = 30;
            pointZero.Y = canvas.Height - 30;

            double xInOnePixel = (maxX - minX) / workSpace.X,
                   yInOnePixel = (maxY - minY) / workSpace.Y;
            float decimalForY = workSpace.Y / 10;
            int pixelsForPoint = Convert.ToInt32(Math.Round(Convert.ToDouble(workSpace.X) / pointsCount));
            Font font = new Font("Arial", 9);
            Bitmap image = new Bitmap(canvas.Width, canvas.Height);
            Graphics draw = Graphics.FromImage(image); // Инициализация инструментов рисования

            //          EmptyGraphic();
            Application.DoEvents();

            U[0] = U[pointsCount - 1] = 0;
            for (int i = 1; i < pointsCount - 1; i++)
            {
                U[i] = 100 * Math.Sin((i / Convert.ToDouble(pointsCount - 1)) * 3.14159265);
                int pixelsForCurrentY = Convert.ToInt32(Math.Round(U[i] / yInOnePixel));
                Point rectangle = new Point();
                rectangle.X = pointZero.X + pixelsForPoint * i;
                rectangle.Y = pointZero.Y - pixelsForCurrentY;
                int gradient = (int)(U[i] * 2.55);
                Color temperatureColor = Color.FromArgb(gradient, 0, 255 - gradient);
                SolidBrush temperatureBrush = new SolidBrush(temperatureColor);
                draw.FillRectangle(temperatureBrush, rectangle.X, rectangle.Y, pixelsForPoint, pixelsForCurrentY);
                if (i == 1)
                {
                    L[i] = 0;
                    M[i] = 0;
                }
                L[i + 1] = R / (1 + 2 * R - R * L[i]);
                M[i + 1] = (U[i] + R * M[i]) / (1 + 2 * R - R * L[i]);
            }

            canvas.Image = image; // Запись bitmap-картинки в PictureBox под названием canvas
            Application.DoEvents();

            for (int time = 0; time <= 4800; )
            {
                draw.FillRectangle(Brushes.White, 0, 0, canvas.Width, canvas.Height);
                draw.DrawLine(Pens.Black, 30, 0, 30, canvas.Height);
                draw.DrawLine(Pens.Black, 0, canvas.Height - 30, canvas.Width, canvas.Height - 30);
                for (int c = 0; c <= 10; c++)
                {
                    draw.DrawString(Convert.ToString(maxY - c * 10), font, Brushes.Black, 0, Convert.ToInt32(20 + decimalForY * c));
                    draw.DrawLine(Pens.Black, 0, pointZero.Y - decimalForY * c, canvas.Width, pointZero.Y - decimalForY * c);
                }

                textBoxTime.Text = Convert.ToString(time++);
                
                for (int i = 0; i < pointsCount; i++)
                {// Шаг по неявной схеме
                    if ((i != 0) && (i != pointsCount - 1))
                    {
                        M[i + 1] = (U[i] + R * M[i]) / (1 + 2 * R - R * L[i]);
                        U[i - 1] = L[i] * U[i] + M[i];
                    }

                    int pixelsForCurrentY = Convert.ToInt32(Math.Round(U[i] / yInOnePixel));
                    Point rectangle = new Point();
                    rectangle.X = pointZero.X + pixelsForPoint * i;
                    rectangle.Y = pointZero.Y - pixelsForCurrentY;
                    int gradient = (int)(U[i] * 2.55);
                    Color temperatureColor = Color.FromArgb(gradient, 0, 255 - gradient);
                    SolidBrush temperatureBrush = new SolidBrush(temperatureColor);
                    draw.FillRectangle(temperatureBrush, rectangle.X, rectangle.Y, pixelsForPoint, pixelsForCurrentY);
                }
                textBoxTime.Text = Convert.ToString(time++);
                canvas.Image = image;
                Application.DoEvents();


                double bufold_u = 0, buf_u;
                
                for (int i = 0; i < pointsCount; i++)
                { // Шаг по явной схеме
                    if ((i != 0) && (i != pointsCount - 1))
                    {
                        buf_u = U[i] + (tau / (h * h)) * (U[i + 1] - 2 * U[i] + bufold_u);
                        bufold_u = U[i];
                        U[i] = buf_u;
                    }
                    int pixelsForCurrentY = Convert.ToInt32(Math.Round(U[i] / yInOnePixel));
                    Point rectangle = new Point();
                    rectangle.X = pointZero.X + pixelsForPoint * i;
                    rectangle.Y = pointZero.Y - pixelsForCurrentY;
                    int gradient = (int)(U[i] * 2.55);
                    Color temperatureColor = Color.FromArgb(gradient, 0, 255 - gradient);
                    SolidBrush temperatureBrush = new SolidBrush(temperatureColor);
                    draw.FillRectangle(temperatureBrush, rectangle.X, rectangle.Y, pixelsForPoint, pixelsForCurrentY);
                }
                Application.DoEvents();
                
            }
        }
    }
}