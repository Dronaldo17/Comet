//
//  ApiParamsMarcos.h
//  FCNNApi
//
//  Created by doujingxuan on 13-4-9.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#ifndef FCNNApi_ApiParamsMarcos_h
#define FCNNApi_ApiParamsMarcos_h

/**Author:Ronaldo Description:标志请求是否成功，失败为0,请求成功并且返回数据正确为1,请求成功但返回数据错误为2*/
#define REQUEST_SUCCESS_TAG 1
#define REQUEST_FAILED_TAG 0
#define REQUEST_SUCCESS_DATAERROR_TAG 2


/**Author:Ronaldo Description:服务器接口类型*/

/**Author:Ronaldo Description:获取所在地*/
#define F_SEVER_LOCATION @"F00.00.01.01"

/**Author:Ronaldo Description:获取手机验证码*/
#define F_SERVER_PHONENUMBER_TYPE @"F00.00.01.02"

/**Author:Ronaldo Description:注册*/
#define F_SERVER_REGISTER_TYPE @"F00.00.01.03"

/**Author:Ronaldo Description:登录*/
#define F_SERVER_LOGIN_TYPE @"F00.00.01.04"

/**Author:Ronaldo Description:完善资料*/
#define F_SERVER_UPDATE_PROFILE_TYPE @"F00.00.01.05"

/**Author:Ronaldo Description:摇一摇*/
#define F_SERVER_SHAKE_TYPE @"F00.00.01.06"

/**Author:Ronaldo Description:获取消息列表*/
#define F_SERVER_GET_MESSGAE_TYPE @"F00.00.01.07"

/**Author:Ronaldo Description:获取好友用户信息*/
#define F_SERVER_FRIEND_INFO_TYPE @"F00.00.01.08"

/**Author:Ronaldo Description:获取照片列表*/
#define F_SERVER_GETPHOTO_TYPE @"F00.00.01.09"

/**Author:Ronaldo Description:上传照片*/
#define F_SERVER_PHOTOUPLOAD_TYPE @"F00.00.01.10"

/**Author:Ronaldo Description:获取信友列表*/
#define F_SERVER_GETALLFRIEND_TYPE @"F00.00.01.11"


/**Author:Ronaldo Description:获取信友列表(有未读信的)*/
#define F_SERVER_UNREAD_MESSAGE_TYPE @"F00.00.01.12"

/**Author:Ronaldo Description:删除信*/
#define F_SERVER_DEL_MESSAGE_TYPE @"F00.00.01.13"

/**Author:Ronaldo Description:发信*/
#define F_SERVER_SEND_MESSAGE_TYPE @"F00.00.01.14"

/**Author:Ronaldo Description:购买服务*/
#define F_SERVER_BUY_SERVEICE @"F00.00.01.15"

/**Author:Ronaldo Description:删除头像*/
#define F_SERVER_DEL_PHOTO_TYPE @"F00.00.01.16"

/**Author:Ronaldo Description:修改密码*/
#define F_SERVER_MODIFY_PASSWORD_TYPE @"F00.00.01.17"


/**Author:Ronaldo Description:领取金币*/
#define F_SERVER_GETICON_TYPE @"F00.00.01.18"

/**Author:Ronaldo Description:忘记密码*/
#define F_SERVER_RESETPWD_TYPE @"F00.00.01.19"

/**Author:Ronaldo Description:获取用户账户信息*/
#define F_SERVER_ACCOUNT_TYPE @"F00.00.01.20"


/**Author:Ronaldo Description:创建订单*/
#define F_SERVER_CREATE_ORDER @"F00.00.01.21"

/**Author:Ronaldo Description:确认订单*/
#define F_SERVER_DETER_ORDER @"F00.00.01.22"

/**Author:Ronaldo Description:查询订单*/
#define F_SERVER_CAT_ORDER @"F00.00.01.23"

/**Author:Ronaldo Description:设置头像*/
#define F_SERVER_SET_AVATAR @"F00.00.01.24"


/**Author:Ronaldo Description:查询充值记录*/
#define F_SERVER_PAY_HISTORY @"F00.00.01.25"

/**Author:Ronaldo Description:服务器规定参数*/
#define F_REQUEST_TYPE @"request_type"

#define F_SRC @"src"

#define F_DEVICE_ID @"deviceid"

#define F_SMID @"smid"

#define F_MOBILE @"mobile"

#define F_LBS @"lbs"

#define F_SEX @"sex"

#define F_CODE @"code"

#define F_PASSWORD @"passwd"

#define F_BIRTHDAY @"birthday"

#define F_NICKNAME @"nickname"

#define F_CITYLIVE @"citylive"

#define F_JOB @"job"

#define F_SCHOOL @"school"

#define F_INTEREST @"interest"

#define F_REMARKS @"remarks"

#define F_CHOOSE_SEX  @"choosesex"

#define F_TOKEN @"token"

#define F_TYPE @"type"

#define F_UPFILE @"upfile"

#define F_PID @"pid"

#define F_STATUS @"status"

#define F_PHOTOADDRESS @"photoaddress"


#define F_NEW_PASSWORD @"newpsw"

#define F_OLD_PASSWORD @"oldpsw"

#define F_USER_ID @"userid"

#define F_CITY_1 @"city_1"

#define F_Friend_AVATAR @"photo"

#define F_LEVEL @"level"

#define F_PHOTO_COUNT @"photos"

#define F_FUID @"fuid" 

#define F_CONTENT @"content"


#define F_HEADER @"header"

#define F_RESULT @"result"

#define F_BODY @"body"

#define F_PAGER @"pager"

#define F_CURRENTPAGE @"currentPage"

#define F_PAGESIZE @"pagesize"

#define F_TOTALROWS @"totalRows"

#define F_PHOTO_ARRAY @"F_PHOTO_ARRAY"
#endif
