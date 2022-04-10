package com.fantasy.simulate.bean;

import java.io.Serializable;

public class PayBean implements Serializable{

	/**
	 * 0 免费 1正常付费 2接口异常付费 10 黑名单拒绝制作
	 */
	public int Status;
	/**
	 * 支付价格
	 */
	public String price;
	/**
	 * 1支付宝支付 2微信支付 3选择 4选择框但微信支付为红包换F码
	 */
	public int payType;
	public String Wnum;// 微信号
	public String Wprice;// 微信换F码价格
	public int stype;//1包月  2是3个月  3 包年  4 连续包月  5 连续包季   6 连续包年

}
