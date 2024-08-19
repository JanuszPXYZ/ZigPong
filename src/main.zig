// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const rlm = @import("raylib").math;
const models = @import("./models.zig");

const screenWidth = 800;
const screenHeight = 450;

pub fn main() anyerror!void {
    var ball = models.Ball.init(0, 0, 20, 4);
    ball.position = .{
        .x = ball.position.x + ball.radius,
        .y = ball.position.y + ball.radius,
    };

    // var paddle = models.Paddle.init(0, 0, 20, 6, rl.Color.blue);

    rl.initWindow(screenWidth, screenHeight, "ZigPong");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);

        //paddle.draw();
        //paddle.move(screenHeight);
        //rl.drawCircle(20, 20, 20, rl.Color.red);

        ball.update(screenHeight, screenWidth);
        ball.draw();
    }
}
