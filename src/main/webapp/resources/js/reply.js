
console.log("Reply Module........");

var replyService = (function () {
  function add(reply, callback, error) {
    console.log("reply...............");
    $.ajax({
      type: "post",
      url: "/replies/new",
      data: JSON.stringify(reply),
      contentType: "application/json; charset=utf-8",
      success: function (result, status, xhr) {
        if (callback) {
          callback(result);
        }
      },
      error: function (xhr, status, er) {
        if (error) {
          error(er);
        }
      },
    });
  }

  function getList(param, callback, error) {
    //전체데이타 가져오기
    var bno = param.bno;

    var page = param.page || 1;

    $.ajax({
      type: "get",
      url: "/replies/pages/" + bno + "/" + page + ".json",

      success: function (result, status, xhr) {
        if (callback) {
          callback(result);
        }
      },
      error: function (xhr, status, er) {
        if (error) {
          error(er);
        }
      },
    });
  }

  function remove(rno, callback, error){
    $.ajax({
      type:"delete",
      url:"/replies/"+rno,

      success: function(result,status,xhr){
        if(callback){
          callback(result);
        }
      },
  
    error:function (xhr,status,er){
      if(error){
        error(er);
      }
    },
  });
  }

  function update(reply, callback, error) {
    //테이타 수정
    $.ajax({
      type: "put",
      url: "/replies/" + reply.rno,
      data: JSON.stringify(reply),
      contentType: "application/json; charset=utf-8",

      success: function (result, status, xhr) {
        if (callback) {
          callback(result);
        }
      },
      error: function (xhr, status, er) {
        if (error) {
          error(er);
        }
      },
    });
  }
  function get(rno, callback, error) {
    //단건 데이타 가져오기
    $.ajax({
      type: "get",
      url: "/replies/" + rno + ".json",

      success: function (result, status, xhr) {
        if (callback) {
          callback(result);
        }
      },
      error: function (xhr, status, er) {
        if (error) {
          error(er);
        }
      },
    });
  }

  function displayTime(timeValue) {
    var today = new Date();
    var gap = today.getTime() - timeValue;  // `=` 연산자 오류 수정
    var dateObj = new Date(timeValue);
    var str = "";

    // 24시간 이내의 시간 표시
    if (gap < (1000 * 60 * 60 * 24)) {
        var hh = dateObj.getHours();
        var mi = dateObj.getMinutes();
        var ss = dateObj.getSeconds();

        return [(hh > 9 ? "" : '0') + hh, ':', (mi > 9 ? "" : '0') + mi, ':', (ss > 9 ? "" : '0') + ss].join('');
    } else {
        // 날짜가 24시간 이상이면 년/월/일 형태로 표시
        var yy = dateObj.getFullYear();
        var mm = dateObj.getMonth() + 1;  // 월은 0부터 시작하므로 1을 더해줘야 함
        var dd = dateObj.getDate();  // `dd`를 정의해야 함

        return [yy, '/', (mm > 9 ? "" : '0') + mm, '/', (dd > 9 ? "" : '0') + dd].join('');
    }
}

return {
    add: add,
    getList: getList,
    remove: remove,
    update: update,
    get: get,
    displayTime: displayTime,
};

})();

