module sipo_harness #(
    parameter WIDTH = 42,
    parameter RAND_DELAY = 1
)
();

    localparam CLK_PERIOD = 2*5;
    localparam Thold = 2;
    localparam WAIT_MIN = 5;
    localparam WAIT_MAX = 21;

    reg sysclk, load, data_in;
    wire [WIDTH-1:0] data_out;

    integer count;

    sipo #(
        .WIDTH(WIDTH)
    ) sr (
        .clk(sysclk),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    initial
    begin
        sysclk <= 1'b0;
        forever #(CLK_PERIOD/2) sysclk = ~sysclk;
    end

    initial
    begin
        count <= 0;
        load <= 1'b0;
        data_in <= 1'bX;
    end

    task load_bit(input b);
        begin
            // Wait a random number of cycles
            if (RAND_DELAY)
                repeat ($urandom_range(WAIT_MAX, WAIT_MIN))
                    @(posedge sysclk);

            #(Thold);
            load <= 1'b1;
            data_in <= b;
            @(posedge sysclk) #Thold;
            load <= 1'b0;
            data_in <= 1'bX;
        end
    endtask

    task load_reg(input [WIDTH-1:0] v);

        integer b;

        begin

            for(b=WIDTH-1; b >= 0; b=b-1)
            begin
                load_bit(v[b]);
            end
        end
    endtask

    task pause(input integer cycles);
    begin
        repeat (cycles) @(posedge sysclk);
    end
    endtask

    always @(posedge sysclk)
    begin
        if (load === 1'b1)
            if (count === WIDTH-1)
                count <= 0;
            else
                count <= count + 1;
    end

    task get_bits(output integer c);
    begin
        c = count;
    end
    endtask

    task get_reg(output [WIDTH-1:0] r);
        begin
            @(posedge sysclk) #(CLK_PERIOD-1);
            r = data_out;
        end
    endtask

endmodule
