using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace BouncingBallSpriteGenerator {
    class Program {
        static void Main(string[] args) {
            int spriteSize = 128;
            double halfSpriteSize = spriteSize / 2;
            double gridSizeY = 8.0;
            double gridSizeX = 32.0;
            double yGridSize = ((double)spriteSize) / gridSizeY;
            var paletteValues = new char[] { '0', '1', '2', '3', '4', '5', '6', '7' };

            var sprite = new char[spriteSize, spriteSize];
            var foundStartOfLine = false;
            char value = '0', rowStartingValue = '0';
            var yCounter = yGridSize;
            double xCounter = 0.0;
            double xGridSize = 0.0;
            foreach (var Y in Enumerable.Range(0, spriteSize)) {
                foreach (var X in Enumerable.Range(0, spriteSize)) {
                    double projY = Y - halfSpriteSize;
                    double projX = X - halfSpriteSize;
                    double h = Math.Sqrt(projX * projX + projY * projY);

                    if (Math.Abs(h) < halfSpriteSize) {
                        if (foundStartOfLine == false) {
                            foundStartOfLine = true;
                            value = rowStartingValue;
                            xGridSize = (Math.Abs(projX) * 2.0) / gridSizeX;
                            xCounter = xGridSize;
                        }
                        sprite[Y, X] = value;

                        xCounter -= 1.0;
                        if (xCounter <= 0.0) {
                            value = (char)((int)value + 1);
                            if (value == '8') value = '0';

                            xCounter += xGridSize;
                        }
                    } else
                        sprite[Y, X] = ' ';
                }
                foundStartOfLine = false;
                yCounter -= 1.0;
                if (yCounter <= 0.0) {
                    rowStartingValue = rowStartingValue == '0' ? '4' : '0';
                    yCounter += yGridSize;
                }
            }
            foreach (var Y in Enumerable.Range(0, spriteSize)) {
                foreach (var X in Enumerable.Range(0, spriteSize)) Console.Write($"{sprite[Y, X]} ");
                Console.WriteLine();
            }

            using (var sw = new StreamWriter($@"..\..\..\..\..\Resources\Sprites.asm")) {
                sw.WriteLine($"; Sprites for C256 Bouncing Ball Demo");

                var spriteNumber = 0;
                foreach (var Y in Enumerable.Range(0, 4))
                    foreach (var X in Enumerable.Range(0, 4)) {
                        sw.WriteLine($"BouncingBallSprite{spriteNumber:00}");

                        foreach (var aY in Enumerable.Range(0, 32))
                        {
                            var bytes = new List<string>();
                            foreach (var aX in Enumerable.Range(0, 32))
                            {
                                var oX = (X * 32) + aX;
                                var oY = (Y * 32) + aY;
                                byte b = (byte)sprite[oY,oX];
                                byte bV = 0;
                                if (b != ' ') bV = (byte)((b - '0') + 1);
                                bytes.Add($"${bV:X2}");
                            }
                            sw.WriteLine($".BYTE {string.Join(",", bytes)}");
                        }
                        spriteNumber += 1;
                    }
                sw.WriteLine();
            }
            Console.ReadLine();
        }
    }
}