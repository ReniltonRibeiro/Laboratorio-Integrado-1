module Robo (clock, reset, head, left, avancar, girar);

output reg avancar, girar;
input head, left, clock, reset;

reg [0:1] act_state, next_state;
reg clock_counter;

parameter search_wall = 2'b00;
parameter rotate = 2'b01;
parameter follow_wall = 2'b10;

always @(head or left or act_state)
begin
    case (act_state)
        search_wall:
            case ({head, left})
            2'b00:
                begin
                    next_state = search_wall;
                    avancar = 1;
                    girar = 0;
                end
            2'b01:
                begin
                    next_state = follow_wall;
                    avancar = 1;
                    girar = 0;
                end
            2'b10:
                begin
                    next_state = rotate;
                    avancar = 0;
                    girar = 1;
                end
            2'b11:
                begin
                    next_state = rotate;
                    avancar = 0;
                    girar = 1;
                end
            endcase
        rotate:
            case ({head, left})
            2'b00:
                begin
                    next_state = rotate;
                    avancar = 0;
                    girar = 1;
                end
            2'b01:
                begin
                    next_state = follow_wall;
                    avancar = 1;
                    girar = 0;
                end
            2'b10:
                begin
                    next_state = rotate;
                    avancar = 0;
                    girar = 1;
                end
            2'b11:
                begin
                    next_state = rotate;
                    avancar = 0;
                    girar = 1;
                end
            endcase

        follow_wall:
            case ({head, left})
            2'b00:
                begin
                    next_state = search_wall;
                    avancar = 0;
                    girar = 1;
                end
            2'b01:
                begin
                    next_state = follow_wall;
                    avancar = 1;
                    girar = 0;
                end
            2'b10:
                begin
                    next_state = search_wall;
                    avancar = 0;
                    girar = 1;
                end
            2'b11:
                begin
                    next_state = rotate;
                    avancar = 0;
                    girar = 1;
                end
            endcase
        default:
            begin
            next_state = search_wall;
            avancar = 1;
            girar = 0;
            end
    endcase
end

always @(negedge clock or posedge reset)
begin
    if (reset)
        case ({head, left})
        2'b00:
        begin
            act_state <= search_wall;
            clock_counter <= 2'b0;
        end
        2'b01:
        begin
            act_state <= follow_wall;
            clock_counter <= 2'b0;
        end
        2'b10:
        begin
            act_state <= rotate;
            clock_counter <= 2'b0;
        end
        2'b11:
        begin
            act_state <= rotate;
            clock_counter <= 2'b0;
        end
        endcase
    else
        case (clock_counter)
        2'b0:
            begin
                act_state <= next_state;
                clock_counter <= 2'b1;
            end
        2'b1:
            begin
                clock_counter <= 2'b0;
            end
        endcase
end

endmodule