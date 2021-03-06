----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.06.2020 19:55:12
-- Design Name: 
-- Module Name: SinCos_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.math_real.all;
use std.textio.all;
Use work.utility.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SinCos_tb is
--  Port ( );
end SinCos_tb;

architecture Behavioral of SinCos_tb is          
    
      constant nBit:Natural:=31;
      constant iteraciones:Natural:=15;
      
      constant bArcotan: 
                rVector(15 downto 0):=(
                       0.785398163,
                       0.463647609,
                       0.244978663,
                       0.124354995,
                       0.06241881,
                       0.031239833,
                       0.015623729,
                       0.007812341,
                       0.00390623,
                       0.001953123,
                       0.000976562,
                       0.000488281,
                       0.000244141,
                       0.00012207,
                       6.10352E-05,
                       3.05176E-05
                    );  
    
    component CordicUnrolled is
        generic(nBit: Natural;
                iteracion:natural;
                arctan: rVector
                );
        Port ( 
               M_i : in STD_LOGIC;
               x_i : in STD_LOGIC_VECTOR (nBit downto 0);
               y_i : in STD_LOGIC_VECTOR (nBit downto 0);
               z_i : in STD_LOGIC_VECTOR (nBit downto 0);
               x_o : out STD_LOGIC_VECTOR (nBit downto 0);
               y_o : out STD_LOGIC_VECTOR (nBit downto 0);
               z_o : out STD_LOGIC_VECTOR (nBit downto 0)
               );
     end component;
    
    signal angleRot,sinRot,cosRot,zRot: std_logic_vector(nBit downto 0) := (others =>'0'); 
    signal ceroIn, K: std_logic_vector(nBit downto 0):= (others =>'0'); 
begin
         
    
    R: CordicUnrolled 
            generic map (nBit, iteraciones, bArcotan)
            port map(
                M_i => '1',
                x_i => K,
                y_i => ceroIn,
                z_i => angleRot,
                x_o => cosRot,
                y_o => sinRot,
                z_o => zRot
            );
            
     Test: process        
           variable  angulo,Ki:real;                   
        begin
           
          Ki:=1.0; 
           
          for i in 0 to iteraciones loop 
             Ki:=Ki*(1.0/sqrt(1.0+2.0**(-2*i)));
            end 
          loop; 
           K<= Conv_fixedPt(Ki,nBit);
          
               angulo:=-math_pi/2.0;
               while 1<2 loop                              
                   angleRot<=Conv_fixedPt(angulo,nBit);             
                   report "SENO: "& real'image(Conv2real(sinRot,nBit));
                   report "COSENO: "& real'image(Conv2real(cosRot,nBit));
                   angulo:=angulo + math_pi/200.0;
                   if (angulo > math_pi/2.0)then
                        angulo:=-math_pi/2.0;
                   end if;
                   if (angulo < -math_pi/2.0)then
                            angulo:=math_pi/2.0;
                   end if;                   
                 wait for 1 ps;             
               end loop; 
             wait;
       end process; 
end Behavioral;
