package business

import (
	"encoding/json"
	"fmt"
	"gomilkd/common"
	"gomilkd/service/business"
	"gomilkd/service/dbcomm"
	"net/http"
	"time"
)

/*
	获取具体某个实体返回
*/
type NewReq struct {
	Business business.Business `json:"info"`
}

/*
	获取具体某个实体返回
*/
type NewResp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	获取具体某个实体返回
*/
type DelReq struct {
	Business business.Business `json:"info"`
}

/*
	获取具体某个实体返回
*/
type DelResp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	获取具体某个实体返回
*/
type GetReq struct {
	Business business.Business `json:"info"`
}

/*
	获取具体某个实体返回
*/
type GetResp struct {
	ErrCode  string            `json:"err_code"`
	ErrMsg   string            `json:"err_msg"`
	Business business.Business `json:"info"`
}

/*
	获取具体某个实体返回
*/
type GetListReq struct {
	Search business.Search `json:"info"`
}

/*
	获取具体某个实体返回
*/
type GetListResp struct {
	ErrCode string              `json:"err_code"`
	ErrMsg  string              `json:"err_msg"`
	Total   int                 `json:"total"`
	List    []business.Business `json:"list"`
}

/*
	说明：新增工程
	出参：结果根据错误代码判断
*/
func NewBusiness(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("NewBusiness")
	var newReq NewReq
	var newResp NewResp
	err := json.NewDecoder(req.Body).Decode(&newReq)
	if err != nil {
		fmt.Println(err)
		newResp.ErrCode = common.ERR_CODE_JSONERR
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(newResp, w, req)
		return
	}
	defer req.Body.Close()
	var search business.Search
	search.BusinessName = newReq.Business.BusinessName
	r := business.New(dbcomm.GetDB(), business.DEBUG)
	if _, err := r.Get(search); err == nil {
		newResp.ErrCode = common.ERR_CODE_EXISTED
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_EXISTED]
		common.Write_Response(newResp, w, req)
	} else {
		tr, _ := r.DB.Begin()
		newReq.Business.BusinessNo = time.Now().Unix()
		newReq.Business.CreateTime = time.Now().Format("2006-01-02 15:04:05")
		if err := r.InsertEntity(newReq.Business, tr); err != nil {
			tr.Rollback()
			newResp.ErrCode = common.ERR_CODE_DBERROR
			newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR]
			common.Write_Response(newResp, w, req)
			return
		}
		tr.Commit()
	}
	common.PrintTail("NewBusiness")
}

/*
	说明：得到列表
	出参：参数1：返回符合条件的对象列表
*/

func GetProjectList(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("GetProjectList")
	var listReq GetListReq
	var listResp GetListResp
	err := json.NewDecoder(req.Body).Decode(&listReq.Search)
	if err != nil {
		listResp.ErrCode = common.ERR_CODE_JSONERR
		listResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(listResp, w, req)
		return
	}
	defer req.Body.Close()
	r := business.New(dbcomm.GetDB(), business.DEBUG)
	l, err := r.GetList(listReq.Search)
	if err != nil {
		listResp.ErrCode = common.ERR_CODE_DBERROR
		listResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR] + err.Error()
		common.Write_Response(listResp, w, req)
		return
	}
	total, _ := r.GetTotal(listReq.Search)
	listResp.List = l
	listResp.Total = total
	common.Write_Response(listResp, w, req)
	common.PrintTail("GetProjectList")
}

/*
	说明：删除接口
	出参：参数1：返回符合条件的对象列表
*/
