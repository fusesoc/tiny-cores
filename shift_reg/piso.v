`timescale 1ns / 1ps

// Parallel in, serial out shift register
//
// Loads a new parallel input when the load input is high. Otherwise the
// parallel data is shifted out of the serial data_out output

// Disable shift register inferrence since this core is usually used for
// moving data from the output of an IP core to a device pin
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *)
(* shreg_extract = "no" *)
module piso #(
    // Number of input bits
    parameter WIDTH      = 50,
    // Number of extra registers between the input and serial output
    parameter EXTRA_BITS = 25
)
(
    input              clk,
    input              load,
    input  [WIDTH-1:0] data_in,
    output             data_out
);
    // Check parameter values, though in most cases the tool will fail
    // elaboration and not get this far
    initial
    begin
        if ((WIDTH < 1) || (EXTRA_BITS < 0)) begin
            $display("Illegal parameter values WIDTH=%d, EXTRA_BITS=%d", WIDTH, EXTRA_BITS);
            $finish();
        end
    end

    localparam SR_WIDTH = WIDTH+EXTRA_BITS;

    reg [SR_WIDTH-1:0] data;

    assign data_out = data[SR_WIDTH-1];

    always @(posedge clk) begin
        if(load)
	        data[WIDTH-1:0] <= data_in;
        else if (SR_WIDTH > 1)
	        data <= {data[SR_WIDTH-2:0], 1'b0};
    end

endmodule
