module test_piso_random #(
    parameter NUM_VECTORS = 100,
    parameter WIDTH = 42,
    parameter EXTRA_BITS = 3
)
();

piso_harness #(.WIDTH(WIDTH), .EXTRA_BITS(EXTRA_BITS)) uut ();

reg [WIDTH-1:0] expected, actual;

integer success_count, failure_count;

task rand_vector(output [WIDTH-1:0] v);

    integer i;

    begin
        for (i=0; i < WIDTH; i=i+32) v[i +: 32] = $random;
    end
endtask

initial
begin

    success_count = 0;
    failure_count = 0;

    $display("Beginning simulation");

    uut.pause(7);

    repeat (NUM_VECTORS)
    begin
        uut.pause($urandom_range(10, 0));
        rand_vector(expected);

        fork
            uut.load_reg(expected);
            uut.get_reg(actual);
        join

        if (actual === expected)
        begin
            success_count = success_count + 1;
        end else begin
            $display("FAILURE. Expected %h but got %h.", expected, actual);
            failure_count = failure_count + 1;
        end
    end

    $display("Finished simulation with %d successful and %d failing vectors", success_count, failure_count);
    $finish;
end

endmodule
