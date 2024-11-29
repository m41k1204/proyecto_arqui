`timescale 1ns/1ns

module testbench;
    reg internal_clk;
    reg real_clk;
    reg [15:0] ResultW;  // Input for the ResultW signal
    wire [6:0] out0;     // Output for 7-segment display
    wire [3:0] enable;   // Enable signals for 7-segment display

    // Instantiate the basysdecoder module
    basysdecoder dut(
        .internal_clk(internal_clk),
        .real_clk(real_clk),
        .ResultW(ResultW),
        .out0(out0),
        .enable(enable)
    );

    // Initialize clocks and signals
    initial begin
        // Initialize signals
        internal_clk = 0;
        real_clk = 0;
        ResultW = 16'b0000000000000000;  // Start with zero data

        // Apply reset (if necessary) or initialization for the FSM
        // In your original code, there's no reset logic for basysdecoder, 
        // so no reset is applied here
        // Example of a reset sequence (if needed):
        // reset <= 1;
        // #10;
        // reset <= 0;
    end

    // Generate internal_clk (simulating a 50MHz clock or other rate)
    always begin
        internal_clk = 1;
        #5;
        internal_clk = 0;
        #5;
    end

    // Generate real_clk (another clock signal)
    always begin
        real_clk = 1;
        #10;
        real_clk = 0;
        #10;
    end

    // Apply test vectors to ResultW and observe FSM outputs
    initial begin
        // Wait for a few clock cycles for initialization
        #50;

        // Apply a test value to ResultW
        // This will trigger the FSM and determine the displayed digit
        ResultW = 16'h1234;  // Test input value (this will be used for the FSM's display logic)
        #100; // Wait to observe the outputs
        
        // Test another ResultW value
        ResultW = 16'h5678;  // Another input value to see the changes in the FSM outputs
        #100; // Wait to observe the outputs

        // Test a different ResultW value
        ResultW = 16'h9ABC;  // Different value for further state transitions
        #100; // Wait to observe the outputs
        
        // Finish the simulation after a few cycles
        $finish;
    end

    // Monitor outputs for debugging purposes
    initial begin
        $monitor("Time: %t, State: %b, out0: %b, enable: %b", $time, dut.state, out0, enable);
    end

endmodule
