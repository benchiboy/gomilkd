package project

import (
	"encoding/json"
	"fmt"
	"gomilkd/common"
	"gomilkd/service/dbcomm"
	"gomilkd/service/project"
	"net/http"
	"time"
)

/*
	获取具体某个实体返回
*/
type NewProjectReq struct {
	Project project.Project `json:"info"`
}

/*
	获取具体某个实体返回
*/
type NewProjectResp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	获取具体某个实体返回
*/
type DelProjectReq struct {
	Project project.Project `json:"info"`
}

/*
	获取具体某个实体返回
*/
type DelProjectResp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	获取具体某个实体返回
*/
type GetProjectReq struct {
	Project project.Project `json:"info"`
}

/*
	获取具体某个实体返回
*/
type GetProjectResp struct {
	ErrCode string          `json:"err_code"`
	ErrMsg  string          `json:"err_msg"`
	Project project.Project `json:"info"`
}

/*
	获取具体某个实体返回
*/
type GetListReq struct {
	Search project.Search `json:"info"`
}

/*
	获取具体某个实体返回
*/
type GetListResp struct {
	ErrCode string            `json:"err_code"`
	ErrMsg  string            `json:"err_msg"`
	Total   int               `json:"total"`
	List    []project.Project `json:"list"`
}

/*
	说明：新增工程
	出参：结果根据错误代码判断
*/
func NewProject(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("NewProject")
	var newReq NewProjectReq
	var newResp NewProjectResp
	err := json.NewDecoder(req.Body).Decode(&newReq)
	if err != nil {
		newResp.ErrCode = common.ERR_CODE_JSONERR
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(newResp, w, req)
		return
	}
	defer req.Body.Close()
	var search project.Search
	search.ProjectName = newReq.Project.ProjectName
	r := project.New(dbcomm.GetDB(), project.DEBUG)
	if _, err := r.Get(search); err == nil {
		newResp.ErrCode = common.ERR_CODE_EXISTED
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_EXISTED]
		common.Write_Response(newResp, w, req)
	} else {
		tr, _ := r.DB.Begin()
		newReq.Project.ProjectNo = time.Now().Unix()
		newReq.Project.CreateTime = time.Now().Format("2006-01-02 15:04:05")
		if err := r.InsertEntity(newReq.Project, tr); err != nil {
			tr.Rollback()
			newResp.ErrCode = common.ERR_CODE_DBERROR
			newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR]
			common.Write_Response(newResp, w, req)
			return
		}
		tr.Commit()
	}
	common.PrintTail("NewProject")
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
	r := project.New(dbcomm.GetDB(), project.DEBUG)
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

func DelProject(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("DelProject")
	var delReq DelProjectReq
	var delResp DelProjectResp
	err := json.NewDecoder(req.Body).Decode(&delReq.Project)
	if err != nil {
		delResp.ErrCode = common.ERR_CODE_JSONERR
		delResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(delResp, w, req)
		return
	}
	defer req.Body.Close()
	var search project.Search
	search.Id = delReq.Project.Id
	r := project.New(dbcomm.GetDB(), project.DEBUG)
	if e, err := r.Get(search); err == nil {
		r.Delete(fmt.Sprintf("%d", e.Id), nil)
	}
	delResp.ErrCode = common.ERR_CODE_SUCCESS
	delResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_SUCCESS]
	common.Write_Response(delResp, w, req)
	common.PrintTail("DelProject")
}
