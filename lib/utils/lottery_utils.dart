import 'dart:core';
import 'dart:math';

import 'package:graphic_conversion/table/person.dart';

class LotteryUtils {

  /**
   * 获取中奖编码数组
   * @param rlist
   * @param keyLength
   * @return
   */
  List<Person> getKeys(List<Person> rlist, int keyLength) {
    List<Person> list = [];
    for (int i = 0; i < keyLength; i++) {
      list.add(getKey(rlist));
    }
    return list;
  }

  /**
   * 获取中奖编码
   * @param rlist
   * @return
   */
  Person getKey(List<Person> rlist) {
    //随机列表
   // List<Person> randomList = [];
   // randomList.addAll(getRandomList(rlist));
    //根据随机列表得到的概率区段
    List<int> percentSteps =[];
    percentSteps.addAll(getPercentSteps(rlist));

    print("percentSteps:${percentSteps}");
    //概率区段的最大值
    int maxPercentStep = percentSteps[percentSteps.length - 1];

    print("maxPercentStep:${maxPercentStep}");
    //在概率区段范围内取一个随机数
    int randomStep = new Random().nextInt(maxPercentStep);

    print("randomStep:${randomStep}");
    //中间元素的下标
    int keyIndex = 0;
    int begin = 0;
    int end = 0;
    for (int i = 0; i < percentSteps.length; i++) {
      if (i == 0) {
        begin = 0;
      } else {
        begin = percentSteps[i-1];
      }
      end = percentSteps[i];
      //判断随机数值是否在当前区段范围内
      if (randomStep > begin && randomStep <= end) {
        keyIndex = i;
        return rlist[keyIndex];
      }
    }
    return rlist[keyIndex];
  }

  /**
   * 获取概率区段[如：10,15,25,30,40,60,75,80,90,95,100]
   * @param rlist
   * @return
   */
  List<int> getPercentSteps(List<Person> rlist) {
    List<int> percentSteps = [];
    int percent = 0;
    for(int i=0;i<rlist.length;i++){
      percent += rlist[i].weight;
      percentSteps.add(percent);
    }
    return percentSteps;
  }


  /**
   * 获取随机列表
   * @param rlist
   * @return
   */
  List<Person> getRandomList(List<Person> rlist) {
    List<Person> oldList =[] ;
    oldList.addAll(rlist);
    List<Person> newList = [];
    //随机排序的老序列中元素的下标
    int randomIndex = 0;
    //随机排序下标的取值范围
    int randomLength = 0;
    for (int i = 0; i < rlist.length; i++) {
      //指向下标范围
      randomLength = oldList.length - 1;
      //取值范围元素的个数为多个时，从中随机选取一个元素的下标
      if (randomLength != 0) {
        randomIndex = new Random().nextInt(randomLength);
        //取值范围元素的个数为一个时，直接返回该元素的下标
      } else {
        randomIndex = 0;
      }
      //在新的序列当中添加元素，同时删除元素取值范围中的randomIndex下标所对应的元素
      newList.add(oldList.removeAt(randomIndex));
    }
    return newList;
  }
}
