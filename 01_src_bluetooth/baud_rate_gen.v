///Funcion para determinar dado un número determine el número de bits
`define log2(n)   ((n) <= (1<<0)  ? 0 : (n)  <= (1<<1)  ? 1  :\
                   (n) <= (1<<2)  ? 2 : (n)  <= (1<<3)  ? 3  :\
                   (n) <= (1<<4)  ? 4 : (n)  <= (1<<5)  ? 5  :\
                   (n) <= (1<<6)  ? 6 : (n)  <= (1<<7)  ? 7  :\
                   (n) <= (1<<8)  ? 8 : (n)  <= (1<<9)  ? 9  :\
                   (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                   (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                   (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                   (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                   (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                   (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                   (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                   (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                   (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                   (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                   (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)



module baud_rate_gen(input wire clk_50m,
		     output wire rxclk_en,
		     output wire txclk_en);

parameter RX_ACC_MAX = 50000000 / (9600*16);
parameter TX_ACC_MAX = 50000000 / (9600);
//parameter TX_ACC_MAX = 50000000 / (9600);





parameter RX_ACC_WIDTH = `log2(RX_ACC_MAX);
parameter TX_ACC_WIDTH = `log2(TX_ACC_MAX);
reg [RX_ACC_WIDTH - 1:0] rx_acc = 0;
reg [TX_ACC_WIDTH - 1:0] tx_acc = 0;

assign rxclk_en = (rx_acc == 5'd0);
assign txclk_en = (tx_acc == 9'd0);

always @(posedge clk_50m) begin
	if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0])
		rx_acc <= 0;
	else
		rx_acc <= rx_acc + 5'b1;
end

always @(posedge clk_50m) begin
	if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
		tx_acc <= 0;
	else
		tx_acc <= tx_acc + 9'b1;
end

endmodule


/*module baud_rate_gen(input wire clk_50m,
		     output wire rxclk_en,
		     output wire txclk_en);

parameter RX_ACC_MAX = 100000000 / (9600*16);
parameter TX_ACC_MAX = 100000000 / (9600);





parameter RX_ACC_WIDTH = `log2(RX_ACC_MAX);
parameter TX_ACC_WIDTH = `log2(TX_ACC_MAX);
reg [RX_ACC_WIDTH - 1:0] rx_acc = 0;
reg [TX_ACC_WIDTH - 1:0] tx_acc = 0;

assign rxclk_en = (rx_acc == 5'd0);
assign txclk_en = (tx_acc == 9'd0);

always @(posedge clk_50m) begin
	if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0])
		rx_acc <= 0;
	else
		rx_acc <= rx_acc + 5'b1;
end

always @(posedge clk_50m) begin
	if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
		tx_acc <= 0;
	else
		tx_acc <= tx_acc + 9'b1;
end

endmodule
*/



