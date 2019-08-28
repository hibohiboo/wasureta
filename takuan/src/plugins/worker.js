onmessage = function (e) {
  console.log('読込開始');
  const startTime = performance.now(); // 開始時間

  var workerResult = 'Result: ' + (e.data["plugins"]);
  console.log('Posting message back to main script');
  importScripts('/plugins/room.js');
  importScripts('//use.fontawesome.com/releases/v5.10.2/js/all.js'); /* 他のオリジンのスクリプトをインポートすることができる */
  this.postMessage('load completed');
}

