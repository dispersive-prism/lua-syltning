Player = {
    xPosition = 0,
    yPosition = 0,
    xSpeed = 0,
    ySpeed = 0,
    width = 10,
    height = 24,
    jumpHeight = -690,
    maxFallSpeed = 800,
    acceleration = 600,
    runSpeed = 350,
    climbAcceleration = 450,
    lastClimbTime = 0,
    allowAirClimbFor = 0.08,
    maxClimbSpeed = 800,
    lastJumpTime = 0,
    allowJumpAfter = 0.01,
    lastGrounded = 0,
    groundedDelay = 0.20,
    crouching = false,
    dropDown = false,
    graspingUp = false,
    graspingDown = false,
    climbingUp = false,
    climbingDown = false,
    inWater = false,
    lastSwimStroke = 0,
    allowSwimStrokeAfter = 0.4
}

return Player