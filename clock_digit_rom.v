`timescale 1ns / 1ps

module clock_digit_rom(
    input clk,
    input [10:0] addr,
    output reg [7:0] data
);

    // ROM for ASCII digits 0-9 and colon (:)
    // Each character is 8x16 pixels
    // addr = {char_addr[6:0], row_addr[3:0]}
    
    always @(posedge clk) begin
        case(addr[10:4])  // char_addr
            // ASCII '0' (0x30)
            7'h30: case(addr[3:0])
                4'h0: data <= 8'b00111100;
                4'h1: data <= 8'b01100110;
                4'h2: data <= 8'b01101110;
                4'h3: data <= 8'b01110110;
                4'h4: data <= 8'b01100110;
                4'h5: data <= 8'b01100110;
                4'h6: data <= 8'b00111100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '1' (0x31)
            7'h31: case(addr[3:0])
                4'h0: data <= 8'b00011000;
                4'h1: data <= 8'b00111000;
                4'h2: data <= 8'b00011000;
                4'h3: data <= 8'b00011000;
                4'h4: data <= 8'b00011000;
                4'h5: data <= 8'b00011000;
                4'h6: data <= 8'b01111110;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '2' (0x32)
            7'h32: case(addr[3:0])
                4'h0: data <= 8'b00111100;
                4'h1: data <= 8'b01100110;
                4'h2: data <= 8'b00000110;
                4'h3: data <= 8'b00001100;
                4'h4: data <= 8'b00011000;
                4'h5: data <= 8'b00110000;
                4'h6: data <= 8'b01111110;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '3' (0x33)
            7'h33: case(addr[3:0])
                4'h0: data <= 8'b00111100;
                4'h1: data <= 8'b01100110;
                4'h2: data <= 8'b00000110;
                4'h3: data <= 8'b00011100;
                4'h4: data <= 8'b00000110;
                4'h5: data <= 8'b01100110;
                4'h6: data <= 8'b00111100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '4' (0x34)
            7'h34: case(addr[3:0])
                4'h0: data <= 8'b00001100;
                4'h1: data <= 8'b00011100;
                4'h2: data <= 8'b00111100;
                4'h3: data <= 8'b01101100;
                4'h4: data <= 8'b01111110;
                4'h5: data <= 8'b00001100;
                4'h6: data <= 8'b00001100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '5' (0x35)
            7'h35: case(addr[3:0])
                4'h0: data <= 8'b01111110;
                4'h1: data <= 8'b01100000;
                4'h2: data <= 8'b01111100;
                4'h3: data <= 8'b00000110;
                4'h4: data <= 8'b00000110;
                4'h5: data <= 8'b01100110;
                4'h6: data <= 8'b00111100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '6' (0x36)
            7'h36: case(addr[3:0])
                4'h0: data <= 8'b00111100;
                4'h1: data <= 8'b01100000;
                4'h2: data <= 8'b01111100;
                4'h3: data <= 8'b01100110;
                4'h4: data <= 8'b01100110;
                4'h5: data <= 8'b01100110;
                4'h6: data <= 8'b00111100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '7' (0x37)
            7'h37: case(addr[3:0])
                4'h0: data <= 8'b01111110;
                4'h1: data <= 8'b00000110;
                4'h2: data <= 8'b00001100;
                4'h3: data <= 8'b00011000;
                4'h4: data <= 8'b00110000;
                4'h5: data <= 8'b00110000;
                4'h6: data <= 8'b00110000;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '8' (0x38)
            7'h38: case(addr[3:0])
                4'h0: data <= 8'b00111100;
                4'h1: data <= 8'b01100110;
                4'h2: data <= 8'b01100110;
                4'h3: data <= 8'b00111100;
                4'h4: data <= 8'b01100110;
                4'h5: data <= 8'b01100110;
                4'h6: data <= 8'b00111100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII '9' (0x39)
            7'h39: case(addr[3:0])
                4'h0: data <= 8'b00111100;
                4'h1: data <= 8'b01100110;
                4'h2: data <= 8'b01100110;
                4'h3: data <= 8'b00111110;
                4'h4: data <= 8'b00000110;
                4'h5: data <= 8'b00001100;
                4'h6: data <= 8'b00111100;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            // ASCII ':' (0x3a) - Colon
            7'h3a: case(addr[3:0])
                4'h0: data <= 8'b00000000;
                4'h1: data <= 8'b00000000;
                4'h2: data <= 8'b00011000;
                4'h3: data <= 8'b00011000;
                4'h4: data <= 8'b00000000;
                4'h5: data <= 8'b00011000;
                4'h6: data <= 8'b00011000;
                4'h7: data <= 8'b00000000;
                4'h8: data <= 8'b00000000;
                4'h9: data <= 8'b00000000;
                4'ha: data <= 8'b00000000;
                4'hb: data <= 8'b00000000;
                4'hc: data <= 8'b00000000;
                4'hd: data <= 8'b00000000;
                4'he: data <= 8'b00000000;
                4'hf: data <= 8'b00000000;
            endcase
            
            default: data <= 8'b00000000;
        endcase
    end

endmodule