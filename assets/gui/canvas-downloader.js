const canvas = document.getElementsByTagName("canvas")[0];

canvas.toBlob(function (blob) {
  var url = window.URL.createObjectURL(blob);

  var xhr = new XMLHttpRequest();
  xhr.open("GET", url, true);
  xhr.responseType = "blob";
  xhr.onload = function (e) {
    if (this.status == 200) {
      var blob = this.response;
      var reader = new FileReader();
      reader.readAsDataURL(blob);
      reader.onloadend = function () {
        var base64data = reader.result;
        var base64ContentArray = base64data.split(",");
        var mimeType = base64ContentArray[0].match(
          /[^:\s*]\w+\/[\w-+\d.]+(?=[;| ])/
        )[0];
        var decodedFile = base64ContentArray[1];
        console.log(mimeType);
        window.flutter_inappwebview.callHandler(
          "saveCanvas",
          decodedFile,
          mimeType
        );
      };
    }
  };
  xhr.send();
});
