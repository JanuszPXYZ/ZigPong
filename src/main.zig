// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const rlm = @import("raylib").math;
const models = @import("./models.zig");

const screenWidth = 800;
const screenHeight = 450;

pub fn main() anyerror!void {
    var paddleOne = models.Paddle.init(0, 0, 20, 80, rl.Color.blue, .Left);
    var paddleTwo = models.Paddle.init(screenWidth - 20, 0, 20, 80, rl.Color.green, .Right);

    var ball = models.Ball.init(screenWidth / 2, screenHeight / 2, 20, 4, &paddleOne, &paddleTwo);
    ball.position = .{
        .x = ball.position.x + ball.radius,
        .y = ball.position.y + ball.radius,
    };
    rl.initWindow(screenWidth, screenHeight, "ZigPong");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);

        paddleOne.draw();
        paddleOne.move(screenHeight);

        paddleTwo.draw();
        paddleTwo.move(screenHeight);

        ball.update(screenHeight, screenWidth);
        ball.draw();
    }
}
