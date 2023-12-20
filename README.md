# DSD-487 - Digital System Design Final Project
## Image Processing in VHDL
### Michael Banks (12/20/2023)

## Table of Contents:
- [Project Goal]()
- [Constraints/ Challenges]()
- [Adjusted Goal/ Objectives]()
- [Important Concepts]()
- [Equipment]()
- [Foundation]()
- [Source Files]()
- [Instructions]()
- [Fix (move lower?)]()
- [Implementation/ Modifications](###[Implementation/ Modifications)

## Project Goal:
The goal of this project was to implement an image loader onto an FPGA with VHDL. This would consist of converting an image into binary data, then reading it into the memory and showing the output via VGA connection to a monitor. We also aimed to create functions to modify the image using transformations such as brightness, thresholding, and more. The modifications would happen once a button is pressed or when using an external controller.

The objectives of this are the following:
- Implement an image reading function
- Convert image data to video output
- Implement color image VGA support
- Implement image processing functions
- Create working demos
- Future Directions/ Conclusion

## Constraints/ Challenges
- Image Reading: Although VHDL cannot read image files directly, we can convert images into binary using MatLab. From here, we can load the binary information into VHDL. We may also need a text reader library.
- Loading a file into VHDL also requires exclusively binary data. We will need to do more research to learn this.
- Memory Size: Some challenges we may face may be related to memory size, as we would need to use a smaller image. As color photos may include significantly more information than black and white, it may be best to focus on black and white for this project.

## Adjusted Goal/ Objectives
With the current constraints in mind, we decided to modify our goals to match our timeframe:
- Read "simulated" binary image
- Implement 8-bit colors
- Implement 8x8 resolution image
- Implement image processing functions

## Important Concepts
- 8-bit color, RGB values
- Pixel mapping
- Image transformations

## Equipment
- Nexsys A7
- Potentiometer

## Foundation
- Lab 3 (vga, clock, 3-bit colors)
- Lab 6 (controller, DAC)

## Source Files
- [adc_if.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/adc_if.vhd)
- [ball.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/ball.vhd)
- [clk_wiz_0.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/clk_wiz_0.vhd)
- [clk_wiz_0_clk_wiz.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/clk_wiz_0_clk_wiz.vhd)
- [vga_sync.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/vga_sync.vhd)
- [vga_top.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/vga_top.vhd)
- [vga_top.xdc](https://github.com/mbanks01/DSD-image-project/blob/main/vga_top.xdc)

## Instructions
- how to run program

## Fix (move lower?)
- Vertical vs horizontal transformation
- why different?

## Implementation/ Modifications
- 3-bit -> 8-bit colors
- Pixel mappping from stream of  bits
- Buttons for image processing
- Controller integration for imag processing

## Demos
- 1: Gradient, interact with color modifciation
- 2: Image, interact with transformations

## Future Directions/ Conclusion
- Integrated file processing, text file reader to save to block RAM
- Integrate block RAM reader for image
- 8-bit color -> 16-bit color
- 8x8 resolution -> 64x64 or more
- Transforms are stackable, combinations
- Hue modification, brightness control, etc.







A description of the expected behavior of the project, attachments needed (speaker module, VGA connector, etc.), related images/diagrams, etc.



A summary of the steps to get the project to work in Vivado and on the Nexys board
Images and/or videos of the project in action interspersed throughout to provide context
“Modifications”


Conclude with a summary of the process itself – who was responsible for what components (preferably also shown by each person contributing to the github repository!), the timeline of work completed, any difficulties encountered and how they were solved, etc.
