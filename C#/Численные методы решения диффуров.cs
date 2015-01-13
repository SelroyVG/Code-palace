using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
 

namespace Diffequat
{
    class Program
    {
        static void Main(string[] args)
        {
            double xBegin = 0, xEnd = 0.5;
            double y1 = 1, y2 = 0;
            double tau = 0.005;
            Methods method = new Methods();
            Console.Write("Метод Эйлера:      {0}\n", method.Eiler(y1, y2, xBegin, xEnd, tau));
            Console.Write("RK2:               {0}\n", method.RK2(y1, y2, xBegin, xEnd, tau));
            Console.Write("RK4:               {0}\n", method.RK4(y1, y2, xBegin, xEnd, tau));
            Console.Write("Прогноз-коррекция: {0}\n", method.PredictionCorrection(y1, y2, xBegin, xEnd, tau));
            Console.Write("Истинное значение: {0}\n", method.True_result(xEnd));
            Console.ReadLine();
        }

        class Methods
        {
            public double Eiler(double y1, double y2, double xBegin, double xEnd, double tau)
            {
                for (double x = xBegin; x <= xEnd; x += tau)
                {
                    double y1New = y1 + tau * y2;
                    y2 += tau * (1 / Math.Cos(x) - y1);
                    y1 = y1New;
                }
                return y1;
            }

            public double PredictionCorrection(double y1, double y2, double xBegin, double xEnd, double tau)
            {
                for (double x = xBegin; x <= xEnd; x += tau)
                {
                    double F1Prediction = y2 + tau * (1 / Math.Cos(x) - y1);
                    double F2Prediction = 1 / Math.Cos(x + tau) - (y1 + tau * y2);
                    double y1New = y1 + tau * (y2 + F1Prediction) / 2;
                    y2 += tau * ((1 / Math.Cos(x) - y1) + F2Prediction) / 2;
                    y1 = y1New;
                }
                return y1;
            }
            
            public double RK2(double y1, double y2, double xBegin, double xEnd, double tau)
            {
             for (double x = xBegin; x <= xEnd; x += tau)
                {
                    double y1HalfStep, y2HalfStep;
                    double y1New;
                    y1New = y1 + tau / 2 * y2;
                    y2HalfStep = y2 + tau / 2 * (1 / Math.Cos(x) - y1);
                    y1HalfStep = y1New;
                    y1New = y1 + tau * y2HalfStep;
                    y2 += tau * (1 / Math.Cos(x) - y1HalfStep);
                    y1 = y1New;
                }
                return y1;
            }

            public double RK4(double y1, double y2, double xBegin, double xEnd, double tau)
            {
                double[,] coef = new double[4, 2];
                for (double x = xBegin; x <= xEnd; x += tau)
                {
                    coef [0, 0] = tau * y2;
                    coef [0, 1] = tau * (1 / Math.Cos(x) - y1);
                    coef [1, 0] = tau * (y2 + coef [0, 1]/2);
                    coef [1, 1] = tau * (1 / Math.Cos(x+(tau/2)) - (y1 + coef [0, 0]/2));
                    coef [2, 0] = tau * (y2 + coef [1, 1]/2);
                    coef [2, 1] = tau * (1 / Math.Cos(x+(tau/2)) - (y1 + coef [1, 0]/2));
                    coef [3, 0] = tau * (y2 + coef [2, 1]);
                    coef [3, 1] = tau * (1 / Math.Cos(x+tau) - (y1 + coef [2, 0]));

                    y1 += (coef [0, 0] + 2* coef [1, 0] + 2 * coef [2, 0] + coef [3, 0])/6.0;
                    y2 += (coef [0, 1] + 2* coef [1, 1] + 2 * coef [2, 1] + coef [3, 1])/6.0;
                    
                }
                return y1;
            }

            public double True_result (double x)
            {
                return (Math.Cos(x) + x * Math.Sin(x) + Math.Cos(x) * Math.Log(Math.Cos(x)));
            }
        }
        

    }
}
