module cpu_testtop;

    logic clk, rst;
    logic [17:0] io0;
    logic [31:0] hexes_loc;
    logic [31:0] result;

    always begin
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
    end

    initial begin
        rst = 1'b1;
        #30;
        rst = 1'b0;
        #5;
    end


    cpu dut(.clk(clk), .rst(rst), .io0(io0), .result(result), .hexes(hexes_loc));

    always @(posedge clk) begin
        $display("result=%0b", result);
    end
endmodule