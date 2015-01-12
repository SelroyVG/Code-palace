using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Gershgorin
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            canvas.BackColor = Color.White;
            Bitmap image = new Bitmap(canvas.Width, canvas.Height);
            Graphics draw = Graphics.FromImage(image); // Инициализация инструментов рисования
            double minY = -20.0, minX = -10.0, maxX = 30.0, maxY = 20.0;
            Point workSpace = new Point();
            workSpace.X = canvas.Width - 45;
            workSpace.Y = canvas.Height - 45;

            Point pointZero = new Point();
            pointZero.X = Convert.ToInt32(workSpace.X * Math.Abs(minX) / (maxX - minX));
            pointZero.Y = canvas.Height - Convert.ToInt32(workSpace.Y * Math.Abs(minY) / (maxY - minY));

            double xInOnePixel = (maxX - minX) / workSpace.X,
                   yInOnePixel = (maxY - minY) / workSpace.Y;
            draw.DrawLine(Pens.Blue, pointZero.X, 0, pointZero.X, canvas.Height);
            draw.DrawLine(Pens.Blue, 0, pointZero.Y, canvas.Width, pointZero.Y);
            canvas.Image = image;
            Application.DoEvents();

            int pointsCount = 3;
            double[,] matrix = new double[pointsCount, pointsCount];
            double[,] gauss = new double[pointsCount, pointsCount];
            double[,] sobstvMatrix = new double[pointsCount, pointsCount];
            double[] sobstvVector = new double[pointsCount];
            double[] d = new double[pointsCount];
            double[] p = new double[pointsCount];
            matrix[0, 0] = 2.0; matrix[0, 1] = 5.0; matrix[0, 2] = 6.0;
            matrix[1, 0] = 5.0; matrix[1, 1] = 4.0; matrix[1, 2] = 2.0;
            matrix[2, 0] = 6.0; matrix[2, 1] = 2.0; matrix[2, 2] = 7.0;
            double minXforSobstv = -9.0, maxXforSobstv = 15.0; // Левая и правая граница кругов
            gauss = matrix;
            double maxEllipse = matrix[0, 0];
            for (int i = 1; i < 3; i++)
            {
                if (matrix[i, i] > maxEllipse)
                    maxEllipse = matrix[i, i];
            }
            double h = pointZero.X / maxEllipse;
            for (int i = 0; i < 3; i++)
                {
                    double r = 0, x = matrix[i, i];
                    for (int j = 0; j < 3; j++)
                    {
                        if (i != j)
                            r += matrix[i, j];
                    }
                    r = r * 2;
                    int pixelsForX = pointZero.X + Convert.ToInt32(workSpace.X * Math.Abs(x) / (maxX - minX));
                    int intRadius = Convert.ToInt32(r / xInOnePixel);
                    draw.DrawEllipse(Pens.Black, pixelsForX - intRadius / 2, pointZero.Y - intRadius / 2, intRadius, intRadius);
                }
            canvas.Image = image;
                for (int i = 0; i < pointsCount; i++)
                    d[i] = (matrix[0, 0] - matrix[i, i]) * (matrix[1, 1] - matrix[i, i]) * (matrix[2, 2] - matrix[i, i]) + matrix[0, 1] * matrix[1, 2] * matrix[2, 0] + matrix[0, 2] * matrix[1, 0] * matrix[2, 1] - matrix[0, 2] * (matrix[1, 1] - matrix[i, i]) * matrix[2, 0] - (matrix[0, 0] - matrix[i, i]) * matrix[1, 2] * matrix[2, 1] - matrix[0, 1] * matrix[1, 0] * (matrix[2, 2] - matrix[i, i]);
                for (int k = 0; k < 3; k++) // Метод Гаусса
                    for (int j = k + 1; j < 3; j++)
                    {
                        double r = gauss[j, k] / gauss[k, k];
                        for (int i = k; i < 3; i++)
                            gauss[j, i] = gauss[j, i] - r * gauss[k, i];
                        d[j] = d[j] - r * d[k];
                    }
                for (int k = 2; k >= 0; k--)
                {
                    double r = 0;
                    for (int j = k + 1; j < 3; j++)
                        r += gauss[k, j] *p[j];
                    p[k] = (d[k] - r) / gauss[k, k];
                } // Метод Гаусса is over. Массив p - результат
                for (double x = minXforSobstv; x < maxXforSobstv; x +=0.001)
                {
                    double F = x * x * x + p[0] * x * x + p[1] * x + p[2];
                    x += 0.001;
                    double newF = x * x * x + p[0] * x * x + p[1] * x + p[2];
                    x -= 0.001;
                    if ((F * newF) < 0)
                    {
                        x += 0.0005;
                        double xu = x - ((x * x * x + p[0] * x * x + p[1] * x + p[2]) / (3.0* x * x + p[0] * 2.0 * x + p[1]));

                        sobstvMatrix = matrix;
                        for (int i = 0; i < 3; i++)
                        {
                            sobstvMatrix[i, i] -= p[i];
                        }

                            /*Метод Гаусса*/
                            for (int k = 0; k < 3; k++)
                                for (int j = k + 1; j < 3; j++)
                                {
                                    double r = sobstvMatrix[j, k] / sobstvMatrix[k, k];
                                    for (int i = k; i < 3; i++)
                                        sobstvMatrix[j, i] = sobstvMatrix[j, i] - r * sobstvMatrix[k, i];
                                    d[j] = d[j] - r * d[k];
                                }
                        for (int k = 2; k >= 0; k--)
                        {
                            double r = 0;
                            for (int j = k + 1; j < 3; j++)
                                r += sobstvMatrix[k, j] * sobstvVector[j];
                            sobstvVector[k] = (d[k] - r) / sobstvMatrix[k, k];
                        } // Метод Гаусса is over. Массив p - результат


                        richTextBox.Text += "Корень:" + Environment.NewLine + Convert.ToString(x) + Environment.NewLine;
                        richTextBox.Text += "Уточн. корень:" + Environment.NewLine + Convert.ToString(xu) + Environment.NewLine;
                        richTextBox.Text += "Собственный вектор:" + Environment.NewLine + "B[0] = " + Convert.ToString(sobstvVector[0]) + Environment.NewLine + "B[1] = " + Convert.ToString(sobstvVector[1]) + Environment.NewLine + "B[2] = " + Convert.ToString(sobstvVector[2]) + Environment.NewLine;
                        x -= 0.0005;
                    }
                }
                Application.DoEvents();
        }

    }
}
