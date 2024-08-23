const rl = @import("raylib");
const rlm = @import("raylib").math;
const std = @import("std");
/// Ball object
pub const Ball = struct {
    position: rl.Vector2,
    radius: f32,
    speed: rl.Vector2,
    paddleLeft: *Paddle,
    paddleRight: *Paddle,

    pub fn init(centerX: f32, centerY: f32, radius: f32, speed: f32, paddleLeft: *Paddle, paddleRight: *Paddle) Ball {
        return Ball{
            .position = rl.Vector2.init(centerX, centerY),
            .radius = radius,
            .speed = rl.Vector2.init(speed, speed),
            .paddleLeft = paddleLeft,
            .paddleRight = paddleRight,
        };
    }

    pub fn update(self: *Ball, screenHeight: f32, screenWidth: f32) void {
        var prng = std.rand.DefaultPrng.init(blk: {
            var seed: u64 = undefined;
            std.posix.getrandom(std.mem.asBytes(&seed)) catch |err| {
                std.debug.print("Error getting random seed: {}\n", .{err});
            };
            break :blk seed;
        });
        var rand = prng.random();

        // Update position
        self.position = rlm.vector2Add(self.position, self.speed);

        // Check for top and bottom collisions
        if (self.position.y - self.radius <= 0 or self.position.y + self.radius >= screenHeight) {
            self.speed.y *= -1;
            // Add a small angle change for variety
            const angle = (rand.float(f32) * 5 - 2.5) * std.math.pi / 180.0;
            self.speed = rlm.vector2Rotate(self.speed, angle);
        }

        // Check for paddle collisions
        if (self.speed.x < 0 and self.position.x - self.radius <= self.paddleLeft.position.x + self.paddleLeft.size.x and
            self.position.y >= self.paddleLeft.position.y and self.position.y <= self.paddleLeft.position.y + self.paddleLeft.size.y)
        {
            self.handlePaddleCollision(self.paddleLeft);
        } else if (self.speed.x > 0 and self.position.x + self.radius >= self.paddleRight.position.x and
            self.position.y >= self.paddleRight.position.y and self.position.y <= self.paddleRight.position.y + self.paddleRight.size.y)
        {
            self.handlePaddleCollision(self.paddleRight);
        }

        // Check for scoring (ball goes past paddle)
        if (self.position.x < 0 or self.position.x > screenWidth) {
            // Reset ball position and randomize direction
            self.position = rl.Vector2.init(screenWidth / 2, screenHeight / 2);
            const randomAngle = (prng.random().float(f32) * 360) * std.math.pi / 180.0;
            self.speed = rlm.vector2Rotate(rl.Vector2.init(5, 0), randomAngle);
        }
    }

    fn handlePaddleCollision(self: *Ball, paddle: *Paddle) void {
        // Reverse horizontal direction
        self.speed.x *= -1;

        // Calculate relative impact point
        const paddleCenter = paddle.position.y + (paddle.size.y / 2);
        const relativeIntersectY = self.position.y - paddleCenter;
        const normalizedRelativeIntersectionY = relativeIntersectY / (paddle.size.y / 2);
        const bounceAngle = -normalizedRelativeIntersectionY * (std.math.pi / 4.0); // Max angle: 45 degrees

        // Calculate new velocity
        const speed = rlm.vector2Length(self.speed);
        self.speed.x = speed * std.math.cos(bounceAngle) * std.math.sign(self.speed.x);
        self.speed.y = speed * -std.math.sin(bounceAngle);

        // Increase speed slightly
        self.speed = rlm.vector2Scale(self.speed, 1.05);
    }

    pub fn draw(self: *Ball) void {
        rl.drawCircle(@as(i32, @intFromFloat(self.position.x)), @as(i32, @intFromFloat(self.position.y)), self.radius, rl.Color.red);
    }
};

pub const PlayerType = enum { Left, Right };

/// Paddle object
pub const Paddle = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
    player_type: PlayerType,

    pub fn init(x: f32, y: f32, width: f32, height: f32, color: rl.Color, player_type: PlayerType) Paddle {
        return Paddle{
            .position = rl.Vector2.init(x, y),
            .size = rl.Vector2.init(width, height),
            .color = color,
            .player_type = player_type,
        };
    }

    pub fn move(self: *Paddle, screenHeight: f32) void {
        switch (self.player_type) {
            .Left => {
                if (rl.isKeyDown(rl.KeyboardKey.key_s) and self.position.y + self.size.y <= screenHeight) {
                    self.position.y += 8;
                }
                if (rl.isKeyDown(rl.KeyboardKey.key_w) and self.position.y >= 0) {
                    self.position.y -= 8;
                }
            },
            .Right => {
                if (rl.isKeyDown(rl.KeyboardKey.key_down) and self.position.y + self.size.y <= screenHeight) {
                    self.position.y += 8;
                }
                if (rl.isKeyDown(rl.KeyboardKey.key_up) and self.position.y >= 0) {
                    self.position.y -= 8;
                }
            },
        }
    }

    pub fn draw(self: *Paddle) void {
        rl.drawRectangleV(self.position, self.size, self.color);
    }
};
