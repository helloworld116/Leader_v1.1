//
//  RKConstancts.h
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#ifndef Leader_RKConstants_h
#define Leader_RKConstants_h

#define kAPPMargin                                  10
#define kStatusHeight                               20
#define kNavigationHeight                           44


#define kLeyyeArticles                  99
#define kLeyyeCircles                   100
#define kMyCircles                      101
#define kLeyyeClubs                     102
#define kLeyyeRegister                  110
#define kLeyyeClubDetail                120


#pragma mark - 服务器返回的状态码
#define kOK                                         0
#define KLoginSuccess                               1
#define kUserNotExit                                3
#define kUnError                                    999

#define kOfficialWebsite                            @"http://www.leyye.com"
#define kFindPassword                               @"http://www.leyye.com/userfind.jsp"


//#define kAPPLoadingPic                  @"app_loading@2x.jpg"
#define kAPPLoadingPic                              @"app_loading@2x.png"
#define kDeleteArticle                              @"btn_del_1@2x.png"

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#pragma mark - 
#define kImageNameUserInputTop                        @""



#pragma mark -----------
#pragma mark 用户
#define kStringUserViewNavigationTitleLogging          @"登 录"
#define kStringUserViewNavigationTitleRegister         @"注册新用户"
#define kStringUserNickName                            @"昵称"
#define kStringUserViewNavigationTitleUserCenter       @"会员中心"
#define kStringUserViewTipAccount                      @"账       号："
#define kStringUserViewTipPassword                     @"密       码："
#define kStringUserViewTipPaddwordAgain                @"确认密码："
#define kStringUserViewPlaceholderAccount              @"输入您的手机号码"
#define kStringUserViewPlaceholderPassword             @"6-20个字母或数字"
#define kStringUserViewButtonLogin                     @"登  录"



/////////////////////////////////// 图片常量配置信息 ///////////////////////////////////
/////////////////////////////////// 首页 ///////////////////////////////////

#define kHomeNavLogoPic @"sy_logo@2x"
#define kHomeNavRefresh @"navigationbar_refresh@2x.png"
#define kHomeNavSearch @"navigationbar_search@2x.png"
#define kNavigationBar @"navigationbar"
#define kCommonBack @"back"
#define kNavArrowBack @"nav_arrow_d@2x"
#define kUserSetting @"setting"

/////////////////////////////////// 我的云购 ///////////////////////////////////
#define kOYYGLoginNormal @"oyyg_login_btn_normal"
#define kOYYGLoginPress @"oyyg_login_btn_press"
#define kOYYGRechargeNormal @"充值按钮"
#define kOYYGRechargePress @"充值按钮"

/////////////////////////////////// 注册登录 ///////////////////////////////////
#define kUserLoginNormal @"login_btn_normal"
#define kUserLoginPress @"login_btn_press"
#define kUserQQLoginNormal @"qq_login_btn_normal"
#define kUserQQLoginPress @"qq_login_btn_press"
#define kUserNextNormal @"register_normal"
#define kUserNextPress  @"login_btn_press"
#define kUserRegisterNormal  @"register_normal"
#define kUserCheckNormal @"check_normal"
#define kUserCheckPress  @"check_press"
#define kRegegistResendNormal @"register_input_field"
#endif
