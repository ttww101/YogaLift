//
//  ActivityManager.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/2.
//  Copyright © 2019 SSMNT. All rights reserved.
//

class ActivityManager {

    let trainGroup = ActivityGroup(
        firstLineTitle: " 舒缓关节解除酸痛 ",
        secondLineTitle: " 打造健康的身体 ",
        caption: "每天上班，无论是久坐或是久站，很容易造成职业伤害，善用一点时间做做瑜珈吧！",
        items: [
            TrainItem.TrainA,
            TrainItem.TrainB,
            TrainItem.TrainC,
            TrainItem.TrainD,
            TrainItem.TrainE
        ]
    )

    let yinyogaGroup = ActivityGroup(
        firstLineTitle: " 伸展活络身体 ",
        secondLineTitle: " 提升基础代谢三成 ",
        caption: "年过四十，适合用缓和运动提升代谢取代苦战式减重，善用零碎时间做做瑜珈吧！",
        items: [
            YinYogaItem.YinYogaA,
            YinYogaItem.YinYogaB,
            YinYogaItem.YinYogaC,
            YinYogaItem.YinYogaD,
            YinYogaItem.YinYogaE
        ]
    )

    lazy var groups: [ActivityGroup] = [trainGroup, yinyogaGroup]
}
