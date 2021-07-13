Graphic = UsingModule("Graphic")
Media = UsingModule("Media")

Resource = {}

Resource._Tips = Graphic.LoadImageFromFile("Resource/Graph/Tips.png")
Resource.Tips = Graphic.CreateTexture(Resource._Tips)

Resource._Home = Graphic.LoadImageFromFile("Resource/Graph/Home.png")
Resource.Home =
{
    Graph = Graphic.CreateTexture(Resource._Home),
    Rect = {x = 285, y = 570, w = 30, h = 30},
    State = 1
}

Resource.YellowTank_1 = Graphic.LoadImageFromFile("Resource/Graph/YellowTank1.png")
Resource.YellowTank1 = {}
for i = 1, 4 do
    Resource.YellowTank1[i] = {}
    for j = 1, 2 do
        Resource.YellowTank1[i][j] = {
            Rect = {
                x = (i - 1) * 104 + (j - 1) * 52,
                y = 0,
                w = 52, h = 52
            }
        }
    end
end

Resource.PlayerTank = {
    Rect = {x = 224, y = 569, w = 25, h = 25},
    Graph = Graphic.CreateTexture(Resource.YellowTank_1),
    Array = Resource.YellowTank1,
    Direction = 1,
    State = 1,
    Speed = 3,
    Health = 3
}

Resource.Enemy_1 = Graphic.LoadImageFromFile("Resource/Graph/Enemy1.png")
Resource.Enemy1 = {}
for i = 1, 4 do
    Resource.Enemy1[i] = {}
    for j = 1, 2 do
        Resource.Enemy1[i][j] = {
            Rect = {
                x = (i - 1) * 104 + (j - 1) * 52,
                y = 0,
                w = 52, h = 52
            }
        }
    end
end

Resource.Enemy_2 = Graphic.LoadImageFromFile("Resource/Graph/Enemy2.png")
Resource.Enemy2 = {}
for i = 1, 4 do
    Resource.Enemy2[i] = {}
    for j = 1, 2 do
        Resource.Enemy2[i][j] = {
            Rect = {
                x = (i - 1) * 104 + (j - 1) * 52,
                y = 0,
                w = 52, h = 52
            }
        }
    end
end

Resource.Enemy_3 = Graphic.LoadImageFromFile("Resource/Graph/Enemy3.png")
Resource.Enemy3 = {}
for i = 1, 4 do
    Resource.Enemy3[i] = {}
    for j = 1, 2 do
        Resource.Enemy3[i][j] = {
            Rect = {
                x = (i - 1) * 104 + (j - 1) * 52,
                y = 0,
                w = 52, h = 52
            }
        }
    end
end

--管理所有的敌方坦克
Resource.AllEnemy = {}
--场上敌方坦克的数量
Resource.Amount = 0

--中型坦克父类,血量和速度适中
Resource.EnemyMiddle = {
    Rect = {x = 0, y = 0, w = 25, h = 25},
    Graph = Graphic.CreateTexture(Resource.Enemy_1),
    Array = Resource.Enemy1,
    Direction = 3,
    State = 1,
    Speed = 3,
    Health = 3,
    MoveDirection = 0
}

--重型坦克父类,血量较高,移速较慢
Resource.EnemyHeavy = {
    Rect = {x = 0, y = 0, w = 25, h = 25},
    Graph = Graphic.CreateTexture(Resource.Enemy_2),
    Array = Resource.Enemy2,
    Direction = 3,
    State = 1,
    Speed = 2,
    Health = 5,
    MoveDirection = 0
}

--轻型坦克父类,血量较低,移速飞快
Resource.EnemyLight = {
    Rect = {x = 0, y = 0, w = 25, h = 25},
    Graph = Graphic.CreateTexture(Resource.Enemy_3),
    Array = Resource.Enemy3,
    Direction = 3,
    State = 1,
    Speed = 5,
    Health = 1,
    MoveDirection = 0
}

function Resource.EnemyMiddle:New()
    Resource.Amount = Resource.Amount + 1
    table.insert(Resource.AllEnemy, 
        {
            Rect = {x = 0, y = 0, w = 25, h = 25},
            Graph = Graphic.CreateTexture(Resource.Enemy_1),
            Array = Resource.Enemy1,
            Direction = 3,
            State = 1,
            Speed = 3,
            Health = 3
        }
    )
    setmetatable(Resource.AllEnemy[Resource.Amount], self)
    self.__index = self
end

function Resource.EnemyHeavy:New()
    Resource.Amount = Resource.Amount + 1
    table.insert(Resource.AllEnemy, 
        {
            Rect = {x = 0, y = 0, w = 25, h = 25},
            Graph = Graphic.CreateTexture(Resource.Enemy_2),
            Array = Resource.Enemy2,
            Direction = 3,
            State = 1,
            Speed = 2,
            Health = 5
        }
    )
    setmetatable(Resource.AllEnemy[Resource.Amount], self)
    self.__index = self
end

function Resource.EnemyLight:New()
    Resource.Amount = Resource.Amount + 1
    table.insert(Resource.AllEnemy, 
        {
            Rect = {x = 0, y = 0, w = 25, h = 25},
            Graph = Graphic.CreateTexture(Resource.Enemy_3),
            Array = Resource.Enemy3,
            Direction = 3,
            State = 1,
            Speed = 5,
            Health = 2
        }
    )
    setmetatable(Resource.AllEnemy[Resource.Amount], self)
    self.__index = self
end

--绘制坦克--
function Resource.DrawTank(tank)
    Graphic.CopyReshapeTexture(tank.Graph, tank.Array[tank.Direction][tank.State].Rect, tank.Rect)
end

--管理所有的炮弹
Resource.AllBullet = {}
Resource.Number = 0

--炮弹类
--场景中所有的炮弹均继承于该类

--type = 1指的是玩家射出的炮弹
--这种炮弹只会检测敌方坦克的碰撞箱
--type = 2则是敌方坦克射出的炮弹
--这种炮弹只会检测玩家的碰撞箱
Resource.Bullet = {
    x = nil,
    y = nil,
    Speed = nil,
    Direction = nil,
    Graph = Graphic.CreateTexture(Graphic.LoadImageFromFile("Resource/Graph/Bullet.png")),
    Type = nil
}

--新分配一个炮弹出来
function Resource.Bullet:New(tank, speed, type)
    Resource.Number = Resource.Number + 1
    table.insert(Resource.AllBullet,
        {
            x = tank.Rect.x + 10,
            y = tank.Rect.y + 10,
            Speed = 10 or speed,
            Direction = tank.Direction,
            Type = type
        }
    )
    setmetatable(Resource.AllBullet[Resource.Number], self)
    self.__index = self
end

Resource.Material = {}

local _Blocks = Graphic.LoadImageFromFile("Resource/Graph/Blocks.png")
Resource.Blocks = Graphic.CreateTexture(_Blocks)

for i = 1, 4 do
    Resource.Material[i] = 
    {
        Rect = {x = (i - 1) * 15, y = 0, w = 15, h = 15}
    }
end

--音乐和音效加载

--开场音乐
Resource.BattleCity = Media.LoadMusic("Resource/Music/BattleCity.mp3")

--喜闻乐见的东方疮痍曲
Resource.GameOver = Media.LoadMusic("Resource/Music/GameOver.mp3")

--发射炮弹音效(我自己用嘴配的)
Resource.ShotSound = Media.LoadSoundFromFile("Resource/Sounds/ShotSound.mp3")

--坦克爆炸音效(网上录的)
Resource.BlastSound = Media.LoadSoundFromFile("Resource/Sounds/BlastSound.mp3")

return Resource