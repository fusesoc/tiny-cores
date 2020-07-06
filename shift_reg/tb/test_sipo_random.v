module test_sipo_random #(
    parameter NUM_VECTORS = 100,
    parameter WIDTH = 23
)
();

sipo_harness #(.WIDTH(WIDTH)) uut ();

reg [WIDTH-1:0] expected, actual;

integer success_count, failure_count;

initial
begin
    success_count = 0;
    failure_count = 0;

    $display("Beginning simulation");

    repeat (NUM_VECTORS)
    begin
        expected = $random;
        uut.load_reg(expected);
        uut.pause($urandom_range(10, 0));
        uut.get_reg(actual);

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
