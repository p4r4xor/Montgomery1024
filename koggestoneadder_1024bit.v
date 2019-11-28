`timescale 1ns / 1ps

module adder(
    input wire clk,
    input wire resetn,
    input wire start,
    input wire subtract,
    input wire shift,
    input wire [1024:0] in_a,
    input wire [1024:0] in_b,    
    output wire [1025:0] result,
    output wire done    
    );

reg[1024:0] a, b;
reg c, d;
reg [1229:0] s;
reg [3:0]cntr;
wire [205:0] reg_result;
assign reg_result = a[204:0] + b[204:0] + c;
reg[1:0]state;

always @(posedge clk)
    begin
    if (resetn == 0) 
        begin
            a <= 0;
            b <= 0;
            c <= 0;
            cntr <= 0;
            d <= 0;
            s<=0;
            state<=2'b00;
         end
     else
     begin
     
     case(state)
          //Idle state
          2'b00: begin
            a <= in_a;
            c<=subtract;
            cntr <= 0;
            d <= 0;
            if (subtract==1)
                 begin
                 b<=~in_b;
                 end
            else
                 begin
                 b <= in_b;
                 end
            state[0] <= start;
          end
          //calculate state
          2'b01: begin
              cntr<=cntr+1;
              s <= {reg_result[204:0], s[1229:205]};
              c<=reg_result[205];
              a <= a>>205;
              b <= b>>205; 
              if(cntr==5)
                   begin
                  state<=2'b10;
                 end
              else
                  begin
                  state<=2'b01;
                  end
              end
          //latest bit state
          2'b10: begin
            s[1025]<=s[1025] ^ subtract;
            d<=1'b1;
            state<=2'b00;
            end
          endcase
       end
     end  
       
assign result = s[1025:0];
assign done = d;
endmodule