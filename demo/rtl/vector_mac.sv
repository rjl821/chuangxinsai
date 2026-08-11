`timescale 1ns/1ps

// ============================================================================
// Module: vector_mac
// Function: calculate the signed dot product sum(a[i] * b[i]).
//
// Why this demo is useful:
//   FFT, SpMV, filters, neural-network operators and many contest accelerators
//   all contain a similar "accept a task -> stream data -> return a result"
//   skeleton.  The arithmetic here is intentionally small, while the control
//   path is complete enough to demonstrate simulation, lint and synthesis.
//
// [REPLACE] When adapting this demo:
//   1. Replace the product/accumulate expression with the target algorithm.
//   2. Change DATA_W/ACC_W/LEN_W according to numerical error analysis.
//   3. Keep the ready/valid rule: a transfer occurs only when both are 1.
//   4. If a RAM or vendor IP is added, append its RTL/model to the filelist and
//      its .db library to EXTRA_LINK_LIBS in the Makefile.
// ============================================================================
module vector_mac #(
    parameter int DATA_W = vector_mac_params_pkg::VECTOR_MAC_DATA_W,
    // For N products, a conservative accumulator width is
    // 2*DATA_W + ceil(log2(N)).  The default 40 bits covers up to 256 pairs.
    parameter int ACC_W  = vector_mac_params_pkg::VECTOR_MAC_ACC_W,
    parameter int LEN_W  = vector_mac_params_pkg::VECTOR_MAC_LEN_W
) (
    input  logic                         clk,
    input  logic                         rst_n,

    // Command channel. start is accepted only while start_ready is high.
    // length=0 is legal and returns zero without accepting input pairs.
    input  logic                         start,
    input  logic [LEN_W:0]               length,
    output logic                         start_ready,

    // Input stream. a_data and b_data are two's-complement signed values.
    input  logic signed [DATA_W-1:0]     a_data,
    input  logic signed [DATA_W-1:0]     b_data,
    input  logic                         in_valid,
    output logic                         in_ready,

    // Result channel. y_data remains stable while y_valid=1 and y_ready=0.
    output logic signed [ACC_W-1:0]      y_data,
    output logic                         y_valid,
    input  logic                         y_ready,

    // busy covers both data collection and waiting for result acceptance.
    output logic                         busy
);

    localparam int PROD_W = 2 * DATA_W;

    typedef enum logic [1:0] {
        ST_IDLE,   // Wait for a command.
        ST_RUN,    // Accept exactly "length" input pairs.
        ST_RESULT  // Hold the completed result until y_ready.
    } state_t;

    state_t state_q, state_d;
    logic [LEN_W:0] remaining_q, remaining_d;
    logic signed [ACC_W-1:0] accumulator_q, accumulator_d;
    logic signed [PROD_W-1:0] product;
    logic signed [ACC_W-1:0] product_extended;

    // Multiplication is combinational in this teaching example.  At a high
    // target frequency, [REPLACE] this with a pipelined multiplier or DSP IP,
    // and delay valid/last metadata by the same number of stages.
    assign product = a_data * b_data;

    // Explicit sign extension prevents accidental unsigned arithmetic and
    // makes the intended width visible to lint and synthesis tools.
    assign product_extended = $signed(
        {{(ACC_W-PROD_W){product[PROD_W-1]}}, product}
    );

    always_comb begin
        start_ready = (state_q == ST_IDLE);
        in_ready    = (state_q == ST_RUN);
        y_valid     = (state_q == ST_RESULT);
        busy        = (state_q != ST_IDLE);
        y_data      = accumulator_q;
    end

    // Next-state logic is kept separate from the state registers. This style
    // makes every hold/update explicit and is recognized cleanly by lint tools.
    always_comb begin
        state_d       = state_q;
        remaining_d   = remaining_q;
        accumulator_d = accumulator_q;

        unique case (state_q)
            ST_IDLE: begin
                if (start) begin
                    accumulator_d = '0;
                    remaining_d   = length;
                    // A zero-length task has a mathematically defined result
                    // of zero and therefore needs no input beat.
                    state_d = (length == '0) ? ST_RESULT : ST_RUN;
                end
            end

            ST_RUN: begin
                if (in_valid && in_ready) begin
                    accumulator_d = accumulator_q + product_extended;
                    remaining_d   = remaining_q - 1'b1;
                    // remaining_q is the count including this transfer.
                    if (remaining_q == {{LEN_W{1'b0}}, 1'b1}) begin
                        state_d = ST_RESULT;
                    end
                end
            end

            ST_RESULT: begin
                if (y_ready) begin
                    state_d = ST_IDLE;
                end
            end

            default: begin
                // Defensive recovery for X injection or an SEU. This is not
                // expected in normal RTL simulation.
                state_d       = ST_IDLE;
                remaining_d   = '0;
                accumulator_d = '0;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q       <= ST_IDLE;
            remaining_q   <= '0;
            accumulator_q <= '0;
        end else begin
            state_q       <= state_d;
            remaining_q   <= remaining_d;
            accumulator_q <= accumulator_d;
        end
    end

`ifndef SYNTHESIS
    // Parameter failures are reported at time zero instead of becoming a
    // cryptic negative-replication error later in elaboration.
    initial begin
        if (ACC_W < PROD_W) begin
            $fatal(1, "ACC_W (%0d) must be >= 2*DATA_W (%0d)", ACC_W, PROD_W);
        end
    end
`endif

endmodule
