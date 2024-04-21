let position = 0
let windowPosition = 0

player.onChat("castle", function () {
    makeGroundFloor()
    makeFloor1()
    makeFloor2()
    trees()
})


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
    blocks.place(CHERRY_SAPLING, pos(8, 0, -8))
    blocks.place(CHERRY_SAPLING, pos(8, 0, 8))
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
