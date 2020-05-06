package common

import (
	"encoding/json"
	"fmt"

	"log"
	"net/http"
)

var (
	WX_PAY_URL          = "https://api.mch.weixin.qq.com/pay/unifiedorder"
	WX_PAY_CALLBACK_URL = "http://www.doulaikan.club/jc/api/wxpaycallback"
	MCT_ID              = "1452819402"
	APP_ID              = "wx2db791be2eb77467"
	PRODUCT_NAME        = "测试商品"
	SERVER_IP           = "132.232.11.85"
	MCT_KEY             = "qj837vwk83xk2902jidk93slw82ms5ka"
	TRADE_TYPE_NATIVE   = "NATIVE"
	TRADE_TYPE_JSAPI    = "JSAPI"
	//=================
	WEIBO_OAUTH_CALLBACK_URL  = "http://www.doulaikan.club/jc/api/wxcallback"
	QQ_OAUTH_CALLBACK_URL     = "http://www.doulaikan.club/jc/api/wxcallback"
	WECHAT_OAUTH_CALLBACK_URL = "http://www.doulaikan.club/jc/api/wxcallback"
)

const ERR_CODE_SUCCESS = "0000"
const ERR_CODE_DBERROR = "1001"
const ERR_CODE_TOKENER = "1003"
const ERR_CODE_PARTOEN = "1005"
const ERR_CODE_JSONERR = "2001"
const ERR_CODE_URLERR = "2005"
const ERR_CODE_NOTFIND = "3000"
const ERR_CODE_NOMATCH = "3010"
const ERR_CODE_EXPIRED = "6000"
const ERR_CODE_TYPEERR = "4000"
const ERR_CODE_STATUS = "5000"
const ERR_CODE_FAILED = "9000"
const ERR_CODE_OPERTYP = "4005"
const ERR_CODE_EXISTED = "4040"
const ERR_CODE_TOOBUSY = "6010"
const ERR_CODE_VERIFY = "7020"
const ERR_CODE_PAYERR = "8010"
const ERR_CODE_QRCODE = "7060"

const ERR_USER_MSTSIGNUP = "7901"
const ERR_USER_SIGNINED = "7902"
const ERR_USER_UNSIGNIN = "7903"

const LOGIN_PHONE = 1
const LOGIN_OAUTH = 2

//const STATUS_DISABLED = 1
//const STATUS_ENABLED = 0
const STATUS_SUCC = "S"
const STATUS_FAIL = "F"
const STATUS_DOING = "D"

const MAX_SEARCH_TIMES = "5"

const FIELD_LOGIN_PASS = "login_pass"
const FIELD_ERRORS = "errors"
const FIELD_KILLS = "kills"
const FIELD_LIKES = "likes"
const FIELD_UPDATE_TIME = "update_time"
const FIELD_UPDATE_USER = "update_user"
const FIELD_PROC_STATUS = "proc_status"
const FIELD_PROC_MSG = "proc_msg"
const FIELD_PREPAY_ID = "prepay_id"
const FIELD_CODE_URL = "code_url"

const DEFAULT_PWD = "123456"
const SUCC_MSG = "success"
const EMPTY_STRING = ""

const SMSTYPE_LOGIN = "login"
const SMSTYPE_RESET = "reset"
const SMS_STATUS_INIT = "i"
const SMS_STATUS_END = "e"

const SMSCODE_EXPIRED_MINUTE = 5
const SMSCODE_MIN_INTERVAL = 10

const COMMENT_INIT_VALUE = 0
const COMMENT_LIKE = 10
const COMMENT_KILL = 20
const COMMENT_REPLY = 30

const REGION_PROVINCE = 1
const REGION_CITY = 2
const REGION_COUNTY = 3
const REGION_TOWN = 4
const REGION_VILLAGE = 5

var (
	ERROR_MAP map[string]string = map[string]string{
		ERR_CODE_SUCCESS:   "执行成功:",
		ERR_CODE_DBERROR:   "DB执行错误:",
		ERR_CODE_JSONERR:   "JSON格式错误:",
		ERR_CODE_EXPIRED:   "时效已经到期:",
		ERR_CODE_TYPEERR:   "类型转换错误:",
		ERR_CODE_STATUS:    "状态不正确:",
		ERR_CODE_TOKENER:   "获取TOKEN失败:",
		ERR_CODE_PARTOEN:   "解析TOKEN错误:",
		ERR_CODE_NOMATCH:   "比较不匹配:",
		ERR_CODE_URLERR:    "Url传参有误:",
		ERR_CODE_OPERTYP:   "ShowType类型错误:",
		ERR_CODE_NOTFIND:   "查询没发现提示:",
		ERR_CODE_EXISTED:   "注册账户已经存在:",
		ERR_CODE_TOOBUSY:   "短信发送太频繁:",
		ERR_CODE_VERIFY:    "验证码校验错误:",
		ERR_CODE_PAYERR:    "支付交易失败:",
		ERR_CODE_QRCODE:    "生产支付扫描失败:",
		ERR_USER_MSTSIGNUP: "用户没注册，需要注册",
		ERR_USER_SIGNINED:  "用户已经登录",
		ERR_USER_UNSIGNIN:  "用户需要登录",
	}
)

type ErrorResp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

const (
	USER_CHARGE = "用户充值"
	FLOW_CHARGE = "charge"
	FLOW_INIT   = "i"
	FLOW_SUCC   = "s"
	FLOW_FAIL   = "f"

	STATUS_ENABLED  = "E"
	STATUS_DISABLED = "D"
	STATUS_INIT     = ""

	NOW_TIME_FORMAT    = "2006-01-02 15:04:05"
	FIELD_ACCOUNT_BAL  = "Account_bal"
	FIELD_UPDATED_TIME = "Updated_time"

	CODE_SUCC    = "0000"
	CODE_NOEXIST = "1000"

	CODE_FAIL = "2000"

	RESP_SUCC = "0000"
	RESP_FAIL = "1000"

	CODE_TYPE_EDU       = "EDU"
	CODE_TYPE_POSITION  = "POSITION"
	CODE_TYPE_SALARY    = "SALARY"
	CODE_TYPE_WORKYEARS = "WORKYEARS"
	CODE_TYPE_POSICLASS = "POSICLASS"
	CODE_TYPE_REWARDS   = "REWARDS"

	TOKEN_KEY = "u46IpCV9y5Vlur8YvODJEhgOY8m9JVE4"
)

func PrintHead(a ...interface{}) {
	log.Println("========》", a)
}

func PrintTail(a ...interface{}) {
	log.Println("《========", a)
}

func Write_Response(response interface{}, w http.ResponseWriter, r *http.Request) {
	json, err := json.Marshal(response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, string(json))
}

func Write_ResponseEx(response interface{}, errCode string, w http.ResponseWriter, r *http.Request) {
	json, err := json.Marshal(response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, string(json))
}
