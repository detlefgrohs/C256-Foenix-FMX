# C256-Foenix-FMX





# FBas (Foenix Basic)
My version of a basic interpreter that will not require line numbers. It will be based off of the code that I started with [CSasic2](https://github.com/detlefgrohs/CSasic2) that I adapted from some other code that I have seen.


# FEd (Foenix Editor)
A simple editor for the C256 slightly based on the Ed editor.

```
FEd - C256 Foenix FMX Editor Help
============================================================================
Ls-e    List lines. If s and e are missing list entire file. If e is missing
        list from s to EOF. If s is missing list to e.
Es      Edit lines. If s is missing edit the 1st line.
Is      Insert lines. If s is missing insert lines at EOL. If s is 0 or 1
        insert lines at BOF.
Ds-e    Delete lines. If s and e are missing delete all lines. If e is missing
        delete lines from s to EOF. If s is missing delete lines to e.

W       Write the file.
E       Write the file and exit.
X       eXit.
```

# Bouncing Ball
I am trying to make a version of the Amiga Bouncing Ball demo for the C256: http://www.randelshofer.ch/animations/anims/robert_j_mical/boing3.ilbm.html

My plan is to generate a huge sprite out of 16 (4 x 4) separate sprites (total 128 x 128 pixels) that will be moved together and palette cycled to get the effect.

This will also lead down into the sound of the C256 which I have not even looked at yet...

Work Plan
- [ ] Draw Background
- [ ] Create Sprites and Movement
- [ ] Movement should be somewhat realistic, arcing and speeding up when approaching the ground.
- [ ] Sound
- [ ] Separate sprites for the background

## Sprite Generator
This is some C# code that I wrote to generate the sprites that will make up the bouncing ball with the cycling palette. I am still working on this to make it look more realistic; I tried to do a projection of a texture to a sphere but that got too complicated so I came up with this that gets close to what I wanted. Will revisit once I get the rest of the demo done.
```csharp
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
                        if (xCounter <= 0.0)
                        {
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
            Console.ReadLine();
        }
```
![Generated Sprite Numbers](https://raw.githubusercontent.com/detlefgrohs/C256-Foenix-FMX/main/Resources/BouncingBallGeneratedSprite.png)

# HeapManager
My version of a heap manager for the the other applications that I am working on. I know I could just include another heap manager from another project that someone else wrote but the best way to understand something to reverse engineer and reimagine it the way you want.



`IncludeUnitTests = true`

## Public Methods
### HeapManager.Init
**Input**|**Description**
-|-
A|Data Page for Heap
X|Start of Heap in Data Page
Y|End of Heap in Data Page

**Output**|**Description**
-|-
*|Initialized HeapManager at A:X


### HeapManager.Allocate

### HeapManager.Free

### HeapManager.Merge


## Private Methods



## Unit Tests

### HeapManager.UnitTests.Init

## Macros


# General Documentation

## Macros

Macro | Parameters | Description
-|-|-
PushAll||
PullAll||
PrintChar|char|
Subtract|value|
SubtractConstant|value|

### Tracing
These macros will only be included when `TraceEnabled = true`. All messages will be be prepended with 3 spaces.
Macro | Parameters | Description
-|-|-
Trace|message|
TraceAX|message|
TraceAXY|message|
TraceMemory|message, address, length|
TraceMemoryLong|message, longAddress, length|

```asm
    Trace "Test Trace Message"
    TraceAXY "Trace Output"
```
Output
>    Test Trace Message
>    Trace Output(A=0F00,X=C000,Y=FFFF)





## C256 Foenix Work
- [ ] Get Floppy Drive Working
- [x] Get Python Upload Script Working
- [x] Versioning System for Assembly Code

    Projects
    - [ ] HeapManager
    - [ ] Fed
    - [ ] FBas

    - [ ] Bouncing Ball
        - [ ] Sprite Generator

- [ ] Join Discord
- [ ] Clean-Up GitHub Repository for this...

