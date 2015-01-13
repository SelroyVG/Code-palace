using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Optimization
{
    class Program
    {
        static void Main(string[] args)
        {
            double x1 = 1.0, x2 = 1.0, y, d = 0.5;
            y = Function(x1, x2);
            for (int i = 0; i < 50; i++)
            {
                int j = 0;
                double dx1 = x1 + RandAlpha() * d;
                double dx2 = x2 + RandAlpha() * d;
                while ((y < Function(dx1, dx2)) && (j < 10000))
                {
                    dx1 = x1 + RandAlpha() * d;
                    dx2 = x2 + RandAlpha() * d;
                    double f = Function(dx1, dx2);
                    j++;
                }
                if (y > Function(dx1, dx2))
                {
                    y = Function(dx1, dx2);
                    x1 = dx1;
                    x2 = dx2;
                }
            }
            Console.WriteLine("y = {0}  x1 = {1}  x2 = {2}", y, x1, x2);
        }
        static double Function (double x1, double x2)
        {
            return x1 - x2 + 2 * x1 * x2 + 2 * x1 * x1 + x2 * x2;
        }
        static double RandAlpha ()
        {
            Random random = new Random();
            return (random.NextDouble() - 0.5) * 2;
        }
    }
}
