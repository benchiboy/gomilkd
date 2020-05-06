<template>
  <div >
	<div class="d-flex justify-content-center">
	    <b-modal
	  		id="manage-modal-add"
	  		ref="modal"
	  		title="新增[[.EntityDesc]]"
	  		scrollable
	  		@show="showModalAdd"
	  		@hidden="hiddenModal"
	  		size="lg"
	  		@ok="handleAddOk">
			<template slot="modal-footer" slot-scope="{ ok, cancel, hide }">
				<b-button size="md" variant="success" @click="ok()">
					确定
				</b-button>
				<b-button size="md" variant="danger" @click="cancel()">
					取消
				</b-button>
			</template>
	        <form ref="form" @submit.stop.prevent="handleOk" >
	  			[[range .ColInserts]]<label for="[[.ColTagName]]">[[.ColComment]]</label>
					<b-input autofocus=true v-on:blur="busiNoCheck()" v-model="form.[[.ColTagName]]" 
					:state="[[.ColTagName]]_state" id="[[.ColTagName]]"  >
					</b-input>
				<b-form-invalid-feedback :state="[[.ColTagName]]_state">
					模块名称不能为空且不能重复！
				</b-form-invalid-feedback>
				<b-form-valid-feedback :state="[[.ColTagName]]_state">
					校验通过
				</b-form-valid-feedback>
			
				[[end]]
			</form>
			
		 [[if ne .RefTableName "" ]]
			<div class="mt-1 " >
				<div class="d-flex justify-content-between">
				 <label class="text-primary">系统模块包括的菜单：</label>
				 <b-button size="sm" variant="outline-info"  class="mb-1" @click="addSubItem()">
					<b-icon font-scale="1.5" icon="plus" aria-hidden="true"></b-icon>
					<span class="sr-only">Help</span>
				 </b-button>
				</div>

				<b-form  class="mt-1 d-flex justify-content-between"  v-for="(subItem,key) in subList">
				[[range .SubColInserts]]				
							<label class="sr-only" for="[[.ColTagName]]">[[.ColComment]]</label>
							<b-input-group prepend="菜单名称" class="mb-2 mr-sm-2 mb-sm-0">
							  	<b-input id="[[.ColTagName]]"  v-model="subItem.[[.ColTagName]]" 
							   	 :state="subItem.[[.ColTagName]]_state"	placeholder="[[.ColComment]]">
								</b-input>
								<b-form-invalid-feedback :state="subItem.[[.ColTagName]]_state">
									[[.ColComment]]不能为空
								</b-form-invalid-feedback>
								<b-form-valid-feedback :state="subItem.[[.ColTagName]]_state">
									校验通过
								</b-form-valid-feedback>
							</b-input-group>
				[[end]]			
					<b-button size="sm" variant="outline-info" class="ml-2" @click="delSubItem(subItem.id)">
						<b-icon  font-scale="1.5" icon="trash" aria-hidden="true"></b-icon>
					</b-button>

				</b-form>
	  	 	</div > [[end]]

	    </b-modal>


		<b-modal
			id="manage-modal-edit"
			ref="modal2"
			title="修改组"
			scrollable
			@show="showModalEdit"
			@hidden="hiddenModal"
			size="lg"
			@ok="handleEditOk"
		  >
			<template slot="modal-footer" slot-scope="{ ok, cancel, hide }">
				<b-button size="md" variant="success" @click="ok()">
					确定
				</b-button>
				<b-button size="md" variant="danger" @click="cancel()">
					取消
				</b-button>
			</template>
		    <form ref="form" @submit.stop.prevent="handleOk" >
				[[range .ColInserts]]<label for="[[.ColTagName]]">[[.ColComment]]</label>
					<b-input autofocus=true v-on:blur="busiNoCheck()" v-model="form.[[.ColTagName]]" 
					:state="[[.ColTagName]]_state" id="[[.ColTagName]]"  >
					</b-input>
				<b-form-invalid-feedback :state="[[.ColTagName]]_state">
					模块名称不能为空且不能重复！
				</b-form-invalid-feedback>
				<b-form-valid-feedback :state="[[.ColTagName]]_state">
					校验通过
				</b-form-valid-feedback>
			
				[[end]]
			</form>
			
		

 			[[if ne .RefTableName "" ]]
			<div class="mt-1 " >
				<div class="d-flex justify-content-between">
				 <label class="text-primary">系统模块包括的菜单：</label>
				 <b-button size="sm" variant="outline-info"  class="mb-1" @click="addSubItem()">
					<b-icon font-scale="1.5" icon="plus" aria-hidden="true"></b-icon>
					<span class="sr-only">Help</span>
				 </b-button>
				</div>

				<b-form  class="mt-1 d-flex justify-content-between"  v-for="(subItem,key) in subList">
				[[range .SubColInserts]]				
							<label class="sr-only" for="[[.ColTagName]]">[[.ColComment]]</label>
							<b-input-group prepend="菜单名称" class="mb-2 mr-sm-2 mb-sm-0">
							  	<b-input id="[[.ColTagName]]"  v-model="subItem.[[.ColTagName]]" 
							   	 :state="subItem.[[.ColTagName]]_state"	placeholder="[[.ColComment]]">
								</b-input>
								<b-form-invalid-feedback :state="subItem.[[.ColTagName]]_state">
									[[.ColComment]]不能为空
								</b-form-invalid-feedback>
								<b-form-valid-feedback :state="subItem.[[.ColTagName]]_state">
									校验通过
								</b-form-valid-feedback>
							</b-input-group>
				[[end]]			
					<b-button size="sm" variant="outline-info" class="ml-2" @click="delSubItem(subItem.id)">
						<b-icon  font-scale="1.5" icon="trash" aria-hidden="true"></b-icon>
					</b-button>

				</b-form>
	  	 	</div > [[end]]

		</b-modal>
	</div>
		
	<div style="" class="text-left ml-3 m">
		<strong class="text-primary border-left  border-success">查询条件</strong>
	</div>
	<b-container fluid class="mt-2">
		<b-row>
		</b-row>
		<b-row>
			<b-col md="4" class="my-1">
				<b-form-group label-cols-sm="3" label="系统名称" class="mb-0">
					<b-input-group>
						<b-form-input v-model="search.group_name" placeholder="系统名称"></b-form-input>
					</b-input-group>
				</b-form-group>
			</b-col>
			<b-col md="1" class="my-1">
					<b-button variant="outline-info"  @click="onSearchData">
						<b-icon  font-scale="1.5" icon="search" aria-hidden="true"></b-icon>
					</b-button>
			</b-col>
		</b-row>
 
		<b-table
			ref="table"
			class="mt-1 "
			bordered
			striped hover
			caption-html="<strong class='text-primary border-left  border-success'>系统列表</strong>"
			caption-top="true"
			show-empty
			stacked="md"
			:busy.sync="isBusy"
			:items="items"
			:fields="fields"
			:current-page="form.page_no"
			:per-page=0
			:filter="filter"
			:sort-by.sync="sortBy"
			:sort-desc.sync="sortDesc"
			sort-icon-left
			:sort-direction="sortDirection"
			head-variant="primary"
			thead-class="table-primary"
			@filtered="onFiltered"
			@row-dblclicked="onDbClicked"
			@sort-changed="onSorted"
		>
		<template v-slot:cell(index)="data">
			{{ data.index + 1 }}
		</template>
		
		<template slot="empty" slot-scope="scope">
			<h5>没有查询到设备数据！</h5>
		</template>

		<template v-slot:cell(status)="data">
			<span  v-if="data.value=='e'" >启用</span>
			<span  v-if="data.value=='b'"  calss="border-primary">禁用</span>
		</template>
		
		<template v-slot:cell(oper)="data">
			<b-button size="sm" variant="outline-info" v-b-modal.manage-modal-edit class="ml-2" @click="getInfo(data.item.id)">
				<b-icon  font-scale="1.5" icon="pencil" aria-hidden="true"></b-icon>
				<span class="sr-only">Help</span>
			</b-button>
			
			<b-button size="sm" variant="outline-info" class="ml-2" @click="delInfo(data.item.id,data.item.group_name)">
				<b-icon  font-scale="1.5" icon="trash" aria-hidden="true"></b-icon>
				<span class="sr-only">Help</span>
			</b-button>
		</template>
		</b-table>

		<b-row class="d-flex  align-items-center">
			<b-col md="4" class="my-1">
				<strong>
					数据总共：{{totalRows}}条，每页{{search.page_size}}条，当前页：{{search.page_no}}
				</strong>
			</b-col>

			<b-col md="4" class="my-1">
				<b-pagination
				v-model="search.page_no"
				:total-rows="totalRows"
				:per-page="search.page_size"
				class="my-0"
				@change="onChange"
				></b-pagination>
			</b-col>
			<b-col md="4" class="my-1">
				<b-button v-b-modal.manage-modal-add variant="outline-info">  
				<b-icon  font-scale="1.5" icon="plus" aria-hidden="true"></b-icon>
				新增系统</b-button>
			</b-col>
		</b-row>
  	</b-container>
	<div  class="text-center text-danger  loading"  v-show="is">
			<b-spinner class="align-middle"  role="status" >
			</b-spinner>
			<strong>loading...</strong>
	</div>
 </div>
</template>

<script>
  import GLOBAL from './Global.js'
  import Util from './Util.js';
  export default {
    data() {
      return {
		isBusy: false,
		items:  [],
        fields: [
				'index',
				[[range .ColInserts]]{ key: '[[.ColTagName]]', 	label: '[[.ColComment]]' },
				[[end]]
				{ key: 'oper', 			label: '操作' },   			
			],
		form:{
			[[range .Cols]][[if or (eq .ColType "int64") (eq .ColType "int") ]][[.ColTagName]]:0, [[end]][[if eq .ColType "string" ]][[.ColTagName]]:"",[[end]]
			[[end]]		
		},
		post_form:{
			[[.PackageName]]:this.form,
			list:[],
		},
		search:{
				sort_fld: "id",
				sort_mode:"desc",
				[[range .ColInserts]][[if or (eq .ColType "int64") (eq .ColType "int") ]][[.ColTagName]]:0, [[end]][[if eq .ColType "string" ]][[.ColTagName]]:"",[[end]]
				[[end]]		
				page_no: 1,
				page_size: 7,
		},
		subList:[
			{
				[[range .SubColInserts]][[if or (eq .ColType "int64") (eq .ColType "int") ]][[.ColTagName]]:0, [[end]][[if eq .ColType "string" ]][[.ColTagName]]:"",[[end]]
				[[end]]		
			}
		],
	    totalRows: 1,
        pageOptions: [8, 10, 15],
        sortBy: null,
	    sortDesc: false,
        sortDirection: 'asc',
        filter: null,
		isSubmit:false,
		checkPass:true,
		isRepeat:false,
	    infoModal: {
          id: 'info-modal',
          title: '',
          content: ''
        }
      }
    },
    computed: {
		sortOptions() {
			return this.fields
				.filter(f => f.sortable)
				.map(f => {
				return { text: f.label, value: f.key }
          })
		},
		group_name_state() {
			if  (!this.isSubmit){
				return null;
			}
			return this.form.group_name.length!=""
		},
	},
	
    mounted() {
		this.getList()
	},

	watch: {
		subList: {
	　　　　handler(newValue, oldValue) {
	　　　　　　for (let i = 0; i < newValue.length; i++) {
				if (this.subList[i].url_check==null&&
					this.subList[i].menu_name_check==null){
					console.log("===========",newValue)
					return
				}else{
					console.log("===========",newValue)
					this.preCheckSubForm(newValue,"watch")
				}
	　　　　　　}
	　　　　},
	　　　　deep: true
	　　}
　　},

    methods: {
		statusColor(item) {
			return item.type
		},
			
		onFiltered(filteredItems) {
			// Trigger pagination to update the number of buttons/pages due to filtering
			this.totalRows = filteredItems.length
			this.currentPage = 1
		},
	
		onDbClicked(filteredItems) {
			console.log(filteredItems)
			
		},
			
		onSorted(ctx) {
			if (ctx.sortDesc){			
				this.search.sort_mode="desc"
			}else{
				this.search.sort_mode="asc"
			}
			this.search.sort_fld=ctx.sortBy
			this.search.page_no=1
			this.getList();
		},
		/*
			子表单增加明细
		*/
		addSubItem() {
			let maxNum=0;
			if (this.subList.length>0){
				maxNum=this.subList[0].id
			}
			for(let i = 1,len = this.subList.length;i<len;i++){
            	if  (maxNum<this.subList[i].id){
					maxNum = this.subList[i].id;
				}
			}
			maxNum=maxNum+1
			this.subList.push({menu_name:'',url:'',id:maxNum,
							menu_name_check:null,url_check:null})
		},
		
		delSubItem(id) {
			this.subList.forEach(function(x, index, arr){
				if (id==x.id){
					arr.splice(index,1)
				}
			});
		},
			
		onHovered(ctx) {
			console.log("=======>",ctx)
		},

		onChange(page){
			this.search.page_no=page
			this.getList()
		},
		
		onSearchData(){
			this.search.page_no=1
			this.getList()
		},
		
		checkFormValidity() {
			const valid = this.$refs.form.checkValidity()
			return valid
		},
		/*
		*/
		preCheckSubForm(listArr,type){
			//新增子表格，Watch 会触发这个事件
			for(let i = 0,len = listArr.length;i<len;i++){
				if (listArr[i].menu_name==""){
					this.subList[i].menu_name_check=false
				}else{
					this.subList[i].menu_name_check=true
				}
				if (listArr[i].url==""){
					this.subList[i].url_check=false
				}else{
					this.subList[i].url_check=true
				}
			}
			let iSum=0
			for(let i = 0,len = listArr.length;i<len;i++){
				if (listArr[i].url_check==false||listArr[i].menu_name_check==false){
					this.checkPass=false
					break
				}else{
					iSum++
				}
			}
			if (iSum==listArr.length){
				this.checkPass=true
			}
		},

		checkFormInput(){
			if (!this.group_name_state){
				this.checkPass=false
			}
			if (this.subList.length>0){
				this.preCheckSubForm(this.subList,"submit")
			}
		},

		busiNoCheck(){
			var that=this;
			this.post_form.group=this.form
			if (this.form.group_name==""){
				return
			}
			this.$axios.post(GLOBAL.URL_CHKGROUP, 
								JSON.stringify(this.post_form))
								.then(function (response) {
							if (response.data.err_code=="0000"){
								that.isRepeat=false
							}else{
								that.isRepeat=true
								that.toast("模板名称重复了，请重新输入")
							}
						})
				.catch(function (error) {
						that.toast("出错了:"+error)
			}); 		
		},
	
		handleAddOk(evt) {
			this.isSubmit=true
			this.checkPass=true
			this.checkFormInput()
			
			if (!this.checkPass){
				evt.preventDefault()
			 	return;
			}
			if (this.isRepeat){
				evt.preventDefault()
				return;
			}
			if (!this.checkFormValidity()) {
				return
			}
			this.$nextTick(() => {
			this.$refs.modal.hide()
				this.addInfo()
			})
		},

		handleEditOk(evt) {
			this.isSubmit=true;
			
			this.checkPass=true

			this.checkFormInput()
			
			if (!this.checkPass){
				evt.preventDefault()
			 	return;
			}
			
			if (this.isRepeat){
				evt.preventDefault()
				return;
			}

			this.$nextTick(() => {
				this.$refs.modal2.hide()
				this.setInfo()
			})
		},
		
		showModalAdd(evt) {
			this.isSubmit=false;
			this.form.group_name=""
			this.form.group_memo=""
			this.subList=[]
		},
		
		showModalEdit(evt) {
		
		},
			
		toast(tip) {
				this.$bvToast.toast(tip, {
				title: `执行结果`,
				toaster: 'b-toaster-top-center',
				solid: true,
				variant: 'info',
				autoHideDelay:1000,
				appendToast: false
			})
		},
			
		prevPage() {
			if (this.search.page_no>1){
				this.search.page_no--
				this.getList()
			}
		},
		
		goPage(pageNo) {
			this.search.page_no=pageNo
			this.getList()
		},
		nextPage() {
			console.log("this.totalPage",this.totalPage,this.search.page_no)
			if (this.search.page_no<this.totalPage){
				this.search.page_no++
				this.getList()
			}
		},
		/**/
		getList(){
			var that=this;
			//that.isBusy=true
			this.$axios.post(GLOBAL.URL_GET[[.PackageUrl]]_LIST, 
						JSON.stringify(this.search),
						{headers: {'Content-Type': 'application/json'}})
						.then(function (response) {
							that.items=response.data.list
							that.totalRows = response.data.total
						})
				.catch(function (error) {
					that.toast("出错了:"+error)
			}); 		
		},
		/* 新增*/
		addInfo() {
			var that=this;
			this.post_form.list=this.subList
			this.post_form.group=this.form
			//alert(JSON.stringify(this.post_form))
			this.$axios.post(GLOBAL.URL_ADD[[.PackageUrl]], 
								JSON.stringify(this.post_form))
								.then(function (response) {
							if (response.data.err_code=="0000"){
								that.toast(response.data.err_msg)
								that.search.page_no=1
								that.search.sort_fld="id"
								that.search.sort_mode="desc"
								that.getList();
							}else{
								that.toast(response.data.err_msg)
							}
						})
				.catch(function (error) {
						that.toast("出错了:"+error)
			}); 		
		},
		/* 修改提交*/
		setInfo() {
			var that=this;
			this.post_form.list=this.subList
			this.post_form.group=this.form
			this.$axios.post(GLOBAL.URL_SET[[.PackageUrl]], 
							JSON.stringify(this.post_form))
							.then(function (response) {
								if (response.data.err_code=="0000"){
									that.toast(response.data.err_msg)
									that.getList();
								}else{
									that.toast(response.data.err_msg)
								}
							})
				.catch(function (error) {
						that.toast("出错了:"+error)
				}); 		
			},
			
		/* 得到用户信息*/
		getInfo(id) {
			var that=this;
			this.form.id=id
			that.subList={}
			this.$axios.post(GLOBAL.URL_GET[[.PackageUrl]], 
						JSON.stringify(this.form))
						.then(function (response) {
							that.form=response.data.group
							/* 
								有子表单时才出现
							*/
							that.subList=response.data.list
								for(let i = 0,len = that.subList.length;i<len;i++){
									that.subList[i].menu_name_check=true
									that.subList[i].url_check=true
								}
						})
				.catch(function (error) {
						that.toast("出错了:"+error)
				}); 		
		},
			
		/* 删除信息*/
		delInfo(id,desc) {
			var that=this;
			let tip='你确认要删除 '+desc+' 吗?'
			this.$bvModal.msgBoxConfirm(tip, {
				title: '删除确认',
				size: 'sm',
				buttonSize: 'sm',
				okVariant: 'danger',
				okTitle: '确定',
				cancelTitle: '取消',
				footerClass: 'p-2',
				hideHeaderClose: false,
				centered: true
			}) 
			.then(value => {
				if (value){
					this.form.id=id,
					this.$axios.post(GLOBAL.URL_DEL[[.PackageUrl]],JSON.stringify(this.form))
							.then(function (response) {
								if (response.data.err_code=="0000"){
									that.toast(response.data.err_msg)
									that.getList();
								}else{
									that.toast(response.data.err_msg)
								}
							})
							.catch(function (error) {
								that.toast("出错了:"+error)
							}); 		
						}
				})
				.catch(err => {
					
			})
		},
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.map{
	height: 650px;
	width:auto;
	border: 1px solid red;
}
.loading{
		position: absolute;
		z-index: 1999;
		top: 300px;
		left: 400px;
		width: 20%;
}

.statusColor{
	background: red;
	background-color: #42B983;
}
</style>
