# DSD-487 - Digital System Design Final Project
## Image Processing in VHDL
### Michael Banks (12/20/2023)

## Table of Contents:
- Project Goal
- Constraints/ Challenges
- Adjusted Goal/ Objectives
- Important Concepts
- Equipment
- Foundation
- Source Files
- Instructions
- Fix (move lower?)
- Implementation/ Modifications
- Timeline

(##Project-Goal:)
## Project Goal:
The goal of this project was to implement an image loader onto an FPGA with VHDL. This would consist of converting an image into binary data, then reading it into the memory and showing the output via VGA connection to a monitor. We also aimed to create functions to modify the image using transformations such as brightness, thresholding, and more. The modifications would happen once a button is pressed or when using an external controller.

The objectives of this are the following:
[] Implement an image reading function
[] Convert image data to video output
[] Implement color image VGA support
[] Implement image processing functions
[] Create working demos
[] Future Directions/ Conclusion

(##Constraints/Challenges)
## Constraints/ Challenges
- **Image Reading:** Although VHDL cannot read image files directly, we can convert images into binary using MatLab. From here, we can load the binary information into VHDL. We may also need a text reader library.
  - Loading a file into VHDL also requires exclusively binary data. We will need to do more research to learn this.
- **Memory Size:** Some challenges we may face may be related to memory size, as we would need to use a smaller image. As color photos may include significantly more information than black and white, it may be best to focus on black and white for this project.

(##Adjusted-Goal/Objectives)
## Adjusted Goal/ Objectives
With the current constraints in mind, we decided to modify our goals to match our timeframe:
[] Read "simulated" binary image
[] Implement 8-bit colors
[] Implement 8x8 resolution image
[] Implement image processing functions

## Important Concepts

### 3-bit vs 8-bit color
- In Lab 3, we used 3-bit color to output a bouncing ball. This means that each pixel is respresented by 3-bits and red, green, and blue are represented by 1-bit '0' or '1' (eg. red "100", green "010", blue "001").
  ![Sample 3-bit image](/images/RGB_3bits_palette_sample_image.png)
  ![3-bit_palette_color_test_chart](/images/RGB_3bits_palette_color_test_chart.png)
- However, this gives limited usage of colors, as there are only 8 possible color combinations. Because of this, we decided to use 8-bit color, which gives us 2<sup>8</sup>, which is 256 different color combinations.
- With 8-bit color, we have 8-bits per pixel. Red is represented by the first 3-bits, Green is the next 3-bits, and Blue is the last 2-bits.
  ![Sample 8-bit image](/images/MSX2_Screen8_palette_sample_image.png)
  ![8-bit_palette_color_test_chart](/images/MSX2_Screen8_palette_color_test_chart.png)
### Pixel mapping
- For this project, the images are converted to binary data, with each line respresenting a row of pixels. Since we are using 8-bits, this means that a row of *n* pixels will be represented by 'n pixels * 8 bits'.
- For example: If we wanted a row of 3 red, blue, green pixels, respectively. Red would be "1110000", Green "00011100", and Blue "00000011". This would give us the stream "11100000001110000000011" for this (3 pixels * 8 bits) 24-bit line.

### Image transformations
- For this project, we focused on two types of transformations:
  - 1: Position transformations, where the image is shifted along the x or y axis.
  - 2: Brightness/ color transformations, where the 8-bit color value is modified on input. 

## Equipment
- **Nexys A7-100T FPGA Trainer Board**
  - The Digilent Nexys A7-100T board has a female VGA connector that can be connected to a VGA monitor via a VGA cable
  - 2019-11-15 pull request by Peter Ho with the 800x600@60Hz support for 100MHz clock
- **Controller:** 5kΩ potentiometer with a 12-bit analog-to-digital converter (ADC) called Pmod AD1
  - connected to the top pins of the Pmod port JA (See Section 10 of the Reference Manual(INSERTLINKS))*********

## Foundation
- **Lab 3**
  - We used files from lab 3 to implement VGA video output, 100MHz clock, and 3-bit colors.
  - Files used were: *ball.vhd*, *clk_wiz_0.vhd*, *clk_wiz_0_clk_wiz.vhd*, *vga_sync.vhd*, *vga_sync.xdc*, and *vga_top.vhd*.
    - **ball.vhd:** the base file we used for image loading
    - **clk_wiz_0.vhd** and **clk_wiz_0_clk_wiz.vhd:** used to implement the 100MHz clock for VGA support.
    - **vga_sync.vhd:** used to combine 
    - **vga_top.vhd:** used as the top level file.
- **Lab 6** (controller, DAC)
  - We used files for lab 6 to implement controller support for image transformations.
  - Files used were:*adc_if.vhd*

## Source/Constraint Files
- [adc_if.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/adc_if.vhd)
- [ball.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/ball.vhd)
- [clk_wiz_0.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/clk_wiz_0.vhd)
- [clk_wiz_0_clk_wiz.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/clk_wiz_0_clk_wiz.vhd)
- [vga_sync.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/vga_sync.vhd)
- [vga_top.vhd](https://github.com/mbanks01/DSD-image-project/blob/main/vga_top.vhd)
- [vga_top.xdc](https://github.com/mbanks01/DSD-image-project/blob/main/vga_top.xdc)

## Instructions
### 1. Create a new RTL project 8bitimage in Vivado Quick Start
- Create six new source files of file type VHDL called *adc_if*, *ball*, *clk_wiz_0*, *clk_wiz_0_clk_wiz*, *vga_sync*, and *vga_top*.
- Create a new constraint file of file type XDC called *vga_top*.
- Choose Nexys A7-100T board for the project
- Click 'Finish'
- Click design sources and copy the VHDL code from *adc_if.vhd*, *ball.vhd*, *clk_wiz_0.vhd*, *clk_wiz_0_clk_wiz.vhd*, *vga_sync.vhd*, and *vga_top.vhd*.
- Click constraints and copy the code from vga_top.xdc
### 2. Run synthesis
### 3. Run implementation and open implemented design
### 4. Generate bitstream, open hardware manager, and program device
- Click 'Generate Bitstream'
- Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'
- Click 'Program Device' then xc7a100t_0 to download hexcalc.bit to the Nexys A7-100T board
### 5. Use controller and buttons
- Press the center button to open Demo 1 (Gradient display), adjust the controller to modify the color hues.
- Press the top/bottom buttons to open Demo 2 (image), adjust the controller to transform the image along the x and y axis.

## Fix (move lower?)
- Vertical vs horizontal transformation (NEEDS WORK)**********************
- why different?

## Implementation/ Modifications
### A) 3-bit -> 8-bit colors
- For this project, in order to change our values from 3-bit color to 8-bit, we needed to modify the values of signals.
- In the constraint file, the VGA connection was registered:
```
set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { vga_red[0] }]; #IO_L8N_T1_AD14N_35 Sch=vga_r[0]
set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { vga_red[1] }]; #IO_L7N_T1_AD6N_35 Sch=vga_r[1]
set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { vga_red[2] }]; #IO_L1N_T0_AD4N_35 Sch=vga_r[2]

set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { vga_green[0] }]; #IO_L1P_T0_AD4P_35 Sch=vga_g[0]
set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { vga_green[1] }]; #IO_L3N_T0_DQS_AD5N_35 Sch=vga_g[1]
set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { vga_green[2] }]; #IO_L2N_T0_AD12N_35 Sch=vga_g[2]

set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { vga_blue[0] }]; #IO_L2P_T0_AD12P_35 Sch=vga_b[0]
set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { vga_blue[1] }]; #IO_L4N_T0_35 Sch=vga_b[1]

set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { vga_hsync }]; #IO_L4P_T0_15 Sch=vga_hs
set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33 } [get_ports { vga_vsync }]; #IO_L3N_T0_DQS_AD1N_15 Sch=vga_vs
```
This initialized the red (3-bit), green (3-bit), and blue (2-bit) values, as well as the horizontal and vertical sync (h_sync and v_sync).


### B) Pixel mappping from stream of  bits
### C) Buttons for image processing
### D) Controller integration for imag processing

## Demos
- **1: Gradient:**
  - This demo plots the red value against the blue values to create a gradient of all possible color combinations.
  - There are 8 possible color values for red, and 4 possible for blue. This creates an 8x4 pixel gradient which is output to the monitor.
  - **MODIFICATION:** We used the potentiometer to modify the gradient by adding a green value based on the controller input.
- **2: Image:**
  - This demo uses the "simulated" bitstream to load an image onto the monitor.
  - **MODIFICATION:** We used two buttons to modify the input, adding transformations along the X-axis and Y-axis.
    - When the top button is pressed (pin M18), it triggers flag `st_transform_x`, which sets the transform to add to the 
    - When the bottom button is pressed (pin P18), it triggers flag `st_transform_y`, which sets the transform to add to the
        ```
        IF (st_transform_x = '1') OR (st_transform_y = '1') THEN
        	transform <= CONV_INTEGER(bat_x) / 80; -- 640 / 80 = 8 sections
        	   IF (st_transform_x = '1') THEN
        	       ball_x_calc <= (CONV_INTEGER(pixel_col) / 100) + transform; -- divides into 8 parts for red/green (Y COORD)
        	       ball_y_calc <= (CONV_INTEGER(pixel_row) / 75); -- 600 pixels / 75 = divides into 8 parts for blue (X COORD)
        	   ELSIF (st_transform_y = '1') THEN
        	   	   ball_x_calc <= (CONV_INTEGER(pixel_col) / 100); -- divides into 8 parts for red/green (Y COORD)
        	       ball_y_calc <= (CONV_INTEGER(pixel_row) / 75) + transform; -- 600 pixels / 75 = divides into 8 parts for blue (X COORD)
        	   END IF;
        	END IF;
        ```

## Future Directions/ Conclusion
Given more time, these are the future directions we would have taken:
- Integrated file processing, text file reader to save to block RAM
- Integrate block RAM reader for image
- 8-bit color -> 16-bit color
- 8x8 resolution -> 64x64 or more
- Transforms are stackable, combinations
- Hue modification, brightness control, etc.

Overall, this project used our knowledge of FPGAs and VHDL to implement an image output with transformations on input.

## Timeline (12/16/2023 - 12/20/2023)
(12/16/2023) - Development of RGB compatibility

(12/16/2023) - Created functionality to display multiple colors at once.
             - Converted 3-bit RGB to 8-bit RGB
             - Created pixel mapping function
             - Began DEMO 1 (Gradient)
             
(12/17/2023) - Created controller functionality
             - Finalized demos 1 and 2
             
(12/18/2023) - Began writing report outline

(12/19/2023) - Continued writing report, created visuals/graphics

(12/20/2023) - Finished report


A description of the expected behavior of the project, attachments needed (speaker module, VGA connector, etc.), related images/diagrams, etc.



A summary of the steps to get the project to work in Vivado and on the Nexys board
Images and/or videos of the project in action interspersed throughout to provide context
“Modifications”


Conclude with a summary of the process itself – who was responsible for what components (preferably also shown by each person contributing to the github repository!), the timeline of work completed, any difficulties encountered and how they were solved, etc.
