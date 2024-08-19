// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const rlm = @import("raylib").math;

const screenWidth = 800;
const screenHeight = 450;

const RealBall = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    speed: rl.Vector2,
};

const Ball = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    speed: rl.Vector2,

    pub fn init(x: f32, y: f32, size: f32, speed: f32) Ball {
        return Ball{
            .position = rl.Vector2.init(x, y),
            .size = rl.Vector2.init(size, size),
            .speed = rl.Vector2.init(speed, speed),
        };
    }

    pub fn update(self: *Ball) void {
        self.position = rlm.vector2Add(self.position, self.speed);

        // check for y collisions
        if (self.position.y <= 0 or self.position.y + self.size.y >= screenHeight) {
            // Invert the 'direction' of the ball
            self.speed.y *= -1;
        }

        // check for x collisions
        if (self.position.x <= 0 or self.position.x + self.size.x >= screenWidth) {
            self.speed.x *= -1;
        }
    }

    pub fn draw(self: *Ball) void {
        rl.drawRectangleV(self.position, self.size, rl.Color.red);
    }
};

pub fn main() anyerror!void {
    //var ball = Ball.init(0, 0, 32, 4);

    rl.initWindow(screenWidth, screenHeight, "ZigPong");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);
        rl.drawCircle(20, 20, 20, rl.Color.red);

        // ball.update();
        // ball.draw();
    }
}
