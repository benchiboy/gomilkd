package {{.PackageName}}

import (
	"encoding/json"
	"fmt"
	"hcd-device/control/common"
	"hcd-device/service/dbcomm"
	{{if ne .RefPackageName "" }}"hcd-device/service/{{.RefPackageName}}"	{{end}}	
	"hcd-device/service/{{.PackageName}}"
	"log"
	"net/http"
	"time"
)

/*
	查询列表请求
*/
type Get{{.EntityName}}ListReq struct {
	Search {{.PackageName}}.Search `json:"{{.PackageName}}"`
}

/*
	查询列表应答
*/
type Get{{.EntityName}}ListResp struct {
	ErrCode string        `json:"err_code"`
	ErrMsg  string        `json:"err_msg"`
	Total   int           `json:"total"`
	List    []{{.PackageName}}.{{.EntityName}} `json:"list"`
}

/*
	删除请求
*/
type Del{{.EntityName}}Req struct {
	{{.EntityName}} {{.PackageName}}.{{.EntityName}} `json:"{{.PackageName}}"`
}

/*
	删除应答
*/
type Del{{.EntityName}}Resp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	获取具体某个实体请求
*/
type Get{{.EntityName}}Req struct {
	{{.EntityName}} {{.PackageName}}.{{.EntityName}} `json:"{{.PackageName}}"`
}

/*
	获取具体某个实体返回
*/
type Get{{.EntityName}}Resp struct {
	ErrCode string      `json:"err_code"`
	ErrMsg  string      `json:"err_msg"`
	{{.EntityName}}   {{.PackageName}}.{{.EntityName}} `json:"{{.PackageName}}"`	
	{{if ne .RefPackageName "" }}SubList []{{.RefPackageName}}.{{.RefEntityName}} `json:"list"`{{end}}	
}

/*
	新增请求，SubList代表关联的子表
*/
type New{{.EntityName}}Req struct {
	{{.EntityName}}   {{.PackageName}}.{{.EntityName}} `json:"{{.PackageName}}"`
	{{if ne .RefPackageName "" }}SubList []{{.RefPackageName}}.{{.RefEntityName}} `json:"list"`{{end}}
}

/*
	新增返回
*/

type New{{.EntityName}}Resp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	修改请求
*/
type Set{{.EntityName}}Req struct {
	{{.EntityName}}   {{.PackageName}}.{{.EntityName}} `json:"{{.PackageName}}"`
	{{if ne .RefPackageName "" }}SubList []{{.RefPackageName}}.{{.RefEntityName}} `json:"list"`{{end}}
}

/*
	修改返回
*/
type Set{{.EntityName}}Resp struct {
	ErrCode string `json:"err_code"`
	ErrMsg  string `json:"err_msg"`
}

/*
	说明：新增
	出参：结果根据错误代码判断
*/
func New{{.EntityName}}(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("New{{.EntityName}}")
	var newReq New{{.EntityName}}Req
	var newResp New{{.EntityName}}Resp
	err := json.NewDecoder(req.Body).Decode(&newReq)
	if err != nil {
		newResp.ErrCode = common.ERR_CODE_JSONERR
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(newResp, w, req)
		return
	}
	defer req.Body.Close()
	var search {{.PackageName}}.Search
	search.{{.EntityCheckName}} = newReq.{{.EntityName}}.{{.EntityCheckName}}
	r := {{.PackageName}}.New(dbcomm.GetDB(), {{.PackageName}}.DEBUG)
	if _, err := r.Get(search); err == nil {
		newResp.ErrCode = common.ERR_CODE_EXISTED
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_EXISTED]
		common.Write_Response(newResp, w, req)
	} else {
		tr, _ := r.DB.Begin()
		newReq.{{.EntityName}}.CreatedTime = time.Now().Unix()
		newReq.{{.EntityName}}.{{.EntityBusiNo}} = time.Now().Unix()
		if err := r.InsertEntity(newReq.{{.EntityName}}, tr); err != nil {
			tr.Rollback()	
			newResp.ErrCode = common.ERR_CODE_DBERROR
			newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR]
			common.Write_Response(newResp, w, req)
			return
		}
		{{if ne .RefPackageName "" }}if newReq.SubList != nil {
			rr:= {{.RefPackageName}}.New(dbcomm.GetDB(), {{.RefPackageName}}.DEBUG)
			for i, v := range newReq.SubList {
				v.{{.RefNo}} = newReq.{{.EntityName}}.{{.RefNo}}
				v.{{.RefEntityBusiNo}} = time.Now().Unix() + int64(i)
				v.CreatedTime = time.Now().Unix()
				if err := rr.InsertEntity(v, tr); err != nil {
					tr.Rollback()
					newResp.ErrCode = common.ERR_CODE_DBERROR
					newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR]
					common.Write_Response(newResp, w, req)
					return
				}
			}
		}{{end}}
		tr.Commit()
		newResp.ErrCode = common.ERR_CODE_SUCCESS
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_SUCCESS]
		common.Write_Response(newResp, w, req)
	}
	common.PrintTail("New{{.EntityName}}")
}

/*
	说明：检查业务主键是否重复
	出参：
*/
func ChkBusiNo(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("ChkBusiNo")
	var newReq New{{.EntityName}}Req
	var newResp New{{.EntityName}}Resp
	err := json.NewDecoder(req.Body).Decode(&newReq)
	if err != nil {
		log.Println(err)
		newResp.ErrCode = common.ERR_CODE_JSONERR
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(newResp, w, req)
		return
	}
	defer req.Body.Close()
	var search {{.PackageName}}.Search
	if newReq.{{.EntityName}}.{{.EntityBusiNo}} != 0 {
		search.ExtraWhere = " and {{.RefField}}!=" + fmt.Sprintf("%d", newReq.{{.EntityName}}.{{.EntityBusiNo}})
	}
	search.{{.EntityCheckName}} = newReq.{{.EntityName}}.{{.EntityCheckName}}
	r := {{.PackageName}}.New(dbcomm.GetDB(), {{.PackageName}}.DEBUG)
	if _, err := r.Get(search); err == nil {
		newResp.ErrCode = common.ERR_CODE_EXISTED
		newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_EXISTED]
		common.Write_Response(newResp, w, req)
	}
	newResp.ErrCode = common.ERR_CODE_SUCCESS
	newResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_SUCCESS]
	common.Write_Response(newResp, w, req)
	common.PrintTail("ChkBusiNo")
}

/*
	说明：修改
	出参：
*/
func Set{{.EntityName}}(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("Set{{.EntityName}}")
	var setReq Set{{.EntityName}}Req
	var setResp Set{{.EntityName}}Resp
	err := json.NewDecoder(req.Body).Decode(&setReq)
	if err != nil {
		setResp.ErrCode = common.ERR_CODE_JSONERR
		setResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(setResp, w, req)
	}
	defer req.Body.Close()
	var search {{.PackageName}}.Search
	search.Id = setReq.{{.EntityName}}.Id
	r := {{.PackageName}}.New(dbcomm.GetDB(), {{.PackageName}}.DEBUG)
	if e, err := r.Get(search); err != nil {
		setResp.ErrCode = common.ERR_CODE_NOTFIND
		setResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_NOTFIND]
		common.Write_Response(setResp, w, req)
		return
	} else {
		tr, _ := r.DB.Begin()
		*e = setReq.{{.EntityName}}
		r.UpdataEntity(fmt.Sprintf("%d", e.Id), *e, tr)
		{{if ne .RefPackageName "" }}if setReq.SubList != nil {
			rr := {{.RefPackageName}}.New(r.DB, {{.RefPackageName}}.DEBUG)
			rr.DeleteEx("{{.RefField}}", e.{{.EntityBusiNo}}, tr)
			for i, v := range setReq.SubList {
				v.{{.EntityBusiNo}} = setReq.{{.EntityName}}.{{.EntityBusiNo}}
				if v.{{.RefEntityBusiNo}} == 0 {
					v.{{.RefEntityBusiNo}} = time.Now().Unix() + int64(i)
				}
				v.CreatedTime = time.Now().Unix()
				if err := rr.InsertEntity(v, tr); err != nil {
					tr.Rollback()
					setResp.ErrCode = common.ERR_CODE_DBERROR
					setResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR]
					common.Write_Response(setResp, w, req)
					return
				}
			}
		}{{end}}
		tr.Commit()
		setResp.ErrCode = common.ERR_CODE_SUCCESS
		setResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_SUCCESS]
		common.Write_Response(setResp, w, req)
	}
	common.PrintTail("SetGroup")
}

/*
	说明：删除接口
	出参：参数1：返回符合条件的对象列表
*/

func Del{{.EntityName}}(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("Del{{.EntityName}}")
	var delReq Del{{.EntityName}}Req
	var delResp Del{{.EntityName}}Resp
	err := json.NewDecoder(req.Body).Decode(&delReq.{{.EntityName}})
	if err != nil {
		delResp.ErrCode = common.ERR_CODE_JSONERR
		delResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(delResp, w, req)
		return
	}
	defer req.Body.Close()
	var search {{.PackageName}}.Search
	search.Id = delReq.{{.EntityName}}.Id
	r := {{.PackageName}}.New(dbcomm.GetDB(), {{.PackageName}}.DEBUG)
	if e, err := r.Get(search); err == nil {
		r.Delete(fmt.Sprintf("%d", e.Id), nil)
		{{if ne .RefPackageName "" }}rr := {{.RefPackageName}}.New(dbcomm.GetDB(), {{.RefPackageName}}.DEBUG)
		rr.DeleteEx("{{.RefField}}", e.{{.RefNo}}, nil)
		{{end}}
	}
	delResp.ErrCode = common.ERR_CODE_SUCCESS
	delResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_SUCCESS]
	common.Write_Response(delResp, w, req)
	common.PrintTail("Del{{.EntityName}}")
}

/*
	说明：得到列表
	出参：参数1：返回符合条件的对象列表
*/

func Get{{.EntityName}}List(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("Get{{.EntityName}}List")
	var listReq Get{{.EntityName}}ListReq
	var listResp Get{{.EntityName}}ListResp
	err := json.NewDecoder(req.Body).Decode(&listReq.Search)
	if err != nil {
		listResp.ErrCode = common.ERR_CODE_JSONERR
		listResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(listResp, w, req)
		return
	}
	defer req.Body.Close()
	r := {{.PackageName}}.New(dbcomm.GetDB(), {{.PackageName}}.DEBUG)
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
	common.PrintTail("Get{{.EntityName}}List")
}

/*
	说明：得到实体信息
	出参：
*/

func Get{{.EntityName}}(w http.ResponseWriter, req *http.Request) {
	common.PrintHead("Get{{.EntityName}}")
	var getReq Get{{.EntityName}}Req
	var getResp Get{{.EntityName}}Resp
	err := json.NewDecoder(req.Body).Decode(&getReq.{{.EntityName}})
	if err != nil {
		getResp.ErrCode = common.ERR_CODE_JSONERR
		getResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_JSONERR]
		common.Write_Response(getResp, w, req)
		return
	}
	defer req.Body.Close()
	var search {{.PackageName}}.Search
	search.Id = getReq.{{.EntityName}}.Id
	r := {{.PackageName}}.New(dbcomm.GetDB(), {{.PackageName}}.DEBUG)
	e, err := r.Get(search)
	if err != nil {
		getResp.ErrCode = common.ERR_CODE_DBERROR
		getResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR] + err.Error()
		common.Write_Response(getResp, w, req)
	}

	{{if ne .RefPackageName "" }}rr := {{.RefPackageName}}.New(dbcomm.GetDB(), {{.RefPackageName}}.DEBUG)
	var searchEx {{.RefPackageName}}.Search
	searchEx.{{.RefNo}} = e.{{.RefNo}}
	ll, err := rr.GetList(searchEx)
	if err != nil {
		getResp.ErrCode = common.ERR_CODE_DBERROR
		getResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_DBERROR] + err.Error()
		common.Write_Response(getResp, w, req)
		return
	}{{end}}
	getResp.ErrCode = common.ERR_CODE_SUCCESS
	getResp.ErrMsg = common.ERROR_MAP[common.ERR_CODE_SUCCESS]
	getResp.{{.EntityName}} = *e

	{{if ne .RefPackageName "" }}getResp.SubList = ll
	{{end}}
	common.Write_Response(getResp, w, req)
	common.PrintTail("Get{{.EntityName}}")
}
