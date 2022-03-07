
`timescale 1ns / 1ps

module test_bluetooth(sw,rst,rx_bl,tx_bl,leds,clkf,out_test,izq,der,on_off_l);
	
	input wire  sw,rst,rx_bl,clkf;
	output wire tx_bl,izq,der,on_off_l;
	output wire [7:0]leds;
	
	reg [7:0] data_in = 0;//8'b00110101;//8'b0;//8'b00110101;
	reg [7:0] leds_rg = 0;
	reg enable = 0;
	reg clr_rdy = 0;
	reg flag =0;
	wire busy_tx,rdy_bl,rdy_clr_bl,enable_wire;
	wire [7:0]data_wire;
	wire [7:0]data_out;
	
	output out_test;
	reg delay;
	reg [12:0] c = 13'b1111111111111;
	
	reg test = 0;
	
	reg memo_led;
	
	reg on_off_lr;	
	reg der_r,izq_r;	
	
	
///////////////////////////////FUNCIONA ENIVIANDO, PERO CON ERRORES////////////77	
	assign enable_wire = (sw==1)?	1'b1:0;
	//assign leds = (busy_tx==1)?	1'b1:0;
	assign data_wire = 8'b00110111;//data_in;
	
//////////////////////////////////////////////////////////////////////777	
	
	
	uart serial(data_wire,enable_wire,clkf,tx_bl,busy_tx,rx_bl,rdy_bl,rdy_clr_bl,data_out);
	

	
/*	always @(clkf)
	begin
		if(sw)
		begin
			flag <= 1;
		end
		if(flag)
		begin
			test <=1;
			if(c>=5207)
			begin
				c <= 0;
				test <= 0;
			end
			else
			begin
				c <= c + 1;
			end
		end
		else
		begin
			test <= 0;
		end
		
	end

	assign out_test = test;*/
	
/*	always @(posedge clkf)
	begin
		if(sw)
		begin
			c <= 0;
			flag <= 1;
		end
		if(c>=5207)
		begin
			c <= 0;
			flag <= 0;
		end
		else
		begin
			c <= c + 1;
		end
	end
	
	always @(c)
		begin
			if(c<=(5208/2)-1)
				delay <= 1;
			else
				delay <= 0;
		end*/

	
//	assign out_test = flag;
	
/*	always @(posedge clkf)
	begin
		if(sw && !flag)
		begin
			flag <= 1;
			enable <= 1;
			data_in <= 8'b00110101;
		end
/*		
		if(!busy_tx && flag )
		begin
			flag <= 0;
			enable <= 0;
			data_in <= 8'b0;
		end
	end*/

/*	assign enable_wire = enable;
	assign data_wire = data_in;
	assign leds = data_wire;*/
	
	
	
	
	
/*	always @(posedge clkf)
		begin
			if(rst)
				begin
					enable <= 0;
					data_in <= 8'b0;
				end
			else
				if(sw)
					begin
						data_in <= 8'b00110101;	
						enable <= 1;
						
					end
				if(busy_tx)
					begin
						flag <= 1;
					end
				else
					begin
						enable <= 0;
						data_in <= 8'b0;
					end
		end
		
	assign enable_wire = enable;
	assign data_wire = data_in;
	assign leds = busy_tx;//data_wire;*/		
		
////////////////////////////RECEPCION DE DATOS//////////////////////////////////////////////		
	always @(rdy_bl)
		begin
			if(rdy_bl)
				begin
					leds_rg <= data_out;
					clr_rdy <= 1;
				end
			else
				begin
					//leds_rg <= 0;
					leds_rg <= data_out;
					clr_rdy <= 0;
				end
		end
		
	assign rdy_clr_bl = clr_rdy;
	assign leds = leds_rg;//Para ver lo que se le envia por bluetooth en los leds
	
//*******************************FUNCIONA SALIDA****************************
/*	assign izq = (leds_rg==7'b01000010)?	1'b1://Baja
					 (leds_rg==7'b01000001)?	1'b0://sube
					 (leds_rg==7'b01000011)?	1'b0:1;//Para
	
	
	assign der = (leds_rg==7'b01000010)?	1'b0://Baja	
					 (leds_rg==7'b01000001)?	1'b1://Sube
					 (leds_rg==7'b01000011)?	1'b0:0;//Para
	
	
	
	assign on_off_l = (leds_rg==7'b01001010)?	1'b1://Sube
							(leds_rg==7'b01001011)?	1'b0:1;*/
//*********************************************************************							
							
	always @(clkf)
	begin
		if(data_out[3]==1) //Funciones led
		begin 
			if(data_out==7'b01001010)
				on_off_lr <= 1;
			else
				on_off_lr <= 0;
		end
		if(data_out[3]==0) //Funciones Motor
		begin 
			if(data_out==7'b01000010)
			begin
				izq_r <= 1;
				der_r <= 0;
			end	
			if(data_out==7'b01000001)
			begin
				izq_r <= 0;
				der_r <= 1;
			end
			if(data_out==7'b01000011)//Para
			begin
				izq_r <= 0;
				der_r <= 0;
			end				
		end		
	end
	
	assign on_off_l = on_off_lr;
	assign izq = izq_r;
	assign der = der_r;	

////////////////////////////////////////////////////////////////////////////////////////
	
endmodule	


module uart(input wire [7:0] din,
	    input wire wr_en,// enable tx
	    input wire clk_50m,//clock 50mH from fpga
	    output wire tx, //tranmitter data
	    output wire tx_busy,//indicate when tx is trasnmitting
	    input wire rx,//receiver data
	    output wire rdy,//rdy is 1 when data is full 
	    input wire rdy_clr,//preparete for next data
	    output wire [7:0] dout);//data from rx

	wire rxclk_en, txclk_en;

	baud_rate_gen uart_baud(.clk_50m(clk_50m), .rxclk_en(rxclk_en), .txclk_en(txclk_en));

	transmitter uart_tx(.din(din), .wr_en(wr_en), .clk_50m(clk_50m), .clken(txclk_en), .tx(tx), .tx_busy(tx_busy));

	receiver uart_rx(.rx(rx), .rdy(rdy), .rdy_clr(rdy_clr), .clk_50m(clk_50m), .clken(rxclk_en), .data(dout));

endmodule
