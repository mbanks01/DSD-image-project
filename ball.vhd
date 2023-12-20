LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		green     : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		blue      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		swap : IN STD_LOGIC;
		transform_x : IN STD_LOGIC;  
        transform_y : IN STD_LOGIC;
        level_mod : IN STD_LOGIC;
        other_mod : IN STD_LOGIC;
		bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0) -- current bat x position
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
	CONSTANT size  : INTEGER := 8;
	SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(200, 11);
	-- current ball motion - initialized to +4 pixels/frame
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
	SIGNAL c_red : STD_LOGIC_VECTOR (2 DOWNTO 0);      -- placeholder values
	SIGNAL c_blue : STD_LOGIC_VECTOR (1 DOWNTO 0);     -- placeholder values
	SIGNAL c_green : STD_LOGIC_VECTOR (2 DOWNTO 0);    -- placeholder values
	-- DEMO 1: color grid (green controller)
	SIGNAL ball_x_calc : INTEGER;
	SIGNAL ball_y_calc : INTEGER;
	SIGNAL ball_z_calc : INTEGER;
	SIGNAL st_pressed : STD_LOGIC := '0';
	SIGNAL st_transform_x : STD_LOGIC := '0';
	SIGNAL st_transform_y : STD_LOGIC := '0';
	SIGNAL st_level : STD_LOGIC := '0';
	SIGNAL st_other : STD_LOGIC := '0';
	-- DEMO 2: color grid (red conntroller)
	SIGNAL origin_x : INTEGER := 200;
	SIGNAL origin_y : INTEGER := 200;
	SIGNAL rgbcode : STD_LOGIC_VECTOr (7 DOWNTO 0);    -- 8 bit color value
	SIGNAL rgbimg0 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg3 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg4 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg5 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg6 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rgbimg7 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL inc_val1 : INTEGER;
	SIGNAL inc_val2 : INTEGER;
	SIGNAL inc_coord : INTEGER;
	SIGNAL transform : INTEGER; --transform image with controller
	SIGNAL level_r : INTEGER;
	SIGNAL level_g : INTEGER;
	SIGNAL level_b : INTEGER;
	
	
	
	
BEGIN
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (c_red,c_green,c_blue, ball_x, ball_y, pixel_row, pixel_col, bat_x, origin_x, origin_y) IS
	   
	BEGIN
	-- DEMO 1 when middle pressed
	IF st_pressed = '0' THEN
	    ball_x_calc <= CONV_INTEGER(pixel_col) / 100; -- divides into 8 parts for red/green (Y COORD)
	    ball_y_calc <= CONV_INTEGER(pixel_row) / 150; -- 600 pixels / 150 = divides into 4 parts for blue (X COORD)
	    ball_z_calc <= CONV_INTEGER(bat_x) / 80;          -- 640 / 80 = 8 sections
	    c_red <= conv_std_logic_vector(ball_x_calc,3); -- red = y/100 = 8 sections
		c_green <= conv_std_logic_vector(ball_z_calc,3);
		c_blue <= conv_std_logic_vector(ball_y_calc,2); -- blue = x/150 = 4 sections
	
	-- DEMO 2 (IMAGE)
	ELSIF st_pressed = '1' THEN
	rgbimg0 <= "0001101100011011000110110001101100011011000110110001101100011011";
	rgbimg1 <= "0001101100011011111110111111101111111011111110110001101100011011";
	rgbimg2 <= "0001101111111011111110111111101111111011111110111111101100011011";
	rgbimg3 <= "0001101111110010111110110000000011111011000000001111101111110010";
	rgbimg4 <= "1111001011111011111110110100111111111011010011111111101111110010";
	rgbimg5 <= "1111001011110010111010101111101111111011111110111110101000011011";
	rgbimg6 <= "0001101111000101111100101111001011111011111110111100010100011011";
	rgbimg7 <= "0001101111000101111001011110010100011011110001011110010100011011";
	--rgbimg0 <= "0001100011111100000111001110000011100000111000001110000011100000";
	--rgbimg1 <= "1111111111111111111111111111111111111111111111111111111111111111";
	--rgbimg2 <= "1111111111111111111111111111111111111111111111111111111111111111";
	--rgbimg3 <= "1111111111111111111111111111111111111111111111111111111111111111";
	--rgbimg4 <= "0000000000000000000000000000000000000000000000000000000000000000";
	--rgbimg5 <= "0011110000000000111000001100000000111000000000000000001110000110";
	--rgbimg6 <= "0000000000000011110000011111000001100000000100000000000000000000";
	--rgbimg7 <= "0000100000000000000000000000100000000011000000000000000000110000";
	
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
	
	
	inc_val1 <= (ball_x_calc+1)*8 - 1;     -- rgbdata(inc_val1 DOWNTO inc_val2)
	-- ex: 1st segment is 7 downto 0, next is 15 downto 8, 
	--inc_val2 <= inc_val1 - 7;
	--inc_coord <= origin_x + ball_x_calc*10;
	
	
	--DOESNT WORK RIGHT NOW (idk why )
	IF (st_level = '1') THEN
	level_r <= CONV_INTEGER(bat_x) / 80; -- 640 / 80 = 8 sections
	level_g <= CONV_INTEGER(bat_x) / 80; -- 640 / 80 = 8 sections
	level_b <= CONV_INTEGER(bat_x) / 160;
	ELSE
	level_r <= 0;
	level_g <= 0;
	level_b <= 0;
	END IF;
	
	
	-- ** assign RGBCODE 8-bit colors (3 red, 3 green, 2 blue) **
	c_red <= rgbcode(7 DOWNTO 5) + conv_std_logic_vector(level_r,3);
	c_green <= rgbcode(4 DOWNTO 2) + conv_std_logic_vector(level_g,3);
	c_blue <= rgbcode(1 DOWNTO 0) + conv_std_logic_vector(level_b,2);	

	-- OLD CODE FOR SQUARE**
	--IF (pixel_col >= inc_coord) AND
	--	 (pixel_col <= inc_coord + size) AND
	--		 (pixel_row >= origin_y) AND
	--		 (pixel_row <= origin_y + size) THEN
    --    c_red <= rgbcode(7 DOWNTO 5);
	--    c_green <= rgbcode(4 DOWNTO 2);
	--    c_blue <= rgbcode(1 DOWNTO 0);	 	 
    --ELSE
   --     c_red <= "111";
   --     c_green <= "111";
   --     c_blue <= "11";
	--END IF;
	    --c_red <= rgbimg0(i DOWNTO i-2);
	    --c_green <= rgbimg0(i-3 DOWNTO i-5);
	    --c_blue <= rgbimg0(i-6 DOWNTO i-7);
	    
	END IF;
	    
	END PROCESS;
    
		red <= c_red;
		green <= c_green;
		blue <= c_blue;
    
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
    END PROCESS;
		-- process to move ball once every frame (i.e. once every vsync pulse)
END Behavioral;