define({ "api": [
  {
    "type": "POST",
    "url": "/album/delete",
    "title": "删除指定专辑",
    "group": "album",
    "version": "1.0.0",
    "description": "<p>删除指定的专辑</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "albumId",
            "description": "<p>专辑ID</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"albumId\":\"4b8d5e5ec1da0fad27b786387030ecd4\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\", \"msg\":\"相册不存在\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./AlbumController.java",
    "groupTitle": "album",
    "name": "PostAlbumDelete"
  },
  {
    "type": "POST",
    "url": "/album/detail",
    "title": "获取专辑详情",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "album",
    "version": "1.0.0",
    "description": "<p>根据专辑的ID获取专辑详情</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>专辑的ID</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"id\": \"4b8d5e5ec1da0fad27b786387030ecd4\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "200": [
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>专辑id</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>专辑名称</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "cover",
            "description": "<p>专辑封面</p>"
          },
          {
            "group": "200",
            "type": "Region",
            "optional": false,
            "field": "nickName",
            "description": "<p>用户昵称</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region",
            "description": "<p>地区对象</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.country",
            "description": "<p>国家</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.province",
            "description": "<p>省</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.city",
            "description": "<p>城市</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.district",
            "description": "<p>地区</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "createDate",
            "description": "<p>专辑创建日期</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "votes",
            "description": "<p>专辑点赞数量</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "viewed",
            "description": "<p>专辑浏览数量</p>"
          },
          {
            "group": "200",
            "type": "Array",
            "optional": false,
            "field": "picList",
            "description": "<p>专辑图片列表</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "\t {\n  \"userNickName\": \"love destinesia\",\n  \"cover\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png\",\n  \"picList\": [\n   {\n     \"albumId\": \"7e3efc3f847749dfb4f0d07f2082e048\",\n     \"longitude\": 114.19084,\n     \"latitude\": 39.37021,\n     \"altitude\": 2,\n     \"regionDTO\": {\n       \"province\": \"山西省\",\n       \"city\": \"大同市\",\n       \"district\": \"灵丘县\",\n       \"id\": \"886e5a4982574ccca71f3d113513abc3\",\n       \"country\": \"中国\"\n     },\n     \"description\": \"Great Day2 pic desc\",\n     \"name\": \"Great Day2 pic\",\n     \"id\": \"ee72106de84c4cdbb89a6a47390737d5\",\n     \"type\": 0,\n     \"path\": null\n   },\n   {\n     \"albumId\": \"7e3efc3f847749dfb4f0d07f2082e048\",\n     \"longitude\": 121.47617,\n     \"latitude\": 41.672394,\n     \"altitude\": 2,\n     \"regionDTO\": {\n       \"province\": \"辽宁省\",\n       \"city\": \"锦州市\",\n       \"district\": \"义县\",\n       \"id\": \"c719d22f96b644d0b5573ba734548860\",\n       \"country\": \"中国\"\n     },\n     \"description\": \"Great Day pic desc\",\n     \"name\": \"Great Day pic\",\n     \"id\": \"0a549f3950134df9b0bd6bd09aa8daf3\",\n     \"type\": 0,\n     \"path\": null\n   }\n ],\n \"longitude\": 121.199777,\n \"latitude\": 23.840343,\n \"altitude\": 2,\n \"userGrade\": 1,\n \"picCount\": 2,\n \"token\": null,\n \"description\": \"Great Day\",\n \"name\": \"Great Day\",\n \"id\": \"7e3efc3f847749dfb4f0d07f2082e048\",\n \"region\": {\n   \"province\": \"台湾省\",\n   \"city\": \"南投县\",\n   \"district\": \"信义乡\",\n   \"id\": \"b729364b860348bea46d4ef5217e8bb6\",\n   \"country\": \"中国\"\n }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "./AlbumController.java",
    "groupTitle": "album",
    "name": "PostAlbumDetail"
  },
  {
    "type": "POST",
    "url": "/album/list",
    "title": "获取专辑列表",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "album",
    "version": "1.0.0",
    "description": "<p>获取用户专辑列表，会按照创建时间排序，最新创建的在第一个</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "int",
            "optional": false,
            "field": "type",
            "description": "<p>获取专辑类型，1为个人专辑</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"type\": 1\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "200": [
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>专辑id</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>专辑名称</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "cover",
            "description": "<p>专辑封面</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "userNickName",
            "description": "<p>用户昵称</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "userGrade",
            "description": "<p>用户等级</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "picCount",
            "description": "<p>图片数量</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "createDate",
            "description": "<p>专辑创建日期</p>"
          },
          {
            "group": "200",
            "type": "Region",
            "optional": false,
            "field": "region",
            "description": "<p>地区对象</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.country",
            "description": "<p>国家</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.province",
            "description": "<p>省</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.city",
            "description": "<p>城市</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.district",
            "description": "<p>地区</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "votes",
            "description": "<p>专辑点赞数量</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "viewed",
            "description": "<p>专辑浏览数量</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "\t [\n  {\n    \"userNickName\": \"love destinesia\",\n    \"cover\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png\",\n    \"picList\": null,\n    \"longitude\": 121.199777,\n    \"latitude\": 23.840343,\n    \"altitude\": 2,\n    \"userGrade\": 1,\n    \"picCount\": 2,\n    \"token\": null,\n    \"description\": \"Great Day\",\n    \"name\": \"Great Day\",\n    \"id\": \"7e3efc3f847749dfb4f0d07f2082e048\",\n    \"region\": {\n      \"province\": \"台湾省\",\n      \"city\": \"南投县\",\n      \"district\": \"信义乡\",\n      \"id\": \"b729364b860348bea46d4ef5217e8bb6\",\n      \"country\": \"中国\"\n    }\n  },\n  {\n    \"userNickName\": \"love destinesia\",\n    \"cover\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png\",\n    \"picList\": null,\n    \"longitude\": 121.199777,\n    \"latitude\": 23.840343,\n    \"altitude\": 2,\n    \"userGrade\": 1,\n    \"picCount\": 2,\n    \"token\": null,\n    \"description\": \"Great Day\",\n    \"name\": \"Great Day\",\n    \"id\": \"d63899b95bfb4f8c8894a544d2314e03\",\n    \"region\": {\n      \"province\": \"台湾省\",\n      \"city\": \"南投县\",\n\t     \"district\": \"信义乡\",\n      \"id\": \"b729364b860348bea46d4ef5217e8bb6\",\n      \"country\": \"中国\"\n    }\n  }\n\t]",
          "type": "json"
        }
      ]
    },
    "filename": "./AlbumController.java",
    "groupTitle": "album",
    "name": "PostAlbumList"
  },
  {
    "type": "POST",
    "url": "/album/listbyloc",
    "title": "根据距离获取专辑列表",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "album",
    "version": "1.0.0",
    "description": "<p>获取用户专辑列表，会按照创建时间排序，最新创建的在第一个</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "float",
            "optional": false,
            "field": "lat",
            "description": "<p>纬度</p>"
          },
          {
            "group": "Parameter",
            "type": "float",
            "optional": false,
            "field": "lon",
            "description": "<p>经度</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"lat\": \"23.8403430000\", \n   \"lon\": \"121.1997770000\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "200": [
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>专辑id</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>专辑名称</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "cover",
            "description": "<p>专辑封面</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "userNickName",
            "description": "<p>用户昵称</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "userGrade",
            "description": "<p>用户等级</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "picCount",
            "description": "<p>图片数量</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "createDate",
            "description": "<p>专辑创建日期</p>"
          },
          {
            "group": "200",
            "type": "Region",
            "optional": false,
            "field": "region",
            "description": "<p>地区对象</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.country",
            "description": "<p>国家</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.province",
            "description": "<p>省</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.city",
            "description": "<p>城市</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "region.district",
            "description": "<p>地区</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "votes",
            "description": "<p>专辑点赞数量</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "viewed",
            "description": "<p>专辑浏览数量</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "\t [\n  {\n    \"userNickName\": \"love destinesia\",\n    \"cover\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png\",\n    \"picList\": null,\n    \"longitude\": 121.199777,\n    \"latitude\": 23.840343,\n    \"altitude\": 2,\n    \"userGrade\": 1,\n    \"picCount\": 2,\n    \"token\": null,\n    \"description\": \"Great Day\",\n    \"name\": \"Great Day\",\n    \"id\": \"7e3efc3f847749dfb4f0d07f2082e048\",\n    \"region\": {\n      \"province\": \"台湾省\",\n      \"city\": \"南投县\",\n      \"district\": \"信义乡\",\n      \"id\": \"b729364b860348bea46d4ef5217e8bb6\",\n      \"country\": \"中国\"\n    }\n  },\n  {\n    \"userNickName\": \"love destinesia\",\n    \"cover\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png\",\n    \"picList\": null,\n    \"longitude\": 121.199777,\n    \"latitude\": 23.840343,\n    \"altitude\": 2,\n    \"userGrade\": 1,\n    \"picCount\": 2,\n    \"token\": null,\n    \"description\": \"Great Day\",\n    \"name\": \"Great Day\",\n    \"id\": \"d63899b95bfb4f8c8894a544d2314e03\",\n    \"region\": {\n      \"province\": \"台湾省\",\n      \"city\": \"南投县\",\n\t     \"district\": \"信义乡\",\n      \"id\": \"b729364b860348bea46d4ef5217e8bb6\",\n      \"country\": \"中国\"\n    }\n  }\n\t]",
          "type": "json"
        }
      ]
    },
    "filename": "./AlbumController.java",
    "groupTitle": "album",
    "name": "PostAlbumListbyloc"
  },
  {
    "type": "POST",
    "url": "/album/view",
    "title": "增加专辑流量次数",
    "group": "album",
    "version": "1.0.0",
    "description": "<p>增加专辑流量次数，因为用户可以不登录，所以不需要用户id</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "albumId",
            "description": "<p>专辑ID</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "deviceNO",
            "description": "<p>专辑ID</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"albumId\":\"4b8d5e5ec1da0fad27b786387030ecd4\",\n\t  \"deviceNO\":\"dxedwewew\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\", \"msg\":\"相册不存在\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./AlbumController.java",
    "groupTitle": "album",
    "name": "PostAlbumView"
  },
  {
    "type": "PUT",
    "url": "/album/save",
    "title": "新建/更新已有专辑",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "album",
    "version": "1.0.0",
    "description": "<p>新建/更新已有专辑，如果id为空，就代表添加，否则为更新</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>专辑id</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>专辑名称</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "desc",
            "description": "<p>专辑描述</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "cover",
            "description": "<p>专辑封面</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "latitude",
            "description": "<p>纬度</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "longitude",
            "description": "<p>经度</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "altitude",
            "description": "<p>海拔</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "pics",
            "description": "<p>图片列表</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pics.path",
            "description": "<p>图片地址</p>"
          },
          {
            "group": "Parameter",
            "type": "int",
            "optional": false,
            "field": "pics.type",
            "description": "<p>图片类型，1为图片，2为视频，3为AR</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pics.name",
            "description": "<p>图片名称</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pics.desc",
            "description": "<p>图片描述</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pics.latitude",
            "description": "<p>图片拍摄点的纬度</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pics.longitude",
            "description": "<p>图片拍摄点的经度</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pics.altitude",
            "description": "<p>图片拍摄点的海拔</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{ \n\t\"token\": \"690208343a974ba0a1146ccd81b7757d\",\n\t\"name\": \"Great Day\",\n\t\"description\": \"Great Day\",\n\t\"longitude\": 121.199777,\n\t\"latitude\": 23.840343,\n\t\"altitude\": 2,\n\t\"cover\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png\",\n\t\"picList\": [\n\t  {\n\t    \"name\": \"Great Day pic\",\n\t    \"type\": 1,\n\t    \"path\": \"http://7xlovk.com2.z0.glb.qiniucdn.com/exchange/upload/roomPhoto/20160816/147133686654354.jpeg\",\n\t    \"description\": \"Great Day pic desc\",\n\t    \"longitude\": 121.47617,\n\t    \"latitude\": 41.672394,\n\t\t\"altitude\": 2\n\t  },\n\t  {\n\t    \"name\": \"Great Day2 pic\",\n\t    \"type\": 1,\n\t    \"path\": \"http://7xlovk.com2.z0.glb.qiniucdn.com/exchange/upload/roomPhoto/20160816/147133686654480.jpeg\",\n\t    \"description\": \"Great Day2 pic desc\",\n\t    \"longitude\": 114.19084,\n\t    \"latitude\": 39.37021,\n\t\t\"altitude\": 2\n\t  }\n\t]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\", \"msg\":\"名称不能为空\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./AlbumController.java",
    "groupTitle": "album",
    "name": "PutAlbumSave"
  },
  {
    "type": "POST",
    "url": "/picture/unvote",
    "title": "为图片取消点赞",
    "group": "picture",
    "version": "1.0.0",
    "description": "<p>为图片取消点赞</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "albumId",
            "description": "<p>专辑ID</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pictureId",
            "description": "<p>图片ID</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"albumId\":\"4b8d5e5ec1da0fad27b786387030ecd4\",\n\t  \"pictureId\":\"51cd003dd9605f4a6756ff537b3d96a4\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\", \"msg\":\"相册不存在\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./PicturesController.java",
    "groupTitle": "picture",
    "name": "PostPictureUnvote"
  },
  {
    "type": "POST",
    "url": "/picture/vote",
    "title": "为图片点赞",
    "group": "picture",
    "version": "1.0.0",
    "description": "<p>为图片点赞</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "albumId",
            "description": "<p>专辑ID</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "pictureId",
            "description": "<p>图片ID</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"albumId\":\"4b8d5e5ec1da0fad27b786387030ecd4\",\n\t  \"pictureId\":\"51cd003dd9605f4a6756ff537b3d96a4\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\", \"msg\":\"相册不存在\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./PicturesController.java",
    "groupTitle": "picture",
    "name": "PostPictureVote"
  },
  {
    "type": "POST",
    "url": "/user/login",
    "title": "用户登录",
    "group": "user",
    "version": "1.0.0",
    "description": "<p>用于用户登录</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "key",
            "description": "<p>用户邮箱/用户昵称</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>密码，MD5加密</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"key\":\"traval@destinesia.cn\",\n\t  \"password\":\"e10adc3949ba59abbe56e057f20f883e\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "200": [
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "nickName",
            "description": "<p>用户昵称</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "grade",
            "description": "<p>代表等级，1为1星，5为5星</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "token",
            "description": "<p>用户身份TOKEN</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\n   \"nickName\":\"love destinesia\",\n   \"grade\":3,\n   \"token\":\"ce94db3b1fd69b7c03308faf2cc912d8\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\",\"msg\":\"用户不存在\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./UserController.java",
    "groupTitle": "user",
    "name": "PostUserLogin"
  },
  {
    "type": "POST",
    "url": "/user/recommend",
    "title": "邀请码验证",
    "group": "user",
    "version": "1.0.0",
    "description": "<p>用于验证用户邀请码是否正确</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "recommend",
            "description": "<p>邀请码</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\"recommend\":\"wk68vn3d\"}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "200": [
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "grade",
            "description": "<p>代表等级，1为1星，5为5星</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"grade\":\"3\"}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\",\"msg\":\"邀请码为空\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./UserController.java",
    "groupTitle": "user",
    "name": "PostUserRecommend"
  },
  {
    "type": "POST",
    "url": "/user/register",
    "title": "注册用户",
    "group": "user",
    "version": "1.0.0",
    "description": "<p>用于注册用户</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "nickName",
            "description": "<p>昵称</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "name",
            "description": "<p>账号</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>密码，MD5加密返回</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "mail",
            "description": "<p>邮箱</p>"
          },
          {
            "group": "Parameter",
            "type": "double",
            "optional": false,
            "field": "lat",
            "description": "<p>维度</p>"
          },
          {
            "group": "Parameter",
            "type": "double",
            "optional": false,
            "field": "lon",
            "description": "<p>经度</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "deviceId",
            "description": "<p>硬件设备号</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "recommend",
            "description": "<p>推荐码</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "inviteCode",
            "description": "<p>邀请码</p>"
          },
          {
            "group": "Parameter",
            "type": "int",
            "optional": false,
            "field": "plantform",
            "defaultValue": "0",
            "description": "<p>平台 0 IOS 1 Android</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n  \"nickName\": \"love destinesia\",\n  \"name\":\"love_desti\",\n  \"phone\":\"15888888888\",\n  \"password\": \"e10adc3949ba59abbe56e057f20f883e\",\n  \"mail\": \"traval@destinesia.cn\",\n  \"deviceNO\": \"1FD69B7C03308FAF\",\n  \"recommend\":\"wk68vn3d\",\n  \"inviteCode\":\"113323\",\n  \"lat\":114.190841674805,\n  \"lon\":121.476173400879\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "200": [
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "nickName",
            "description": "<p>用户昵称</p>"
          },
          {
            "group": "200",
            "type": "int",
            "optional": false,
            "field": "grade",
            "description": "<p>代表等级，1为1星，5为5星</p>"
          },
          {
            "group": "200",
            "type": "String",
            "optional": false,
            "field": "token",
            "description": "<p>用户身份TOKEN</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\n   \"nickName\":\"love destinesia\",\n   \"grade\":3,\n   \"token\":\"ce94db3b1fd69b7c03308faf2cc912d8\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\",\"msg\":\"XX为空\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./UserController.java",
    "groupTitle": "user",
    "name": "PostUserRegister"
  },
  {
    "type": "POST",
    "url": "/user/reset",
    "title": "获取/重置密码",
    "group": "user",
    "version": "1.0.0",
    "description": "<p>帮助用户重置密码，并返回用户</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "mail",
            "description": "<p>用户邮箱</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "请求样例：",
          "content": "{\n\t  \"mail\":\"traval@destinesia.cn\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "400": [
          {
            "group": "400",
            "type": "String",
            "optional": false,
            "field": "msg",
            "description": "<p>信息</p>"
          },
          {
            "group": "400",
            "type": "int",
            "optional": false,
            "field": "code",
            "description": "<p>数字</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "返回样例:",
          "content": "{\"code\":\"1\", \"msg\":\"用户不存在\"}",
          "type": "json"
        }
      ]
    },
    "filename": "./UserController.java",
    "groupTitle": "user",
    "name": "PostUserReset"
  }
] });
