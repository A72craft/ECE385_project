//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0] DrawX, DrawY,
                       input logic [11:0] f0,f1,b0,b1,
                       //input logic inv,
                       input logic [31:0] data,
                       //input logic [3:0] FGD_R, FGD_G, FGD_B, BKG_R, BKG_G, BKG_B,
                       output logic [3:0]  Red, Green, Blue );
                       
    logic [6:0] code;
    logic [10:0] sprite_addr;
    logic [7:0] sprite_data;
    
//    logic [10:0] shape_x; // DrawX/8
//    logic [10:0] shape_y; // DrawY/16, top left of the current sprite
//    logic [10:0] shape_size_x = 8; //x and y dims
//    logic [10:0] shape_size_y = 16;
  
    logic uplowCheck;
    assign uplowCheck = (DrawX >> 3) & 1'b1;
    logic inv = 0;
    
    always_comb
    begin
        if (uplowCheck == 1'b0) 
            inv = data[15];
        else
            inv = data[31];
    end
    
    
    always_comb
    begin
        if (uplowCheck == 1'b0)
        begin
            code = data[14:8];
            sprite_addr = ((DrawY & 15) + 16 * code);
        end
        else // if (uplowCheck == 1'b1)
        begin
            code = data[30:24];
            sprite_addr = ((DrawY & 15) + 16 * code);
        end
    end

    
    font_rom font_rom_i (.addr(sprite_addr),.data(sprite_data));

//    assign shape_x = DrawX >> 3;
//    assign shape_y = DrawY >> 4;

//    always_comb
//    begin:Text_on_proc
//        sprite_addr = ((DrawY & 15) + 16 * code);
//     end
       
    always_comb
    begin:RGB_Display
        if ((sprite_data[7 - (DrawX & 7)] ^ inv) == 0 && uplowCheck == 0) begin 
            Red = b0[11:8];//b0_red
            Green = b0[7:4];//b0_green
            Blue = b0[3:0];//b0_blue
        end
        else if ((sprite_data[7 - (DrawX & 7)] ^ inv) == 0 && uplowCheck == 1) begin
            Red = b1[11:8];//b1_red
            Green = b1[7:4];//b1_green
            Blue = b1[3:0];//b1_blue
        end
        else if ((sprite_data[7 - (DrawX & 7)] ^ inv) == 1 && uplowCheck == 0) begin
            Red = f0[11:8];//f0_red
            Green = f0[7:4];//f0_green
            Blue = f0[3:0];//f0_blue
        end
        else begin 
            Red = f1[11:8];//f1_red
            Green = f1[7:4];//f1_green
            Blue = f1[3:0];//f1_blue
        end
    end

endmodule
