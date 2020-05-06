CREATE TABLE `business` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '工程ID',
  `project_no` int(11) DEFAULT '0' COMMENT '工程名称',
  `business_no` int(11) DEFAULT '0',
  `business_name` varchar(64) DEFAULT '' COMMENT '工程描述',
  `business_desc` varchar(128) DEFAULT '' COMMENT '后台SRC路径',
  `go_filename` varchar(64) DEFAULT '' COMMENT '修改时间',
  `go_package` varchar(64) DEFAULT NULL COMMENT '修改时间',
  `vue_filename` varchar(64) DEFAULT '' COMMENT '修改时间',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '新建时间',
  `version` int(11) DEFAULT '0' COMMENT '版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

CREATE TABLE `business_table` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '工程ID',
  `business_no` int(11) NOT NULL COMMENT '工程名称',
  `project_no` int(11) NOT NULL COMMENT '工程描述',
  `table_name` varchar(128) NOT NULL DEFAULT '' COMMENT '后台SRC路径',
  `is_master` tinyint(1) DEFAULT NULL,
  `ref_field_name` varchar(64) DEFAULT NULL COMMENT '修改时间',
  `key_field_name` varchar(64) DEFAULT NULL COMMENT '修改时间',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '新建时间',
  `version` int(11) DEFAULT '0' COMMENT '版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `project` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '工程ID',
  `project_no` int(11) NOT NULL COMMENT '工程编号',
  `project_name` varchar(128) DEFAULT '' COMMENT '工程名称',
  `project_desc` varchar(256) DEFAULT '' COMMENT '工程描述',
  `go_path` varchar(128) DEFAULT '' COMMENT '后台SRC路径',
  `vue_path` varchar(128) DEFAULT '' COMMENT '前端SRC路径',
  `db_url` varchar(128) DEFAULT '' COMMENT '数据库URL',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '新建时间',
  `version` int(11) DEFAULT '0' COMMENT '版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `table_define` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '工程ID',
  `project_no` int(11) DEFAULT NULL,
  `business_no` int(11) DEFAULT NULL,
  `table_name` varchar(64) NOT NULL DEFAULT '' COMMENT '工程名称',
  `field_name` varchar(50) NOT NULL DEFAULT '' COMMENT '工程描述',
  `field_type` varchar(10) DEFAULT '',
  `field_len` int(11) DEFAULT NULL COMMENT '修改时间',
  `field_desc` varchar(128) NOT NULL DEFAULT '' COMMENT '后台SRC路径',
  `input_type` varchar(2) DEFAULT '0' COMMENT '版本',
  `is_insert` tinyint(1) DEFAULT '0' COMMENT '版本',
  `version` int(11) DEFAULT '0' COMMENT '版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;