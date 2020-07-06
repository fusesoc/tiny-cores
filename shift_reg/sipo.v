`timescale 1ns / 1ps

// Serial in, parallel out shift register
//
// Loads new serial input bits when the load input is high. The parallel
// (WIDTH bits) data_out output can be connected to the inputs of an IP core

// Disable shift register inferrence since this core is usually used for
// moving data from an input pin to an IP core
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *)
(* shreg_extract = "no" *)
module sipo #(
    // Number of output bits
    parameter WIDTH = 500
)
(
    input                  clk,
    input                  load,
    input                  data_in,
    output reg [WIDTH-1:0] data_out
);
    // Check parameter value, though in most cases the tool will fail
    // elaboration and not get this far
    initial
    begin
        if (WIDTH < 1) begin
            $display("Illegal parameter value WIDTH=%d", WIDTH);
            $finish();
        end
    end

    // This is excessive code to handle a silly case, but it's hard to make
    // multiple tools happy!

    generate
        if (WIDTH == 1)
            always @(posedge clk) begin
                if(load)
                    data_out <= data_in;
            end
        else
            always @(posedge clk) begin
                if(load)
                    data_out <= {data_out[0 +: WIDTH-1], data_in};
            end
    endgenerate

endmodule
