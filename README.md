# DSD-487 - Digital System Design Final Project
## Image Processing in VHDL
### Written by Michael Banks (12/16/2023 - 12/20/2023)

![project-image](/images/project_img1.png)

## Table of Contents:
- Project Goal
- Constraints/ Challenges
- Adjusted Goal/ Objectives
- Important Concepts
- Equipment
- Foundation
- Source Files
- Instructions
- Implementation/ Modifications
- Conclusion
- Timeline

## Project Goal:
The goal of this project was to implement an image loader onto an FPGA with VHDL. This would consist of converting an image into binary data, then reading it into the memory and showing the output via VGA connection to a monitor. We also aimed to create functions to modify the image using transformations such as brightness, thresholding, and more. The modifications would happen once a button is pressed or when using an external controller.

The objectives of this are the following:
- [ ] Implement an image reading function
- [ ] Convert image data to video output
- [ ] Implement color image VGA support
- [ ] Implement image processing functions
- [ ] Create working demos

## Constraints/ Challenges
- **Image Reading:** Although VHDL cannot read image files directly, we can convert images into binary using MatLab. From here, we can load the binary information into VHDL. We may also need a text reader library.
  - Loading a file into VHDL also requires exclusively binary data. We will need to do more research to learn this.
- **Memory Size:** Some challenges we may face may be related to memory size, as we would need to use a smaller image. As color photos may include significantly more information than black and white, it may be best to focus on black and white for this project.
- We would also need to save the file data to the block RAM, however we chose to “simulate” this due to complexity issues.

## Specific Objectives
With the current constraints in mind, we decided to modify our goals to match our timeframe:
- [ ] Read "simulated" binary image
- [ ] Implement 8-bit colors
- [ ] Implement 8x8 resolution image
- [ ] Implement image processing functions

## Important Concepts

### [3-bit vs 8-bit color](https://en.wikipedia.org/wiki/List_of_8-bit_computer_hardware_graphics)
- In Lab 3, we used 3-bit color to output a bouncing ball. This means that each pixel is respresented by 3-bits and red, green, and blue are represented by 1-bit '0' or '1' (eg. red "100", green "010", blue "001").
  
  ![Sample 3-bit image](/images/RGB_3bits_palette_sample_image.png)
  ![3-bit_palette_color_test_chart](/images/RGB_3bits_palette_color_test_chart.png)
  
  <sup>3-bit image, and color palette</sup>

  ![3-bit-code](/images/3-bit-rgb-code.png)
  
- However, this gives limited usage of colors, as there are only 8 possible color combinations. Because of this, we decided to use 8-bit color, which gives us 2<sup>8</sup>, which is 256 different color combinations.
- With 8-bit color, we have 8-bits per pixel. Red is represented by the first 3-bits, Green is the next 3-bits, and Blue is the last 2-bits
  
  ![Sample 8-bit image](/images/MSX2_Screen8_palette_sample_image.png)
  ![8-bit_palette_color_test_chart](/images/MSX2_Screen8_palette_color_test_chart.png)
  
  <sup>8-bit image, and color palette</sup>

  ![8-bit-code](/images/8-bit-rgb-code.png)
  
### Pixel mapping
- For this project, the images are converted to binary data, with each line respresenting a row of pixels. Since we are using 8-bits, this means that a row of *n* pixels will be represented by 'n pixels * 8 bits'.
- For example: If we wanted a row of 3 red, blue, green pixels, respectively. Red would be "1110000", Green "00011100", and Blue "00000011". This would give us the stream "11100000001110000000011" for this (3 pixels * 8 bits) 24-bit line.

![pixel-mapping-example](/images/pixel-mapping-ex.png)

### Image transformations
- For this project, we focused on two types of transformations:
  - 1: Position transformations, where the image is shifted along the x or y axis.
  - 2: Brightness/ color transformations, where the 8-bit color value is modified on input. 

## Equipment
- **Nexys A7-100T FPGA Trainer Board**
  - The [Digilent Nexys A7-100T](https://github.com/byett/dsd/tree/CPE487-Fall2023/Nexys-A7) board has a female [VGA connector](https://en.wikipedia.org/wiki/VGA_connector) that can be connected to a VGA monitor via a VGA cable
  - 2019-11-15 pull request by Peter Ho with the 800x600@60Hz support for 100MHz clock

![equipment-fpga-layout](/images/fpga_layout-optimized.png)

- **Controller:** 5kΩ [potentiometer](https://en.wikipedia.org/wiki/Potentiometer) with a 12-bit [analog-to-digital](https://en.wikipedia.org/wiki/Analog-to-digital_converter) converter (ADC) called [Pmod AD1](https://digilent.com/shop/pmod-ad1-two-12-bit-a-d-inputs/)
  - connected to the top pins of the Pmod port JA (See Section 10 of the [Reference Manual](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf))
  
![potentiometer](/images/potentiometer.png)


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

![overall-diagram](/images/overall-diagram.png)

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
This initialized the red (3-bit), green (3-bit), and blue (2-bit) values, as well as the horizontal and vertical sync (`h_sync` and `v_sync`).

Within *vga_top.vhd*:
  - Architecture:
    - Signals `S_red` and `S_green` were turned to 3-bit signals
    - Signal `S_blue` was turned to a 2-bit signal
  - Component ball:
    - Signals `red` and `green` -> 3-bit
    - Signal `blue` -> 2-bit
  - Component vga_sync
    - Signal `red_out`, `green_out`, `red_in`, `green_in` -> 3-bit
    - Signal `blue_out`, `blue_in` -> 2-bit
  - `red`, `green`, `blue` signals ported to *ball.vhd*

Within *vga_sync*:
  - Signal `video_on` was turned to 3-bit
  - Another signal `video_on_blue` was created for 2-bit (blue channel)
    - `video_on` sets a flag to disable video during blanking and sync periods

Within *ball.vhd*:
  - `c_red`, `c_green`, and `c_blue` act as temporary values for RGB in a process.
  - Temporary values are then sent to `red`, `green`, and `blue` and output to the monitor based on `pixel_col` and `pixel_row` positions.

### B) Pixel mappping from stream of  bits
Within *ball.vhd*:
  - The 800x600 screen is divided into 8x8 components:
```
	       ball_x_calc <= (CONV_INTEGER(pixel_col) / 100);      -- 800 pixels / 100 = 8 segments
	       ball_y_calc <= (CONV_INTEGER(pixel_row) / 75);       -- 600 pixels / 75 = 8 segments
```
`ball_x_calc` and `ball_y_calc` act as the X and Y position, which will be used to map the color values to pixels.

The image is read as a bit sequence, with 8 signals, acting as "line breaks" for each horizontal pixel layer:
```
	rgbimg0 <= "0001101100011011000110110001101100011011000110110001101100011011";
	rgbimg1 <= "0001101100011011111110111111101111111011111110110001101100011011";
	rgbimg2 <= "0001101111111011111110111111101111111011111110111111101100011011";
	rgbimg3 <= "0001101111110010111110110000000011111011000000001111101111110010";
	rgbimg4 <= "1111001011111011111110110100111111111011010011111111101111110010";
	rgbimg5 <= "1111001011110010111010101111101111111011111110111110101000011011";
	rgbimg6 <= "0001101111000101111100101111001011111011111110111100010100011011";
	rgbimg7 <= "0001101111000101111001011110010100011011110001011110010100011011";
```
Each layer is a 64-bit sequence which determines the value of 8 pixels, resulting in an 8x8 image.

We also take the desired 8-bit segment from the 64-bit sequence, which is found by using:
	`inc_val1 <= (ball_x_calc+1)*8 - 1;`
This takes the X-coordinate (1 to 8) and multiplies it by 8 to get the desired code.
- For example: if we wanted the 1st code, it would result in (1*8-1 = 7), which gives us (7 DOWNTO 0).
- If we want the second code, it gives us (15 DOWNTO 8), third is (23 DOWNTO 16), and so on.
- This was done so that if we wanted to add more pixels (64x64), we wouldn't need to change this part of the code, as it is adaptable.
```
if (ball_y_calc >= 0) AND (ball_y_calc < 1) THEN
	rgbcode <= rgbimg0(inc_val1 DOWNTO inc_val1 - 7);
	
	ELSIF (ball_y_calc >= 1) AND (ball_y_calc < 2) THEN
	rgbcode <= rgbimg1(inc_val1 DOWNTO inc_val1 - 7);
	ELSIF (ball_y_calc >= 2) AND (ball_y_calc < 3) THEN
	rgbcode <= rgbimg2(inc_val1 DOWNTO inc_val1 - 7);
	ELSIF (ball_y_calc >= 3) AND (ball_y_calc < 4) THEN
	rgbcode <= rgbimg3(inc_val1 DOWNTO inc_val1 - 7);
	ELSIF (ball_y_calc >= 4) AND (ball_y_calc < 5) THEN
	rgbcode <= rgbimg4(inc_val1 DOWNTO inc_val1 - 7);
	ELSIF (ball_y_calc >= 5) AND (ball_y_calc < 6) THEN
	rgbcode <= rgbimg5(inc_val1 DOWNTO inc_val1 - 7);
	ELSIF (ball_y_calc >= 6) AND (ball_y_calc < 7) THEN
	rgbcode <= rgbimg6(inc_val1 DOWNTO inc_val1 - 7);
	ELSIF (ball_y_calc >= 7) AND (ball_y_calc < 8) THEN
	rgbcode <= rgbimg7(inc_val1 DOWNTO inc_val1 - 7);
	ELSE
	
	rgbcode <= "11111111";
	END IF;
```
The resulting 8-bit segment is saved to `rgbcode`, which is the resulting color code used in the designated pixel.
The `rgbcode` is then separated into red, green, and blue:
```
	--** assign RGBCODE 8-bit colors (3 red, 3 green, 2 blue) **
	c_red <= rgbcode(7 DOWNTO 5) + conv_std_logic_vector(level_r,3);
	c_green <= rgbcode(4 DOWNTO 2) + conv_std_logic_vector(level_g,3);
	c_blue <= rgbcode(1 DOWNTO 0) + conv_std_logic_vector(level_b,2);
```
After the process, the temporary RGB signals are then sent to *vga_top.vhd* for video output.
```
	END PROCESS;
		red <= c_red;
		green <= c_green;
		blue <= c_blue;
```

### C) Buttons for image processing

Inputs `btn0`, `bt_x`, and `bt_y` were added from pins N17,M18, and bt_y, respectively.
Inputs `bt_level` and `bt_other` were added for additional functionality, but weren't used in the final product.
```
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { btn0 }]; #IO_L9P_T1_DQS_14 Sch=btnc
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { bt_x }];
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { bt_level }];
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { bt_y }];
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { bt_other }];
```
Within *ball.vhd*:
These buttons determined states that affected with function, or demo would play:
```
    button : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF swap = '1' THEN -- test for new serve
            st_pressed <= '0';
            st_transform_x <= '0';
	        st_transform_y <= '0';
	        st_level <= '0';
	        st_other  <= '0';
        ELSIF transform_x = '1' THEN 
            st_pressed <= '1';
            st_transform_x <= '1';
	        st_transform_y <= '0';
	        st_level <= '0';
	        st_other  <= '0';
        ELSIF transform_y = '1' THEN 
            st_pressed <= '1';
            st_transform_x <= '0';
	        st_transform_y <= '1';
	        st_level <= '0';
	        st_other  <= '0';
        ELSIF level_mod = '1' THEN 
            st_pressed <= '1';
            st_transform_x <= '0';
	        st_transform_y <= '0';
	        st_level <= '1';
	        st_other  <= '0';
        ELSIF other_mod = '1' THEN 
            st_pressed <= '1';
            st_transform_x <= '0';
	        st_transform_y <= '0';
	        st_level <= '0';
	        st_other  <= '1';
        END IF;
```


### D) Controller integration for image processing
Inputs `ADC_SDATA1`, `ADC_SDATA2`, `ADC_SCLK`, and `ADC_CS` were added for potentiometer controller input:
```
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { ADC_SDATA1 }]; #IO_L21N_T3_DQS_A18_15 Sch=ja[2]
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { ADC_SDATA2 }]; #IO_L21P_T3_DQS_15 Sch=ja[3]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { ADC_SCLK }]; #IO_L18N_T2_A23_15 Sch=ja[4]
set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports { ADC_CS }]; #IO_L20N_T3_A19_15 Sch=ja[1]
```
Within *ball.vhd*:
- Similarly to `pixel_col` and `pixel_row`, the controller input (`bat_x`) was divided to create a 1 to 8 value.
- 
 	`ball_z_calc <= CONV_INTEGER(bat_x) / 80;          -- 640 / 80 = 8 sections`
  
- With the first demo (Gradient), the controller was used to determine the value of green on the screen:
- 
   	`c_green <= conv_std_logic_vector(ball_z_calc,3);`
  
- With the second demo (Image), the controller was used to shift the X and Y placement of the image:
- 
     	`transform <= CONV_INTEGER(bat_x) / 80; -- 640 / 80 = 8 sections`
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

## Demos
- **1: Gradient:**
  - This demo plots the red value against the blue values to create a gradient of all possible color combinations.
  - There are 8 possible color values for red, and 4 possible for blue. This creates an 8x4 pixel gradient which is output to the monitor.

  ![Demo1-img](/images/demo1_rxb-optimized.png)

  - **MODIFICATION:** We used the potentiometer to modify the gradient by adding a green value based on the controller input.
 
  ![Demo1-img](/images/demo1_rxbxg-optimized.png)
  ![demo-1-gif](/images/demo-1.gif)

  
- **2: Image:**
  - This demo uses the "simulated" bitstream to load an image onto the monitor.

  - In order to convert from the usual 24-bit colors (255,255,255) to 8-bit colors (7,7,3), we had to scale the range down:
  - This could be done by taking the Red and Green values and multiplying them by 7/255 and rounding to the nearest integer:

![demo-1-rgb-mapping](/images/img_color_vals.png)

![demo-1-pixel-mapping](/images/rgbcodemapping.png)

  - **MODIFICATION:** We used two buttons to modify the input, adding transformations along the X-axis and Y-axis.
    - When the top button is pressed (pin M18), it triggers flag `st_transform_x`, which sets the transform to add to the x-coordinate, offsetting from the origin.
   
![demo-2-x-transform](/images/demo2_x_shift.png)
![demo-2-x-gif](/images/demo-2-x.gif)

  - When the bottom button is pressed (pin P18), it triggers flag `st_transform_y`, which sets the transform to add to the, offsetting from the origin.

![demo-2-y-transform](/images/demo2_y_shift.png)
![demo-2-y-gif](/images/demo-2-y.gif)

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

Looking back on our adjusted goals, we were able to accomplish the following:
- [X] Read "simulated" binary image
- [X] Implement 8-bit colors
- [X] Implement 8x8 resolution image
- [X] Implement image processing functions

Overall, this project used our knowledge of FPGAs and VHDL to implement an image output with transformations on input. We were able to successfully implement are goals, and have documentation for future implementations.

## Timeline (12/16/2023 - 12/20/2023)
(12/16/2023) - Development of RGB compatibility
![RGB-step-1](/images/prog_1.JPG)

(12/16/2023) - Created functionality to display multiple colors at once.
![RGB-step-2](/images/prog_2.JPG)
![RGB-step-3](/images/prog_3.JPEG)
(12/16/2023) - Converted 3-bit RGB to 8-bit RGB
![RGB-step-4](/images/prog_4.JPEG)
(12/16/2023) - Began DEMO 1 (Gradient)
![RGB-step-5](/images/prog_5.JPEG)
(12/17/2023) - Created pixel mapping function
![RGB-step-8](/images/prog_8.JPEG)
(12/17/2023) - Created controller functionality
![RGB-step-6](/images/prog_6.JPEG)
(12/17/2023) - Finalized demos 1 and 2
![RGB-step-7](/images/prog_7.JPEG)
![RGB-step-9](/images/prog_9.JPG)   
(12/18/2023) - Began writing report outline
(12/19/2023) - Continued writing report, created visuals/graphics
(12/20/2023) - Finished report
