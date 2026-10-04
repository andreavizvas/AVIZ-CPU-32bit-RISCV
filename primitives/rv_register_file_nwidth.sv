// Name: rv_register_file_nwidth
// Date: August 10th, 2026
// Description: N-width register, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Wed August 19 2026, 11:17:47, Miami FL, United States

module rv_register_file_nwidth #(
    parameter REG_WIDTH  = 32,
    parameter NUM_REG    = 32,
    parameter ADDR_WIDTH = $clog2(REG_WIDTH)
)(
    input  logic                  CLK,        // all signals active-high
    input  logic                  RESET,
    input  logic                  WRITE_EN,
    input  logic [ADDR_WIDTH-1:0] READ_ADDR1,
    input  logic [ADDR_WIDTH-1:0] READ_ADDR2,
    input  logic [ADDR_WIDTH-1:0] WRITE_ADDR,
    input  logic [REG_WIDTH-1:0]  WRITE_DATA,

    output logic [REG_WIDTH-1:0]  READ_DATA1,
    output logic [REG_WIDTH-1:0]  READ_DATA2,
);
    logic [REG_WIDTH-1:0] REGISTERS [0:NUM_REG-1];  // width of each register, no. of registers in array
    integer i;

always_ff @(posedge CLK) begin
    if (RESET) begin
        for (i = 0; i < NUM_REG; i++)
            REGISTERS[0:NUM_REG-1] <= '0;
    end
    else if (WRITE_EN && (WRITE_ADDR != '0)) begin
        REGISTERS[WRITE_ADDR] <= WRITE_DATA;
    end
end

always_comb begin
    if (READ_ADDR1 == '0) begin
        READ_DATA1 = '0
    end
    else
        READ_DATA1 = REGISTERS[READ_ADDR1];

    if (READ_ADDR2 == '0) begin
        READ_DATA2 = '0
    end
    else
        READ_DATA2 = REGISTERS[READ_ADDR2];
end
endmodule