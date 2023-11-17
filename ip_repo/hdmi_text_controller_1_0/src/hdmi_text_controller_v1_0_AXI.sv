`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ECE-Illinois
// Engineer: Zuofu Cheng
// 
// Create Date: 06/08/2023 12:21:05 PM
// Design Name: 
// Module Name: hdmi_text_controller_v1_0_AXI
// Project Name: ECE 385 - hdmi_text_controller
// Target Devices: 
// Tool Versions: 
// Description: 
// This is a modified version of the Vivado template for an AXI4-Lite peripheral,
// rewritten into SystemVerilog for use with ECE 385.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps

module hdmi_text_controller_v1_0_AXI #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line

    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH	= 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH	= 14//12 week2_change
)
(
    // Users to add ports here
    input logic [9:0] DrawX,DrawY,
    output logic [11:0] front0, front1, back0, back1,//week2_change
    output logic [31:0] dataReg,
    // User ports ends
    // Do not modify the ports beyond this line

    // Global Clock Signal
    input logic  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input logic  S_AXI_ARESETN,
    // Write address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_AWPROT,
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    input logic  S_AXI_AWVALID,
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    output logic  S_AXI_AWREADY,
    // Write data (issued by master, acceped by Slave) 
    input logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    input logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    input logic  S_AXI_WVALID,
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    output logic  S_AXI_WREADY,
    // Write response. This signal indicates the status
        // of the write transaction.
    output logic [1 : 0] S_AXI_BRESP,
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    output logic  S_AXI_BVALID,
    // Response ready. This signal indicates that the master
        // can accept a write response.
    input logic  S_AXI_BREADY,
    // Read address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    input logic  S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    output logic  S_AXI_ARREADY,
    // Read data (issued by slave)
    output logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
        // read transfer.
    output logic [1 : 0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    output logic  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    input logic  S_AXI_RREADY
);

// AXI4LITE signals
logic  [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
logic  axi_awready;
logic  axi_wready;
logic  [1 : 0] 	axi_bresp;
logic  axi_bvalid;
logic  [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
logic  axi_arready;
logic  [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
logic  [1 : 0] 	axi_rresp;
logic  	axi_rvalid;

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 11; // 9 for 601
//----------------------------------------------
//-- Signals for user logic register space example
//------------------------------------------------
//-- Number of Slave Registers 4
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
//
//Note: the provided Verilog template had the registered declared as above, but in order to give 
//students a hint we have replaced the 4 individual registers with an unpacked array of packed logic. 
//Note that you as the student will still need to extend this to the full register set needed for the lab.
localparam integer regNum = 16;//8 ignore week2_change
logic [C_S_AXI_DATA_WIDTH-1:0] slv_regs[regNum];//ignore
logic	 slv_reg_rden;
logic	 slv_reg_wren;
logic [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
integer	 byte_index;
logic	 aw_en;
//On-chip memory block
logic [3:0] wea,web;
assign web = 4'b0;
//logic [31:0] dina,douta,dinb,doutb;
//logic [31:0] addra,addrb;

logic [10:0] displayAdrr;
logic [11:0] tempAddr;
/*
	port A is for AXI communication
	port B is for VGA communication
*/
blk_mem_gen_0 ram0(
    .clka(S_AXI_ACLK),//read/write from AXI
    .wea(wea),
    .addra(tempAddr),//addra
    .dina(S_AXI_WDATA),
    .douta(S_AXI_RDATA),
    .ena(1'b1),
    .clkb(S_AXI_ACLK),
    .web(web),
    .addrb(displayAdrr), ///VGA read
    .doutb(dataReg),
    .enb(1'b1)
);
// I/O Connections assignments

assign S_AXI_AWREADY	= axi_awready;
assign S_AXI_WREADY	= axi_wready;
assign S_AXI_BRESP	= axi_bresp;
assign S_AXI_BVALID	= axi_bvalid;
assign S_AXI_ARREADY	= axi_arready;
assign S_AXI_RDATA	= axi_rdata;
assign S_AXI_RRESP	= axi_rresp;
assign S_AXI_RVALID	= axi_rvalid;


// Implement axi_awready generation
// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
// de-asserted when reset is low.
always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_awready <= 1'b0;
      aw_en <= 1'b1;
    end
  else
    begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
        begin
          // slave is ready to accept write address when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_awready <= 1'b1;
          aw_en <= 1'b0;
        end
        else if (S_AXI_BREADY && axi_bvalid)
            begin
              aw_en <= 1'b1;
              axi_awready <= 1'b0;
            end
      else           
        begin
          axi_awready <= 1'b0;
        end
    end 
end       

// Implement axi_awaddr latching
// This process is used to latch the address when both 
// S_AXI_AWVALID and S_AXI_WVALID are valid. 

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_awaddr <= 0;
    end 
  else
    begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
        begin
          // Write Address latching 
          axi_awaddr <= S_AXI_AWADDR;
        end
    end 
end       

// Implement axi_wready generation
// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
// de-asserted when reset is low. 

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_wready <= 1'b0;
    end 
  else
    begin    
      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
        begin
          // slave is ready to accept write data when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_wready <= 1'b1;
        end
      else
        begin
          axi_wready <= 1'b0;
        end
    end 
end       

//start here:!!!

logic paletteEn;
logic [11:0] writeAddr = S_AXI_AWADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];
logic [11:0] readAddr = S_AXI_ARADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

always_ff @( posedge S_AXI_ACLK )
begin 
    if (S_AXI_ARVALID) begin
        tempAddr <= readAddr;
        wea <= 4'b0;
        paletteEn = 1'b0;
    end else if (writeAddr[11] == 1 && S_AXI_WVALID) begin
        paletteEn = 1'b1;
        wea = 4'b0;
    end else if (writeAddr[11] == 0 && S_AXI_WVALID) begin
        tempAddr <= writeAddr;
        wea <= S_AXI_WSTRB;
        paletteEn <= 1'b0;
    end else begin
        tempAddr <= 12'b0;
        wea <= 4'b0;
        paletteEn <= 1'b0;
    end
 end
 
 //palette
 logic [3:0] palettenIndex;
 logic [11:0] paletteReg [16];
 assign palettenIndex = (S_AXI_AWADDR - 16'h2000) >> 2; // from current to start and divide by 4 since there is 4 each
 always_ff @( posedge S_AXI_ACLK )
 begin
    if (S_AXI_ARESETN == 1'b0) begin
        for (int i = 0; i < 16; i++) begin
            paletteReg[i] <= 12'b0;
        end
    end else if (paletteEn == 1'b1) begin
        paletteReg[palettenIndex] <= S_AXI_WDATA[11:0];
    end else begin     
    end
 end
//ff:
//if(ar_varlidy)
// real_ad <= readYadd 12bit[11:0]
//write_en = 0
//enable palette bit = 0
//IF CHECK [11]->GAP == 1 | 0 && WRITE ADRESS VALID
//REAL<-W
//WRITE ENABLE <-S_AXi_TROB 4 BIT 
//paletee bit = 0 / 1

//else deaflut

//logic[11:0] palatee [16]

//ff:

//write 


// Implement memory mapped register select and write logic generation
// The write data is accepted and written to memory mapped registers when
// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
// select byte enables of slave registers while writing.
// These registers are cleared when reset (active low) is applied.
// Slave register write enable is asserted when valid address and data are available
// and the slave is ready to accept the write address and write data.
//assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
//logic slv_wren_1;
//always_ff @( posedge S_AXI_ACLK )
//begin
//  if ( S_AXI_ARESETN == 1'b0 )
//    begin
//    	//originally it clears all registers, now it does nothing
//      wea <= 1'b0;
//      addra <= 32'h00000000;
//      dina <= 32'h00000000;
//    end
//  else begin
//    if (slv_reg_wren) begin:write
//		if(axi_awaddr >= 12'h2000) begin:writeToRegister
//        	for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 ) begin
//          		if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//            		slv_regs[axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB]][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//				end
//			end
//		end else begin:writeToBRAM
//			//write to bram,does not need another clock cycle
//			wea <= S_AXI_WSTRB;
//        	addra <= axi_awaddr;
//        	dina <= S_AXI_WDATA;
//        end
//	end 
////	else begin:clearWriteSignals
////      	wea <= 4'b0000;
////      	addra <= 32'h00000000;
////      	dina <= 32'h00000000;
////	end
//  end
//end    

// Implement write response logic generation
// The write response and response valid signals are asserted by the slave 
// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
// This marks the acceptance of address and indicates the status of 
// write transaction.

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_bvalid  <= 0;
      axi_bresp   <= 2'b0;
    end 
  else
    begin    
      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
        begin
          // indicates a valid write response is available
          axi_bvalid <= 1'b1;
          axi_bresp  <= 2'b0; // 'OKAY' response 
        end                   // work error responses in future
      else
        begin
          if (S_AXI_BREADY && axi_bvalid) 
            //check if bready is asserted while bvalid is high) 
            //(there is a possibility that bready is always asserted high)   
            begin
              axi_bvalid <= 1'b0; 
            end  
        end
    end
end   

// Implement axi_arready generation
// axi_arready is asserted for one S_AXI_ACLK clock cycle when
// S_AXI_ARVALID is asserted. axi_awready is 
// de-asserted when reset (active low) is asserted. 
// The read address is also latched when S_AXI_ARVALID is 
// asserted. axi_araddr is reset to zero on reset assertion.

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_arready <= 1'b0;
      axi_araddr  <= 32'b0;
    end 
  else
    begin    
      if (~axi_arready && S_AXI_ARVALID)
        begin
          // indicates that the slave has acceped the valid read address
          axi_arready <= 1'b1;
          // Read address latching
          axi_araddr  <= S_AXI_ARADDR;
		  //addra <= S_AXI_ARADDR;
        end
      else
        begin
          axi_arready <= 1'b0;
        end
    end 
end       

// Implement axi_arvalid generation
// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
// data are available on the axi_rdata bus at this instance. The 
// assertion of axi_rvalid marks the validity of read data on the 
// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
// is deasserted on reset (active low). axi_rresp and axi_rdata are 
// cleared to zero on reset (active low).  
always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end 
  else
    begin    
      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
        begin
          // Valid read data is available at the read data bus
          axi_rvalid <= 1'b1;
          axi_rresp  <= 2'b0; // 'OKAY' response
        end   
      else if (axi_rvalid && S_AXI_RREADY)
        begin
          // Read data is accepted by the master
          axi_rvalid <= 1'b0;
        end                
    end
end    

// Implement memory mapped register select and read logic generation
// Slave register read enable is asserted when valid address is available
// and the slave is ready to accept the read address.
//assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

//always_comb
//begin
//    if (axi_araddr >= 12'h2000)//if reading from registers
//    	reg_data_out = slv_regs[axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB]];
//	else //reading from BRAM
//		reg_data_out = douta;
//end

//// Output register or memory read data
//always_ff @( posedge S_AXI_ACLK )
//begin
//  if ( S_AXI_ARESETN == 1'b0 )
//    begin
//      axi_rdata  <= 0;
//    end 
//  else
//    begin    
//      // When there is a valid read address (S_AXI_ARVALID) with 
//      // acceptance of read address by the slave (axi_arready), 
//      // output the read dada 
//      if (slv_reg_rden)
//        begin
//          axi_rdata <= reg_data_out;     // register read data
//        end   
//    end
//end    

// Add user logic here
//logic [10:0] X,Y;
//logic [31:0] code_addr;
//logic mem_index;
//logic [3:0] FGD,BKG;

//logic getCharCode_f1,getCharCode_f2;

//always_comb begin:get_character_addr
//    X = DrawX >> 3;
//    Y = DrawY >> 4;
//	//determine the address
//	mem_index = X & 1;
//    code_addr = Y*160 + (X >> 1)*4;
//end


////wait for one clk cycle
//always_ff @(posedge S_AXI_ACLK) begin:getCharCode_1
//	if (getCharCode_f1) begin
//		getCharCode_f1 <= 1'b0;
//		//getCharCode_f2 <= 1'b1;
//		addrb <= code_addr;
//	end else
//		getCharCode_f1 <= 1'b0;
//end

//always_ff @(posedge S_AXI_ACLK) begin:getCharCode_2
//	if (getCharCode_f2) begin
//		getCharCode_f2 <= 1'b0;
//    	//check the doc, should work
//		code <= doutb[(16*mem_index + 8) +: 7];
//		Inv <= doutb[mem_index*16+15];
//		FGD <= doutb[(16*mem_index + 4) +: 4];
//		BKG <= doutb[(16*mem_index) +: 4];
//	end else
//		getCharCode_f2 <= 1'b0;
//		//getCharCode_f1 <= 1'b1;
//end

//logic FGD_index,BKG_index; //0 or 1
//logic [2:0] FGD_reg,BKG_reg; //index 0 to 7

////
//always_comb begin:Color_assignment
//	FGD_reg = FGD >> 1;
//	BKG_reg = BKG >> 1;
//	FGD_index = FGD & 1;
//	BKG_index = BKG & 1;
//	FGD_R = slv_regs[FGD_reg][(9+FGD_index*12) +: 4];
//    FGD_G = slv_regs[FGD_reg][(5+FGD_index*12) +: 4];
//    FGD_B = slv_regs[FGD_reg][(1+FGD_index*12) +: 4];
//    BKG_R = slv_regs[BKG_reg][(9+BKG_index*12) +: 4];
//    BKG_G = slv_regs[BKG_reg][(5+BKG_index*12) +: 4];
//    BKG_B = slv_regs[BKG_reg][(1+BKG_index*12) +: 4];
//end

logic [9:0] X,Y;

always_comb
begin
X = DrawX >> 4; //2 bytes per char, so 16 bits, x-axis
Y = DrawY >> 4; // dont hight 16 bits, y-axis
displayAdrr = Y * 11'd40 + X; // d40 = 0000 0010 1000
front0 = paletteReg[dataReg[7:4]]; //green on red , green 1, red 0
back0 = paletteReg[dataReg[3:0]];
front1 = paletteReg[dataReg[23:20]];
back1 = paletteReg[dataReg[19:16]];//green 1, red0, Red on Green
//x03 (01) 01 (10)
end

// User logic ends

endmodule
