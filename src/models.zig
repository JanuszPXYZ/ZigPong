const rl = @import("raylib");
const rlm = @import("raylib").math;

/// Ball object
pub const Ball = struct {
    position: rl.Vector2,
    radius: f32,
    speed: rl.Vector2,

    pub fn init(centerX: f32, centerY: f32, radius: f32, speed: f32) Ball {
        return Ball{
            .position = rl.Vector2.init(centerX, centerY),
            .radius = radius,
            .speed = rl.Vector2.init(speed, speed),
        };
    }

    pub fn update(self: *Ball, screenHeight: f32, screenWidth: f32) void {
        self.position = rlm.vector2Add(self.position, self.speed);

        // check for y collisions
        if (self.position.y - self.radius <= 0 or self.position.y + self.radius >= screenHeight) {
            self.speed.y *= -1;
        }

        if (self.position.x - self.radius <= 0 or self.position.x + self.radius >= screenWidth) {
            self.speed.x *= -1;
        }
    }

    pub fn draw(self: *Ball) void {
        rl.drawCircle(@as(i32, @intFromFloat(self.position.x)), @as(i32, @intFromFloat(self.position.y)), self.radius, rl.Color.red);
    }
};

/// Paddle object
pub const Paddle = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,

    pub fn init(x: f32, y: f32, width: f32, height: f32, color: rl.Color) Paddle {
        return Paddle{
            .position = rl.Vector2.init(x, y),
            .size = rl.Vector2.init(width, height),
            .color = color,
        };
    }

    pub fn move(self: *Paddle, screenHeight: f32) void {
        if (rl.isKeyDown(rl.KeyboardKey.key_s) and self.position.y + self.size.y <= screenHeight) {
            self.position.y += 8;
        }
        if (rl.isKeyDown(rl.KeyboardKey.key_w) and self.position.y >= 0) {
            self.position.y -= 8;
        }
    }

    pub fn draw(self: *Paddle) void {
        rl.drawRectangleV(self.position, self.size, self.color);
    }
};
