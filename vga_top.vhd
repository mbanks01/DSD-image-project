LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_top IS
    PORT (
        clk_in    : IN STD_LOGIC;
        vga_red   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_blue  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC;
        
        btn0 : IN STD_LOGIC;
        bt_x : IN STD_LOGIC;
        bt_y : IN STD_LOGIC;
        bt_level : IN STD_LOGIC;
        bt_other : IN STD_LOGIC;
        
        
        ADC_CS : OUT STD_LOGIC; -- ADC signals CONTROLLER
        ADC_SCLK : OUT STD_LOGIC;
        ADC_SDATA1 : IN STD_LOGIC;
        ADC_SDATA2 : IN STD_LOGIC
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS

    SIGNAL pxl_clk : STD_LOGIC;
    -- internal signals to connect modules
    SIGNAL S_red, S_green : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL S_blue : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    
    
    -- NEW CODE FOR CONTROLLER
    SIGNAL batpos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL serial_clk, sample_clk : STD_LOGIC;
    SIGNAL adout : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL count : STD_LOGIC_VECTOR (9 DOWNTO 0); -- counter to generate ADC clocks
    COMPONENT adc_if IS
        PORT (
            SCK : IN STD_LOGIC;
            SDATA1 : IN STD_LOGIC;
            SDATA2 : IN STD_LOGIC;
            CS : IN STD_LOGIC;
            data_1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    END COMPONENT;
    
    
    
    COMPONENT ball IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            red : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            swap : IN STD_LOGIC;                    -- button press
            transform_x : IN STD_LOGIC;  
            transform_y : IN STD_LOGIC;
            level_mod : IN STD_LOGIC;
            other_mod : IN STD_LOGIC;
            blue : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0) -- CONTROLLER
            
        );
    END COMPONENT;
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            hsync     : OUT STD_LOGIC;
            vsync     : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    
    component clk_wiz_0 is
    port (
      clk_in1  : in std_logic;
      clk_out1 : out std_logic
    );
    end component;
    
    
BEGIN
    -- vga_driver only drives MSB of red, green & blue
    -- so set other bits to zero
    --vga_red(2 DOWNTO 0) <= "000";
    --vga_green(2 DOWNTO 0) <= "000";
    --vga_blue(1 DOWNTO 0) <= "00";
        -- Process to generate clock signals
    ckp : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(clk_in);
        count <= count + 1; -- counter to generate ADC timing signals
    END PROCESS;
    serial_clk <= NOT count(4); -- 1.5 MHz serial clock for ADC
    ADC_SCLK <= serial_clk;
    sample_clk <= count(9); -- sampling clock is low for 16 SCLKs
    ADC_CS <= sample_clk;
    -- Multiplies ADC output (0-4095) by 5/32 to give bat position (0-640)
    --batpos <= ('0' & adout(11 DOWNTO 3)) + adout(11 DOWNTO 5);
    batpos <= ("00" & adout(11 DOWNTO 3)) + adout(11 DOWNTO 4);
    -- 512 + 256 = 768
    adc : adc_if
    PORT MAP(-- instantiate ADC serial to parallel interface
        SCK => serial_clk, 
        CS => sample_clk, 
        SDATA1 => ADC_SDATA1, 
        SDATA2 => ADC_SDATA2, 
        data_1 => OPEN, 
        data_2 => adout 
    );
    
    
    add_ball : ball
    PORT MAP(
        --instantiate ball component
        v_sync    => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        red       => S_red, 
        green     => S_green, 
        bat_x     => batpos,
        swap    =>  btn0,
        transform_x => bt_x,
        transform_y  => bt_y,
        level_mod => bt_level,
        other_mod => bt_other,
        blue      => S_blue
        
    );

    vga_driver : vga_sync
    PORT MAP(
        --instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in    => S_red, 
        green_in  => S_green, 
        blue_in   => S_blue, 
        red_out => vga_red(2 DOWNTO 0),
        green_out => vga_green(2 DOWNTO 0),
        blue_out  => vga_blue(1 DOWNTO 0),
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync     => vga_hsync, 
        vsync     => S_vsync
    );
    vga_vsync <= S_vsync; --connect output vsync
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    
END Behavioral;