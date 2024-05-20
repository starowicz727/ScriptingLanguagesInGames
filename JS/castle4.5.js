let position = 0
let windowPosition = 0

player.onChat("castle", function () {
    makeMoat()
    makeBridge()
    makeGroundFloor()
    makeFloor1()
    makeFloor2()
    trees()
    makeTowers()
})

function makeBridge () {
    blocks.fill(
    CHERRY_FENCE,
    pos(16, 1, -4),
    pos(16, 1, -1),
    FillOperation.Replace
    )
    blocks.fill(
    CHERRY_FENCE,
    pos(16, 1, 1),
    pos(16, 1, 4),
    FillOperation.Replace
    )
    blocks.fill(
    CHERRY_PLANKS,
    pos(10, 0, -1),
    pos(15, 0, 1),
    FillOperation.Replace
    )
    blocks.fill(
    CHERRY_FENCE,
    pos(10, 1, -1),
    pos(15, 1, -1),
    FillOperation.Replace
    )
    blocks.fill(
    CHERRY_FENCE,
    pos(10, 1, 1),
    pos(15, 1, 1),
    FillOperation.Replace
    )
    blocks.fill(
    CHERRY_STAIRS,
    pos(9, 0, -1),
    pos(9, 0, 1),
    FillOperation.Replace
    )
    agent.teleport(pos(17, 1, 0), WEST)
    agent.setItem(CHERRY_FENCE_GATE, 1, 1)
    agent.place(FORWARD)
    agent.teleport(pos(25, 1, 0), WEST)
}

function makeMoat () {
    blocks.fill(
    AIR,
    pos(-15, -3, -15),
    pos(15, 0, 15),
    FillOperation.Replace
    )
    blocks.fill(
    WATER,
    pos(-15, -3, -15),
    pos(15, -1, 15),
    FillOperation.Replace
    )
    blocks.fill(
    GRASS,
    pos(-10, -3, -10),
    pos(10, -1, 10),
    FillOperation.Replace
    )
}

function makeGroundFloor () {
    blocks.fill(
    PURPLE_CONCRETE,
    pos(-6, -1, -6),
    pos(6, 4, 6),
    FillOperation.Hollow
    )
    blocks.fill(
    AMETHYST_BLOCK,
    pos(-6, 5, -6),
    pos(6, 6, 6),
    FillOperation.Hollow
    )
    blocks.place(DARK_OAK_DOOR, pos(6, 0, 0))
    blocks.fill(
    PURPLE_CARPET,
    pos(-5, 0, -5),
    pos(5, 0, 5),
    FillOperation.Replace
    )
    makeWindows(3, 6, 3, -3, 3)
    decorateX(-6, 7, 7, -6, true)
    decorateX(-6, 7, 7, 6, true)
    decorateZ(-6, 7, 7, -6, true)
    decorateZ(-6, 7, 7, 6, true)
    light()
}

function decorateZ (posStart: number, posEnd: number, posY: number, posZ: number, divisible: boolean) {
    position = posStart
    while (position < posEnd) {
        if (divisible) {
            if (position % 2 == 0) {
                blocks.fill(
                AMETHYST_BLOCK,
                pos(position, posY, posZ),
                pos(position, posY, posZ),
                FillOperation.Replace
                )
            }
        } else {
            if (position % 2 != 0) {
                blocks.fill(
                AMETHYST_BLOCK,
                pos(position, posY, posZ),
                pos(position, posY, posZ),
                FillOperation.Replace
                )
            }
        }
        position = position + 1
    }
}

function makeFloor2 () {
    blocks.fill(
    AIR,
    pos(-2, 11, -2),
    pos(2, 11, 2),
    FillOperation.Replace
    )
    blocks.place(WHITE_GLAZED_TERRACOTTA, pos(0, 11, 0))
    blocks.place(AMETHYST_CLUSTER, pos(0, 12, 0))
}

function trees () {
    blocks.place(CHERRY_SAPLING, pos(16, 1, -6))
    blocks.place(CHERRY_SAPLING, pos(16, 1, 6))
}

function decorateX (posStart: number, posEnd: number, posY: number, posX: number, divisible: boolean) {
    position = posStart
    while (position < posEnd) {
        if (divisible) {
            if (position % 2 == 0) {
                blocks.place(AMETHYST_BLOCK, pos(posX, posY, position))
            }
        } else {
            if (position % 2 != 0) {
                blocks.place(AMETHYST_BLOCK, pos(posX, posY, position))
            }
        }
        position = position + 1
    }
}

function light () {
    blocks.place(PEARLESCENT_FROGLIGHT, pos(5, 1, 5))
    blocks.place(PEARLESCENT_FROGLIGHT, pos(5, 1, -5))
    blocks.place(PEARLESCENT_FROGLIGHT, pos(-5, 1, 5))
    blocks.place(PEARLESCENT_FROGLIGHT, pos(-5, 1, -5))
}

function makeFloor1 () {
    blocks.fill(
    AIR,
    pos(-5, 6, -5),
    pos(5, 6, 5),
    FillOperation.Replace
    )
    blocks.fill(
    PURPLE_CONCRETE,
    pos(-3, 5, -3),
    pos(3, 9, 3),
    FillOperation.Hollow
    )
    blocks.fill(
    PURPLE_CARPET,
    pos(-2, 6, -2),
    pos(2, 6, 2),
    FillOperation.Replace
    )
    blocks.fill(
    AMETHYST_BLOCK,
    pos(-3, 10, -3),
    pos(3, 11, 3),
    FillOperation.Replace
    )
    blocks.place(DARK_OAK_DOOR, pos(3, 6, 0))
    blocks.place(BED, pos(-2, 6, 0))
    blocks.place(BEACON, pos(-2, 6, 2))
    makeWindows(2, 3, 7, -2, 4)
    decorateX(-3, 4, 12, -3, false)
    decorateX(-3, 4, 12, 3, false)
    decorateZ(-3, 4, 12, -3, false)
    decorateZ(-3, 4, 12, 3, false)
}

function makeTowers () {
    blocks.fill(
    PURPLE_CONCRETE,
    pos(5, 0, 7),
    pos(7, 8, 9),
    FillOperation.Hollow
    )
    blocks.fill(
    AMETHYST_BLOCK,
    pos(5, 9, 7),
    pos(7, 9, 9),
    FillOperation.Hollow
    )
    blocks.place(AMETHYST_BLOCK, pos(5, 10, 7))
    blocks.place(AMETHYST_BLOCK, pos(7, 10, 7))
    blocks.place(AMETHYST_BLOCK, pos(7, 10, 9))
    blocks.place(AMETHYST_BLOCK, pos(5, 10, 9))
    blocks.clone(
    pos(5, 0, 7),
    pos(7, 10, 9),
    pos(5, 0, -9),
    CloneMask.Replace,
    CloneMode.Normal
    )
    blocks.clone(
    pos(5, 0, 7),
    pos(7, 10, 9),
    pos(-7, 0, -9),
    CloneMask.Replace,
    CloneMode.Normal
    )
    blocks.clone(
    pos(5, 0, 7),
    pos(7, 10, 9),
    pos(-7, 0, 7),
    CloneMask.Replace,
    CloneMode.Normal
    )
}

function makeWindows (num: number, posX: number, posY: number, posZ: number, step: number) {
    windowPosition = posZ
    for (let index = 0; index < num; index++) {
        blocks.fill(
        PURPLE_STAINED_GLASS_PANE,
        pos(posX, posY, windowPosition),
        pos(posX, posY, windowPosition),
        FillOperation.Replace
        )
        windowPosition = windowPosition + step
    }
}