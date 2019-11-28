`timescale 1ns / 1ps

module montgomery(
    input clk,
    input resetn,
    input start,
    input [1023:0] in_a,
    input [1023:0] in_b,
    input [1023:0] in_m,
    output [1023:0] result,    
    output done
     );
 
    reg [1023:0] A, B, M, add_a, add_b;
    reg [10:0] n;
    reg [1025:0] r_result, C, D;
    reg d, subtract, add_start;
    reg [2:0]state;
    wire [1024:0] a, b;
    wire [1025:0] add_result;
    wire add_done, shift;
    assign shift = 0;
    
    adder dut
       (.in_a(a),
        .in_b(b),
        .subtract(subtract),
        .start(add_start),
        .result(add_result),
        .done(add_done),
        .clk(clk),
        .resetn(resetn),
        .shift(shift)
        );
    
    always @(posedge(clk))
        begin
        if (resetn == 0)
            begin
            A <= 0;
            B <= 0;
            M <= 0;
            C <= 0;
            D <= 0;
            d <= 0;
            n <= 1024;
            r_result <= 0;
            subtract<=0;
            add_start<=0;
            add_a <= 0;
            add_b <= 0;
            state<=0;
            end
        else
            begin
              case(state)
                3'b000:begin//RESET
                    A <= in_a;
                    B <= in_b;
                    M <= in_m;
                    C <= 0;
                    D <= 0;
                    r_result <= r_result;
                    n <= 1024;
                    d <= 0;
                    if (start == 1)
                        begin
                        state<=3'b001;
                        end
                    else
                        begin
                        state <= 3'b000;
                        end
                        
                    end
                3'b001:begin//START
                    if (n == 0)
                        begin
                        state <= 3'b101;
                        end
                    else
                        begin 
                        if (A[1023-(n-1)] == 1)
                            begin
                            add_a <= C;
                            add_b <= B;
                            subtract <= 0;
                            add_start <= 1;
                            state <= 3'b010;
                            end
                        else
                            begin
                            C <= C;
                            state <= 3'b011;
                            end
                        end
                    end
                3'b010:begin//WAIT
                    add_start <= 0;
                    if (add_done == 1)
                        begin
                        C <= add_result;
                        state<=3'b011;
                        end
                    else
                        begin
                        C <= C;
                        state<= 3'b010;
                        end
                    end
                3'b011:begin//C Check
                    n <= n-1;
                    begin
                    if (C[0] == 0)
                        begin
                        C <= C >> 1;
                        state <= 3'b001;
                        end
                    else
                        begin
                        add_a <= C;
                        add_b <= M;
                        subtract <= 0;
                        add_start <= 1;
                        state <= 3'b100;
                        end
                    end
                    end
                3'b100:begin//WAIT
                    add_start <= 0;
                    if (add_done == 1)
                        begin
                        C <= add_result >> 1;
                        state <= 3'b001;
                        end
                    else
                        begin
                        C <= C;
                        state<= 3'b100;
                        end
                    end
                3'b101: begin //subtract
                    add_a <= C;
                    add_b <= M;
                    subtract <= 1;
                    add_start <= 1;
                    state <= 3'b110;
                    end
                3'b110:begin//WAIT
                    add_start <= 0;
                    if (add_done == 1)
                        begin
                        D <= add_result;
                        state <= 3'b111;
                        end
                    else
                        begin
                        D <= D;
                        state<= 3'b110;
                        end
                    end
                3'b111:begin //C
                    if (D[1025] == 0)
                        begin
                        r_result <= add_result;
                        end
                    else
                        begin
                        r_result <= C;
                        end
                    d <= 1;
                    state <= 3'b000;
                    end
                endcase
            end
        end
           
assign result = r_result[1023:0];
assign a = add_a;
assign b = add_b;
assign done = d;
endmodule