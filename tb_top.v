`timescale 1ns/1ps

module tb_top;

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 3;

  reg clk, rstn, s, wrin;
  reg [DATA_WIDTH-1:0] datain;
  reg [ADDR_WIDTH-1:0] Radd;
  integer i;
  // Instantiate the module
  top #(DATA_WIDTH, ADDR_WIDTH) DUT (
    .clk(clk),
    .rstn(rstn),
    .s(s),
    .done(done),
    .Radd(Radd),
    .datain(datain),
    .wrin(wrin)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $display("Starting Simulation...");
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_top);

    clk = 0;
    rstn = 0;
    s = 0;
    wrin = 0;
    datain = 0;
    Radd = 0;

    // Reset
    #10 rstn = 1;

    // Write values into RAM (example: write to 4 addresses)
    wrin = 1;
    for ( i = 0; i < 4; i = i + 1) begin
      datain = 8'hA0 + i;
      Radd = i;
      #10;
    end
    wrin = 0;
    datain = 0;
    Radd = 0;

    // Trigger internal operation
    #10 s = 1;

    // Wait until done
    wait (done);
    #40 s = 0;

    #20;
    $display("Simulation Done.");
    $stop;
  end

endmodule
