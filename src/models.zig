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
        // Adding speed vector to the position means that we're
        // adding to both coordinates. For now, I'll change this
        // so that the ball bounces only horizontally. It'll be
        // easier to test the collisions with paddles
        self.position.x += self.speed.x;
        //self.position = rlm.vector2Add(self.position, self.speed);
        _ = screenHeight;
        _ = screenWidth;
        // check for y collisions
        // if (self.position.y - self.radius <= 0 or self.position.y + self.radius >= screenHeight) {
        //     self.speed.y *= -1;
        // }

        // if (self.position.x - self.radius <= 0 or self.position.x + self.radius >= screenWidth) {
        //     self.speed.x *= -1;
        //  }

        if (self.position.x - self.radius <= self.paddleLeft.position.x + self.paddleLeft.size.x and (self.position.y >= self.paddleLeft.position.y and self.position.y <= self.paddleLeft.position.y + self.paddleLeft.size.y)) {
            self.speed.x *= -1;
        } else if (self.position.x + self.radius >= self.paddleRight.position.x and (self.position.y >= self.paddleRight.position.y and self.position.y <= self.paddleRight.position.y + self.paddleRight.size.y)) {
            self.speed.x *= -1;
        }
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
