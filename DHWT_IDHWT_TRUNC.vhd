-------------------------------------------------------------------------------
--TÍTULO: DHWT_IDHWT_TRUNC.vhd
-------------------------------------------------------------------------------
--AUTOR:     Professora Doutora Morgana Macedo Azevedo da Rosa
--DATA:      07/11/2025
--VERSÃO:    [1.0]
--VERSÃO QUARTUS: 15.1 Altera Lite
-------------------------------------------------------------------------------
--DESCRIÇÃO/OBJETIVO:
--		Este módulo é responsável por implementar um framework de teste para 
--    Computação Aproximada aplicada ao processamento de imagens via Transformada 
--    Discreta de Wavelet Haar (DWT) e sua Inversa (IDWT)
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY Somador_Nbits IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end Somador_Nbits;

ARCHITECTURE behavior OF Somador_Nbits IS
	signal c     : std_logic;
    signal VI    : std_logic_vector(N+1 downto 0);
    signal axb, abxc : std_logic_vector(N downto K);
    signal cout  : std_logic_vector(N+1 downto K);
begin

    approx : for j in 0 to K-1 generate
        VI(j) <= '0';
    end generate approx;

    c <= '0';
    cout(K) <= c;

    approx2 : for j in K to N generate
        axb(j)   <= a(j) xor b(j);
        abxc(j)  <= axb(j) xor cout(j);

        with axb(j) select 
            cout(j+1) <= a(j) when '0',
                          cout(j) when others;
    end generate approx2;

    VI(N downto K) <= abxc;
    VI(N+1)        <= cout(N+1);
    s(N+1 downto 0) <= VI(N+1 downto 0);

end architecture;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Subtrator N-bits com - da ferramenta
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY Subtrator_Nbits IS
Generic (N : positive);
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end Subtrator_Nbits;

ARCHITECTURE behavior OF Subtrator_Nbits IS
--
	signal c: std_logic;  
	signal VI: std_logic_vector(N+1 downto 0);    
   signal axb, abxc, sb: std_logic_vector(N downto 0);
   signal cout : std_logic_vector(N+1 downto 0);	
--
begin

sb <= not b;

	 c <= '1';                                                                                                   
	 cout(0)<= c;
       approx2: for j in 0 to N generate                                                                                               
	 axb(j) <= a(j) xor sb(j);                                                                                                           
	 abxc(j) <= axb(j) xor cout(j); 
		with axb(j) select 
		cout(j+1) <= a(j) when '0',
		  cout(j) when others;
				
	end generate approx2;
	 
	VI(N downto 0)<= abxc;
	VI(N+1)<= cout(N+1);
	s(N+1 downto 0)<=VI(N+1 downto 0);

end architecture;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Subtrator N-bits com - da ferramenta
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY Ferramenta_Somador_Nbits IS
Generic (N : positive);
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end Ferramenta_Somador_Nbits;

ARCHITECTURE behavior OF Ferramenta_Somador_Nbits IS
		
begin

s<= (a(N)& a) + (b(N)& b);
end architecture;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Subtrator N-bits com - da ferramenta
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY Ferramenta_Subtrator_Nbits IS
Generic (N : positive);
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end Ferramenta_Subtrator_Nbits;

ARCHITECTURE behavior OF Ferramenta_Subtrator_Nbits IS
--

--
begin

s<= (a(N)& a) - (b(N)& b);

end architecture;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- DWT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY DWT_m2 IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		X1, X2, X3, X4			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   LL, LH, HL, HH			: OUT STD_LOGIC_VECTOR(N   DOWNTO 0));
end DWT_m2;

ARCHITECTURE behavior OF DWT_m2 IS
signal c0, c1, c2, c3 : STD_LOGIC_VECTOR (N+1 DOWNTO 0);
signal d0, d1, d2, d3 : STD_LOGIC_VECTOR (N   DOWNTO 0);
signal s0, s1, s2, s3 : STD_LOGIC_VECTOR (N+1 DOWNTO 0);
--
component Somador_Nbits IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end component; 
--
component Subtrator_Nbits IS
Generic (N : positive);
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end component;
--
begin
--
comp0: Somador_Nbits   generic map(K,N) port map (X1, X2, c0);
d0 <= c0(N+1 DOWNTO 1);
--
comp1: Subtrator_Nbits generic map(N) port map (X1, X2, c1);
d1 <= c1(N+1 DOWNTO 1);
--
comp2: Somador_Nbits   generic map(K,N) port map (X3, X4, c2);
d2 <= c2(N+1 DOWNTO 1);
--
comp3: Subtrator_Nbits generic map(N) port map (X3, X4, c3);
d3 <= c3(N+1 DOWNTO 1);
--
--
comp4: Somador_Nbits   generic map(K,N) port map (d0, d2, s0);
LL <= s0(N+1 DOWNTO 1);
--
comp5: Subtrator_Nbits generic map(N) port map (d0, d2, s1);
LH <= s1(N+1 DOWNTO 1);
--
comp6: Somador_Nbits   generic map(K,N) port map (d1, d3, s2);
HL <= s2(N+1 DOWNTO 1);
--
comp7: Subtrator_Nbits generic map(N) port map (d1, d3, s3);
HH <= s3(N+1 DOWNTO 1);
--
end architecture;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- IDWT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY IDWT_m2 IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		LL, LH, HL, HH			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   X1, X2, X3, X4			: OUT STD_LOGIC_VECTOR(N   DOWNTO 0));
end IDWT_m2;

ARCHITECTURE behavior OF IDWT_m2 IS
signal c0, c1, c2, c3 : STD_LOGIC_VECTOR (N+1 DOWNTO 0);
signal d0, d1, d2, d3 : STD_LOGIC_VECTOR (N   DOWNTO 0);
signal s0, s1, s2, s3 : STD_LOGIC_VECTOR (N+1 DOWNTO 0);
--
component Somador_Nbits IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end component; 
--
component Ferramenta_Subtrator_Nbits IS
Generic (N : positive);
PORT ( 
		a, b			: IN STD_LOGIC_VECTOR (N   DOWNTO 0);
	   s				: OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0));
end component;
--
begin
--
comp0: Somador_Nbits  				generic map(K, N) port map (LL, LH, c0);
d0 <= c0(N DOWNTO 0);
--
comp1: Ferramenta_Subtrator_Nbits 	generic map(N) port map (LL, LH, c1);
d1 <= c1(N DOWNTO 0);
--
comp2: Somador_Nbits   				generic map(K, N) port map (HL, HH, c2);
d2 <= c2(N DOWNTO 0);
--
comp3: Ferramenta_Subtrator_Nbits 	generic map(N) port map (HL, HH, c3);
d3 <= c3(N DOWNTO 0);
--
--
comp4: Somador_Nbits   				generic map(K,N) port map (d0, d2, s0);
X1 <= s0(N DOWNTO 0);
--
comp5: Ferramenta_Subtrator_Nbits 	generic map(N) port map (d0, d2, s1);
X2 <= s1(N DOWNTO 0);
--
comp6: Somador_Nbits   				generic map(K,N) port map (d1, d3, s2);
X3 <= s2(N DOWNTO 0);
--
comp7: Ferramenta_Subtrator_Nbits 	generic map(N) port map (d1, d3, s3);
X4 <= s3(N DOWNTO 0);
--
end architecture;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- IDWT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

ENTITY DHWT_IDHWT_TRUNC IS
generic (
       
        N : integer:=8
    );
PORT (

		 X1,  X2,  X3,  X4   : IN  STD_LOGIC_VECTOR(N   DOWNTO 0);
	    LL1,  
		iLL1, iLH1, iHL1, iHH1,
		LL2,  
		iLL2, iLH2, iHL2, iHH2,
		LL3,  
		iLL3, iLH3, iHL3, iHH3,
		LL4,  
		iLL4, iLH4, iHL4, iHH4,
		LL5,  
		iLL5, iLH5, iHL5, iHH5,
		LL6,  
		iLL6, iLH6, iHL6, iHH6,
		LL7,  
		iLL7, iLH7, iHL7, iHH7,
		LL8,  
		iLL8, iLH8, iHL8, iHH8	: OUT STD_LOGIC_VECTOR(N   DOWNTO 0)
		);
end DHWT_IDHWT_TRUNC;

ARCHITECTURE behavior OF DHWT_IDHWT_TRUNC IS
--
component DWT_m2 IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		X1, X2, X3, X4			: IN  STD_LOGIC_VECTOR(N   DOWNTO 0);
	   LL, LH, HL, HH			: OUT STD_LOGIC_VECTOR(N   DOWNTO 0));
end component; 
--
component IDWT_m2 IS
generic (
        K : positive:=1;
        N : integer:=7
    );
PORT ( 
		LL, LH, HL, HH			: IN  STD_LOGIC_VECTOR(N   DOWNTO 0);
	   X1, X2, X3, X4			: OUT STD_LOGIC_VECTOR(N   DOWNTO 0));
end component;
--
signal wLL1, wLH1, wHL1, wHH1 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL2, wLH2, wHL2, wHH2 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL3, wLH3, wHL3, wHH3 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL4, wLH4, wHL4, wHH4 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL5, wLH5, wHL5, wHH5 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL6, wLH6, wHL6, wHH6 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL7, wLH7, wHL7, wHH7 	: STD_LOGIC_VECTOR(N   DOWNTO 0);
signal wLL8, wLH8, wHL8, wHH8 	: STD_LOGIC_VECTOR(N   DOWNTO 0);

--
begin
--
DWT_k1: DWT_m2 GENERIC MAP(1, N) port map (X1,  X2  , X3 , X4 , wLL1, wLH1, wHL1 ,wHH1);
IDWT_k1: IDWT_m2 GENERIC MAP(1, N) port map (wLL1, wLH1, wHL1, wHH1, iLL1, iLH1, iHL1, iHH1);

DWT_k2: DWT_m2 GENERIC MAP(2, N) port map (X1,  X2  , X3 , X4 , wLL2, wLH2, wHL2 ,wHH2);
IDWT_k2: IDWT_m2 GENERIC MAP(2, N) port map (wLL2, wLH2, wHL2, wHH2, iLL2, iLH2, iHL2, iHH2);

DWT_k3: DWT_m2 GENERIC MAP(3, N) port map (X1,  X2  , X3 , X4 , wLL3, wLH3, wHL3 ,wHH3);
IDWT_k3: IDWT_m2 GENERIC MAP(3, N) port map (wLL3, wLH3, wHL3, wHH3, iLL3, iLH3, iHL3, iHH3);

DWT_k4: DWT_m2 GENERIC MAP(4, N) port map (X1,  X2  , X3 , X4 , wLL4, wLH4, wHL4 ,wHH4);
IDWT_k4: IDWT_m2 GENERIC MAP(4, N) port map (wLL4, wLH4, wHL4, wHH4, iLL4, iLH4, iHL4, iHH4);

DWT_k5: DWT_m2 GENERIC MAP(5, N) port map (X1,  X2  , X3 , X4 , wLL5, wLH5, wHL5 ,wHH5);
IDWT_k5: IDWT_m2 GENERIC MAP(5, N) port map (wLL5, wLH5, wHL5, wHH5, iLL5, iLH5, iHL5, iHH5);

DWT_k6: DWT_m2 GENERIC MAP(6, N) port map (X1,  X2  , X3 , X4 , wLL6, wLH6, wHL6 ,wHH6);
IDWT_k6: IDWT_m2 GENERIC MAP(6, N) port map (wLL6, wLH6, wHL6, wHH6, iLL6, iLH6, iHL6, iHH6);

DWT_k7: DWT_m2 GENERIC MAP(7, N) port map (X1,  X2  , X3 , X4 , wLL7, wLH7, wHL7 ,wHH7);
IDWT_k7: IDWT_m2 GENERIC MAP(7, N) port map (wLL7, wLH7, wHL7, wHH7, iLL7, iLH7, iHL7, iHH7);

DWT_k8: DWT_m2 GENERIC MAP(8, N) port map (X1,  X2  , X3 , X4 , wLL8, wLH8, wHL8 ,wHH8);
IDWT_k8: IDWT_m2 GENERIC MAP(8, N) port map (wLL8, wLH8, wHL8, wHH8, iLL8, iLH8, iHL8, iHH8);

LL1 <= wLL1;
LL2 <= wLL2;
LL3 <= wLL3;
LL4 <= wLL4;
LL5 <= wLL5;
LL6 <= wLL6;
LL7 <= wLL7;
LL8 <= wLL8;


--
end architecture;