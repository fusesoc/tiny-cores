module piso_harness #(
    parameter WIDTH = 42,
    parameter EXTRA_BITS = 9,
    parameter RAND_DELAY = 1
)
();

    localparam CLK_PERIOD = 2*5;
    localparam Thold = 2;
    localparam WAIT_MIN = 5;
    localparam WAIT_MAX = 21;

    reg sysclk, load;
    reg [WIDTH-1:0] data_in;
    wire data_out;

    integer count;

    piso #(
        .WIDTH(WIDTH),
        .EXTRA_BITS(EXTRA_BITS)
    ) sr (
        .clk(sysclk),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Initialisation and clock generation
    initial
    begin
        count <= 0;
        load <= 1'b0;
        data_in <= {WIDTH{1'bX}};
    
        sysclk <= 1'b0;
        forever #(CLK_PERIOD/2) sysclk = ~sysclk;
    end

    task load_reg(input [WIDTH-1:0] v);
        begin
            load <= 1'b1;
            data_in <= v;
            @(posedge sysclk) #(Thold);
            load <= 1'b0;
            data_in <= {WIDTH{1'bX}};
        end
    endtask

    task pause(input integer cycles);
    begin
        repeat (cycles) @(posedge sysclk) #(Thold);
    end
    endtask

    always @(posedge sysclk)
    begin
        if (load === 1'b1)
            count <= WIDTH+EXTRA_BITS;
        else
            if (count != 0) count <= count - 1;
    end

    task get_bits(output integer c);
    begin
        c = count;
    end
    endtask

    task get_reg(output [WIDTH-1:0] r);

        integer b;

        begin
            repeat(EXTRA_BITS)
                @(posedge sysclk) #(CLK_PERIOD-1);

            for(b=WIDTH-1; b >= 0; b=b-1)
            begin
                @(posedge sysclk) #(CLK_PERIOD-1);
                r[b] = data_out;
            end
        end
    endtask

endmodule
